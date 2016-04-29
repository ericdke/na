# encoding: utf-8
module Ayadn

  class Check

    def initialize
      @status = Status.new
    end

    def same_username(user_object)
      user_object.username == Settings.config.identity.username
    end

    def auto_save_muted(list)
      FileOps.save_muted_list(list) if Settings.options.backup.lists
    end

    def auto_save_followers(list)
      FileOps.save_followers_list(list) if Settings.options.backup.lists
    end

    def auto_save_followings(list)
      FileOps.save_followings_list(list) if Settings.options.backup.lists
    end

    def no_username username
      if username.empty?
        @status.error_missing_username
        exit
      end
    end

    def no_data stream, target
      if stream.posts.empty?
        Errors.warn "In action/#{target}: no data"
        @status.empty_list
        exit
      end
    end

    def no_new_posts stream, options, title
      if options[:new]
        unless Databases.has_new?(stream, title)
          @status.no_new_posts
          exit
        end
      end
    end

    def no_post stream, post_id
      if stream.meta.code == 404
        @status.post_404(post_id)
        Errors.info("Impossible to find #{post_id}")
        exit
      end
    end

    def no_details stream, post_id
      if stream["meta"]["code"] == 404
        @status.post_404(post_id)
        Errors.info("Impossible to find #{post_id}")
        exit
      end
    end

    def bad_post_id post_id
      unless post_id.is_integer?
        @status.error_missing_post_id
        exit
      end
    end

    def bad_post_ids(post_ids)
      post_ids.each do |id|
        unless id.is_integer?
          @status.error_missing_post_id
          exit
        end
      end
    end

    def no_user stream, username
      if stream.meta.code == 404
        @status.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end

    def has_been_unfollowed(username, resp)
      if resp['meta']['code'] == 200
        @status.unfollowed(username)
      else
        @status.not_unfollowed(username)
      end
    end

    def has_been_unmuted(username, resp)
      if resp['meta']['code'] == 200
        @status.unmuted(username)
      else
        @status.not_unmuted(username)
      end
    end

    def already_starred(resp)
      if resp['data']['you_starred']
        @status.already_starred
        exit
      end
    end

    def already_reposted(resp)
      if resp['data']['you_reposted']
        @status.already_reposted
        exit
      end
    end

    def has_been_starred(post_id, resp)
      if resp['meta']['code'] == 200
        @status.starred(post_id)
      else
        @status.not_starred(post_id)
      end
    end

    def has_been_reposted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.reposted(post_id)
      else
        @status.not_reposted(post_id)
      end
    end

    def has_been_blocked(username, resp)
      if resp['meta']['code'] == 200
        @status.blocked(username)
      else
        @status.not_blocked(username)
      end
    end

    def has_been_muted(username, resp)
      if resp['meta']['code'] == 200
        @status.muted(username)
      else
        @status.not_muted(username)
      end
    end

    def has_been_followed(username, resp)
      if resp['meta']['code'] == 200
        @status.followed(username)
      else
        @status.not_followed(username)
      end
    end

    def has_been_deleted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.deleted(post_id)
      else
        @status.not_deleted(post_id)
      end
    end

    def message_has_been_deleted(message_id, resp)
      if resp['meta']['code'] == 200
        @status.deleted_m(message_id)
      else
        @status.not_deleted_m(message_id)
      end
    end

    def has_been_unblocked(username, resp)
      if resp['meta']['code'] == 200
        @status.unblocked(username)
      else
        @status.not_unblocked(username)
      end
    end

    def has_been_unstarred(post_id, resp)
      if resp['meta']['code'] == 200
        @status.unstarred(post_id)
      else
        @status.not_unstarred(post_id)
      end
    end

    def has_been_unreposted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.unreposted(post_id)
      else
        @status.not_unreposted(post_id)
      end
    end

  end

end
