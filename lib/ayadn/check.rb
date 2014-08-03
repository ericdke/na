# encoding: utf-8
module Ayadn

  class Check

    def self.same_username(stream)
      stream['data']['username'] == Settings.config[:identity][:username]
    end

    def self.auto_save_muted(list)
      FileOps.save_muted_list(list) if Settings.options[:backup][:auto_save_lists]
    end

    def self.auto_save_followers(list)
      FileOps.save_followers_list(list) if Settings.options[:backup][:auto_save_lists]
    end

    def self.auto_save_followings(list)
      FileOps.save_followings_list(list) if Settings.options[:backup][:auto_save_lists]
    end

    def self.no_username username
      abort(Status.error_missing_username) if username.empty?
    end

    def self.no_data stream, target
      if stream['data'].empty?
        Errors.warn "In action/#{target}: no data"
        abort(Status.empty_list)
      end
    end

    def self.no_new_posts stream, options, title
      if options[:new]
        unless Databases.has_new?(stream, title)
          abort(Status.no_new_posts)
        end
      end
    end

    def self.no_post stream, post_id
      if stream['meta']['code'] == 404
        puts Status.post_404(post_id)
        Errors.info("Impossible to find #{post_id}")
        exit
      end
    end

    def self.bad_post_id post_id
      abort(Status.error_missing_post_id) unless post_id.is_integer?
    end

    def self.no_user stream, username
      if stream['meta']['code'] == 404
        puts Status.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end

    def self.has_been_unfollowed(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unfollowed(username)
        Logs.rec.info "Unfollowed #{username}."
      else
        Errors.whine(Status.not_unfollowed(username), resp)
      end
    end

    def self.has_been_unmuted(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unmuted(username)
        Logs.rec.info "Unmuted #{username}."
      else
        Errors.whine(Status.not_unmuted(username), resp)
      end
    end

    def self.already_starred(resp)
      if resp['data']['you_starred']
        puts "\nYou already starred this post.\n".color(:red)
        exit
      end
    end

    def self.already_reposted(resp)
      if resp['data']['you_reposted']
        puts "\nYou already reposted this post.\n".color(:red)
        exit
      end
    end

    def self.has_been_starred(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.starred(post_id)
        Logs.rec.info "Starred #{post_id}."
      else
        Errors.whine(Status.not_starred(post_id), resp)
      end
    end

    def self.has_been_reposted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.reposted(post_id)
        Logs.rec.info "Reposted #{post_id}."
      else
        Errors.whine(Status.not_reposted(post_id), resp)
      end
    end

    def self.has_been_blocked(username, resp)
      if resp['meta']['code'] == 200
        puts Status.blocked(username)
        Logs.rec.info "Blocked #{username}."
      else
        Errors.whine(Status.not_blocked(username), resp)
      end
    end

    def self.has_been_muted(username, resp)
      if resp['meta']['code'] == 200
        puts Status.muted(username)
        Logs.rec.info "Muted #{username}."
      else
        Errors.whine(Status.not_muted(username), resp)
      end
    end

    def self.has_been_followed(username, resp)
      if resp['meta']['code'] == 200
        puts Status.followed(username)
        Logs.rec.info "Followed #{username}."
      else
        Errors.whine(Status.not_followed(username), resp)
      end
    end

    def self.has_been_deleted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.deleted(post_id)
        Logs.rec.info "Deleted post #{post_id}."
      else
        Errors.whine(Status.not_deleted(post_id), resp)
      end
    end

    def self.message_has_been_deleted(message_id, resp)
      if resp['meta']['code'] == 200
        puts Status.deleted_m(message_id)
        Logs.rec.info "Deleted message #{message_id}."
      else
        Errors.whine(Status.not_deleted(message_id), resp)
      end
    end

    def self.has_been_unblocked(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unblocked(username)
        Logs.rec.info "Unblocked #{username}."
      else
        Errors.whine(Status.not_unblocked(username), resp)
      end
    end

    def self.has_been_unstarred(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.unstarred(post_id)
        Logs.rec.info "Unstarred #{post_id}."
      else
        Errors.whine(Status.not_unstarred(post_id), resp)
      end
    end

    def self.has_been_unreposted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.unreposted(post_id)
        Logs.rec.info "Unreposted #{post_id}."
      else
        Errors.whine(Status.not_unreposted(post_id), resp)
      end
    end



  end

end
