# encoding: utf-8
module Ayadn
  class Mark < Thor

    desc "add POST_ID (TITLE)", "Create a bookmark for this conversation"
    long_desc Descriptions.mark_add
    map "create" => :add
    def add(*args)
      begin
        init
        unless args.empty?
          double = args.dup
          post_id, convo_title = double.shift, double.join(' ')
        else
          abort Status.wrong_arguments
        end
        abort Status.error_missing_post_id unless post_id.is_integer?
        convo_title = post_id if convo_title == ''
        api, workers, view = API.new, Workers.new, View.new
        users, bucket = [], []
        view.clear_screen
        puts "\nAnalyzing conversation...\n".inverse
        resp = api.get_convo(post_id, options)
        posts = workers.build_posts(resp['data'].reverse)
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
        puts "Bookmarked conversation:\n".color(:green)
        puts make_entry bookmark
        Databases.add_bookmark bookmark
        Logs.rec.info "Added conversation bookmark for post #{bookmark['id']}."
        puts Status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      ensure
        Databases.close_all
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
        puts "\n"
        list.each {|marked| puts make_entry(JSON.parse(marked[1])); puts "\n"}
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      ensure
        Databases.close_all
      end
    end

    desc "clear", "Clear your bookmarks database"
    def clear
      begin
        init
        puts "\n\nAre you sure you want to erase all the content of your bookmarks database?\n\n[y/N]\n".color(:red)
        input = STDIN.getch
        if input == 'y' || input == 'Y'
          Databases.clear_bookmarks
          Logs.rec.info "Cleared the bookmarks database."
          puts Status.done
        else
          abort Status.canceled
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: []})
      ensure
        Databases.close_all
      end
    end

    desc "delete POST_ID", "Delete entry POST_ID from your bookmarked conversations"
    map "remove" => :delete
    long_desc Descriptions.mark_delete
    def delete *args
      begin
        init
        args.empty? ? abort(Status.wrong_arguments) : post_id = args[0]
        abort Status.error_missing_post_id unless post_id.is_integer?
        Databases.delete_bookmark post_id
        puts Status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      ensure
        Databases.close_all
      end
    end

    desc "rename POST_ID NEW_TITLE", "Rename bookmark POST_ID"
    long_desc Descriptions.mark_rename
    def rename *args
      begin
        init
        unless args.empty? || args[1].nil?
          arguments = args.dup
          post_id = arguments.shift
        else
          abort Status.wrong_arguments
        end
        abort Status.error_missing_post_id unless post_id.is_integer?
        Databases.rename_bookmark post_id, arguments.join(" ")
        puts Status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      ensure
        Databases.close_all
      end
    end

    private

    def make_entry content
      entry = ""
      entry << "Post id:".color(:cyan)
      entry << "\t#{content['id']}\n".color(Settings.options[:colors][:username])
      unless content['title'].is_integer?
        entry << "Title:".color(:cyan)
        entry << "\t\t#{content['title']}\n".color(Settings.options[:colors][:id])
      end
      entry << "Date:".color(:cyan)
      entry << "\t\t#{content['first_date']}\n".color(Settings.options[:colors][:date])
      # entry << "Bookmarked:".color(:cyan)
      # entry << "\t#{content['mark_date']}\n".color(Settings.options[:colors][:date])
      entry << "Posts:".color(:cyan)
      entry << "\t\t#{content['size']}\n".color(Settings.options[:colors][:name])
      entry << "Posters:".color(:cyan)
      posters = []
      content['users'].each {|mention| posters << "@#{mention}"}
      entry << "\t#{posters.join(', ')}\n".color(Settings.options[:colors][:mentions])
      # entry << "First:\t\t@#{content['first_poster']}\n"
      # entry << "Last:\t\t@#{content['last_poster']}\n"
      entry << "Link:".color(:cyan)
      entry << "\t\t#{content['url']}\n".color(Settings.options[:colors][:link])
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
