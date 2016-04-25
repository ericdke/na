# encoding: utf-8
module Ayadn
  class Mark < Thor

    desc "add POST_ID (TITLE)", "Create a bookmark for this conversation"
    long_desc Descriptions.mark_add
    map "create" => :add
    option :force, aliases: "-f", type: :boolean, desc: Descriptions.options_force
    def add(*args)
      begin
        init
        status = Status.new
        unless args.empty?
          double = args.dup
          post_id, convo_title = double.shift, double.join(' ')
        else
          status.wrong_arguments
          exit
        end
        Check.new.bad_post_id(post_id)
        if options[:force]
          Settings.global.force = true
        else
          post_id = Workers.new.get_real_post_id(post_id)
        end
        convo_title = post_id if convo_title == ''
        api, workers, view = API.new, Workers.new, View.new
        users, bucket = [], []
        view.clear_screen
        status.info(:connected, "analyzing conversation", :yellow)
        resp = api.get_convo(post_id, options)
        stream_object = StreamObject.new(resp)
        posts = workers.build_posts(stream_object.posts.reverse)
        posts.each do |id, post|
          users << "#{post[:original_poster]}"
          post[:mentions].each {|mention| users << "#{mention}"}
          bucket << post
        end
        users.uniq!
        now = Time.now.to_s
        bookmark = {
          'id' => post_id,
          'root_id' => bucket[0][:id],
          'last_id' => (bucket.last)[:id],
          'title' => convo_title,
          'first_date' => bucket[0][:date],
          'last_date' => (bucket.last)[:date],
          'mark_date' => now[0..18],
          'first_poster' => bucket[0][:original_poster],
          'last_poster' => (bucket.last)[:username],
          'users' => users,
          'size' => bucket.length,
          'url' => bucket[0][:canonical_url],
          'root_text' => bucket[0][:raw_text],
          'root_colorized_text' => bucket[0][:text]
        }
        view.clear_screen
        status.info(:done, "bookmarked conversation:", :green)
        puts make_entry bookmark
        Databases.add_bookmark bookmark
        Logs.rec.info "Added conversation bookmark for post #{bookmark['id']}."
        status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      end
    end

    desc "list", "List your bookmarked conversations"
    long_desc Descriptions.mark_list
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def list
      begin
        init
        list = Databases.all_bookmarks
        if options[:raw]
          jj JSON.parse(list.to_json)
          exit
        end
        if list.empty?
          Status.new.empty_list
          exit
        end
        puts "\n"
        list.each {|marked| puts make_entry(JSON.parse(marked[1])); puts "\n"}
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    desc "clear", "Clear your bookmarks database"
    def clear
      begin
        init
        status = Status.new
        status.ask_clear_bookmarks
        input = STDIN.getch
        if input == 'y' || input == 'Y'
          Databases.clear_bookmarks
          Logs.rec.info "Cleared the bookmarks database."
          status.done
        else
          status.canceled
          exit
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: []})
      end
    end

    desc "delete POST_ID", "Delete entry POST_ID from your bookmarked conversations"
    map "remove" => :delete
    long_desc Descriptions.mark_delete
    option :force, aliases: "-f", type: :boolean, desc: Descriptions.options_force
    def delete(*args)
      begin
        init
        status = Status.new
        if args.empty?
          status.wrong_arguments
          exit
        else
          post_id = args[0]
        end
        Check.new.bad_post_id(post_id)
        if options[:force]
          Settings.global.force = true
        else
          post_id = Workers.new.get_real_post_id(post_id)
        end
        Databases.delete_bookmark post_id
        status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      end
    end

    desc "rename POST_ID NEW_TITLE", "Rename bookmark POST_ID"
    long_desc Descriptions.mark_rename
    option :force, aliases: "-f", type: :boolean, desc: Descriptions.options_force
    def rename(*args)
      begin
        init
        status = Status.new
        unless args.empty? || args[1].nil?
          arguments = args.dup
          post_id = arguments.shift
        else
          abort Status.wrong_arguments
        end
        Check.new.bad_post_id(post_id)
        if options[:force]
          Settings.global.force = true
        else
          post_id = Workers.new.get_real_post_id(post_id)
        end
        Databases.rename_bookmark post_id, arguments.join(" ")
        status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      end
    end

    private

    def make_entry content
      entry = ""
      entry << "Post id:".color(:cyan)
      entry << "\t#{content['id']}\n".color(Settings.options.colors.username)
      unless content['title'].is_integer?
        entry << "Title:".color(:cyan)
        entry << "\t\t#{content['title']}\n".color(Settings.options.colors.id)
      end
      entry << "Date:".color(:cyan)
      entry << "\t\t#{content['first_date']}\n".color(Settings.options.colors.date)
      # entry << "Bookmarked:".color(:cyan)
      # entry << "\t#{content['mark_date']}\n".color(Settings.options.colors.date)
      entry << "Posts:".color(:cyan)
      entry << "\t\t#{content['size']}\n".color(Settings.options.colors.name)
      entry << "Posters:".color(:cyan)
      posters = []
      content['users'].each {|mention| posters << "@#{mention}"}
      entry << "\t#{posters.join(', ')}\n".color(Settings.options.colors.mentions)
      # entry << "First:\t\t@#{content['first_poster']}\n"
      # entry << "Last:\t\t@#{content['last_poster']}\n"
      entry << "Link:".color(:cyan)
      entry << "\t\t#{content['url']}\n".color(Settings.options.colors.link)
      entry << "Beginning:".color(:cyan)
      text = content['root_text'].gsub(/[\r\n]/, ' ')
      if text.length <= 60
        entry << "\t#{text}\n"
      else
        entry << "\t#{text[0..60]} [...]\n"
      end
    end

    def init
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

  end
end
