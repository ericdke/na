# encoding: utf-8
module Ayadn

  class Check

    def initialize
      @status = Status.new
    end

    def same_username(stream)
      stream['data']['username'] == Settings.config[:identity][:username]
    end

    def auto_save_muted(list)
      FileOps.save_muted_list(list) if Settings.options[:backup][:lists]
    end

    def auto_save_followers(list)
      FileOps.save_followers_list(list) if Settings.options[:backup][:lists]
    end

    def auto_save_followings(list)
      FileOps.save_followings_list(list) if Settings.options[:backup][:lists]
    end

    def no_username username
      if username.empty?
        @status.error_missing_username
        exit
      end
    end

    def no_data stream, target
      if stream['data'].empty?
        Errors.warn "In action/#{target}: no data"
        @status.empty_list
        exit
      end
    end

    def no_new_posts stream, options, title
      if options[:new] == true
        unless Databases.has_new?(stream, title)
          @status.no_new_posts
          exit
        end
      end
    end

    def no_post stream, post_id
      if stream['meta']['code'] == 404
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

    def no_user stream, username
      if stream['meta']['code'] == 404
        @status.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end

    def has_been_unfollowed(username, resp)
      if resp['meta']['code'] == 200
        @status.unfollowed(username)
        Logs.rec.info "Unfollowed #{username}."
      else
        Errors.whine(Status.not_unfollowed(username), resp)
      end
    end

    def has_been_unmuted(username, resp)
      if resp['meta']['code'] == 200
        @status.unmuted(username)
        Logs.rec.info "Unmuted #{username}."
      else
        Errors.whine(Status.not_unmuted(username), resp)
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
        Logs.rec.info "Starred #{post_id}."
      else
        Errors.whine(Status.not_starred(post_id), resp)
      end
    end

    def has_been_reposted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.reposted(post_id)
        Logs.rec.info "Reposted #{post_id}."
      else
        Errors.whine(Status.not_reposted(post_id), resp)
      end
    end

    def has_been_blocked(username, resp)
      if resp['meta']['code'] == 200
        @status.blocked(username)
        Logs.rec.info "Blocked #{username}."
      else
        Errors.whine(Status.not_blocked(username), resp)
      end
    end

    def has_been_muted(username, resp)
      if resp['meta']['code'] == 200
        @status.muted(username)
        Logs.rec.info "Muted #{username}."
      else
        Errors.whine(Status.not_muted(username), resp)
      end
    end

    def has_been_followed(username, resp)
      if resp['meta']['code'] == 200
        @status.followed(username)
        Logs.rec.info "Followed #{username}."
      else
        Errors.whine(Status.not_followed(username), resp)
      end
    end

    def has_been_deleted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.deleted(post_id)
        Logs.rec.info "Deleted post #{post_id}."
      else
        Errors.whine(Status.not_deleted(post_id), resp)
      end
    end

    def message_has_been_deleted(message_id, resp)
      if resp['meta']['code'] == 200
        @status.deleted_m(message_id)
        Logs.rec.info "Deleted message #{message_id}."
      else
        Errors.whine(Status.not_deleted(message_id), resp)
      end
    end

    def has_been_unblocked(username, resp)
      if resp['meta']['code'] == 200
        @status.unblocked(username)
        Logs.rec.info "Unblocked #{username}."
      else
        Errors.whine(Status.not_unblocked(username), resp)
      end
    end

    def has_been_unstarred(post_id, resp)
      if resp['meta']['code'] == 200
        @status.unstarred(post_id)
        Logs.rec.info "Unstarred #{post_id}."
      else
        Errors.whine(Status.not_unstarred(post_id), resp)
      end
    end

    def has_been_unreposted(post_id, resp)
      if resp['meta']['code'] == 200
        @status.unreposted(post_id)
        Logs.rec.info "Unreposted #{post_id}."
      else
        Errors.whine(Status.not_unreposted(post_id), resp)
      end
    end



  end

end
