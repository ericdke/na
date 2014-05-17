# encoding: utf-8
module Ayadn
  class Mark < Thor

    desc "add POST_ID (TITLE)", "Create a bookmark for this conversation"
    long_desc Descriptions.mark_add
    def add(*args)
      begin
        unless args.empty?
          post_id, convo_title = args[0], args[1]
        else
          abort Status.wrong_arguments
        end
        abort Status.error_missing_post_id unless post_id.is_integer?
        convo_title = post_id if convo_title.nil?
        action, workers, view, users, bucket = Action.new, Workers.new, View.new, [], []
        view.clear_screen
        puts "\nAnalyzing conversation...\n".inverse
        stream = action.get_convo post_id, options
        posts = workers.build_posts(stream['data'].reverse)
        posts.each do |id, post|
          users << "@#{post[:original_poster]}"
          post[:mentions].each {|mention| users << "@#{mention}"}
          bucket << post
        end
        users.uniq!
        now = Time.now.to_s
        bookmark = {
          id: post_id,
          root_id: bucket[0][:id],
          last_id: (bucket.last)[:id],
          title: convo_title,
          first_date: bucket[0][:date],
          last_date: (bucket.last)[:date],
          mark_date: now[0..18],
          first_poster: bucket[0][:original_poster],
          last_poster: (bucket.last)[:username],
          users: users,
          size: bucket.length,
          url: bucket[0][:canonical_url],
          root_text: bucket[0][:raw_text],
          root_colorized_text: bucket[0][:text]
        }
        view.clear_screen
        puts "Bookmarked conversation:\n".color(:green)
        puts make_entry bookmark
        Databases.add_bookmark bookmark
        Logs.rec.info "Added conversation bookmark for post #{bookmark[:id]}."
        puts Status.done
      rescue => e
        Errors.global_error("mark/add", args, e)
      ensure
        Databases.close_all
      end
    end

    desc "list", "List your bookmarked conversations"
    long_desc Descriptions.mark_list
    def list
      begin
        init
        list = []
        Databases.bookmarks.each {|i,v| list << v}
        puts "\n"
        list.each {|marked| puts make_entry marked; puts "\n"}
      rescue => e
        Errors.global_error("mark/list", nil, e)
      ensure
        Databases.close_all
      end
    end

    private

    def make_entry content
      entry = ""
      entry << "Post id:".color(:cyan)
      entry << "\t#{content[:id]}\n".color(Settings.options[:colors][:id])
      unless content[:title].is_integer?
        entry << "Title:".color(:cyan)
        entry << "\t\t#{content[:title]}\n".color(Settings.options[:colors][:id])
      end
      entry << "Date:".color(:cyan)
      entry << "\t\t#{content[:first_date]}\n".color(Settings.options[:colors][:date])
      # entry << "Bookmarked:".color(:cyan)
      # entry << "\t#{content[:mark_date]}\n".color(Settings.options[:colors][:date])
      entry << "Posts:".color(:cyan)
      entry << "\t\t#{content[:size]}\n".color(Settings.options[:colors][:name])
      entry << "Posters:".color(:cyan)
      entry << "\t#{content[:users].join(', ')}\n".color(Settings.options[:colors][:mentions])
      # entry << "First:\t\t@#{content[:first_poster]}\n"
      # entry << "Last:\t\t@#{content[:last_poster]}\n"
      entry << "Link:".color(:cyan)
      entry << "\t\t#{content[:url]}\n".color(Settings.options[:colors][:link])
      entry << "Beginning:".color(:cyan)
      entry << "\t#{content[:root_colorized_text][0..40]} [...]\n"
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
