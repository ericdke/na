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
        puts "\nAnalyzing conversation...\n".color(:cyan)
        action, workers, users, bucket = Action.new, Workers.new, [], []
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

        puts make_entry bookmark

        #Logs.rec.info "Added bookmark '#{convo_title}'."
        puts Status.done
      rescue => e
        Errors.global_error("mark/add", args, e)
      ensure
        Databases.close_all
      end
    end

    private

    def make_entry content
      entry = ""
      entry << "Bookmarked post id:\t#{content[:id]}\n"
      entry << "Title:\t\t\t#{content[:title]}\n" unless content[:title].is_integer?
      entry << "Date of post:\t\t#{content[:first_date]}\n"
      entry << "Date of bookmark:\t#{content[:mark_date]}\n"
      entry << "Posts in convo:\t\t#{content[:size]}\n"
      entry << "Original poster:\t@#{content[:first_poster]}\n"
      entry << "Last poster:\t\t@#{content[:last_poster]}\n"
      entry << "Posters:\t\t#{content[:users].join(', ')}\n"
      entry << "Alpha link:\t\t#{content[:url]}\n"
      entry << "Original text:\t\t#{content[:root_colorized_text]}\n"
    end

  end
end
