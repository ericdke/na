# encoding: utf-8
module Ayadn
  class Mark < Thor

    desc "add POST_ID (CONVO_NAME)", "Create (and name) a bookmark for this conversation"
    long_desc Descriptions.mark_add
    def add(*args)
      begin
        unless args.empty?
          post_id, convo_name = args[0], args[1]
        else
          abort Status.wrong_arguments
        end
        abort Status.error_missing_post_id unless post_id.is_integer?
        convo_name = post_id if convo_name.nil?
        puts "\nAnalyzing conversation...\n\n".color(:cyan)
        action, workers, users, bucket = Action.new, Workers.new, [], []
        stream = action.get_convo post_id, options
        posts = workers.build_posts(stream['data'].reverse)
        posts.each do |id, post|
          users << post[:original_poster]
          post[:mentions].each {|mention| users << mention}
          bucket << post
        end
        users.uniq!

        bookmark = {
          id: post_id,
          root_id: bucket[0][:id],
          last_id: (bucket.last)[:id],
          name: convo_name,
          first_date: bucket[0][:date],
          last_date: (bucket.last)[:date],
          first_poster: bucket[0][:original_poster],
          last_poster: (bucket.last)[:username],
          users: users,
          size: bucket.length,
          url: bucket[0][:canonical_url],
          root_text: bucket[0][:raw_text],
          root_colorized_text: bucket[0][:text]
        }

        puts bookmark.inspect

        #Logs.rec.info "Added bookmark '#{convo_name}'."
        puts Status.done
      rescue => e
        Errors.global_error("mark/add", args, e)
      ensure
        Databases.close_all
      end
    end

  end
end
