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

    def self.no_post stream, post_id
      if stream['meta']['code'] == 404
        puts Status.post_404(post_id)
        Errors.info("Impossible to find #{post_id}")
        exit
      end
    end

    def self.no_user stream, username
      if stream['meta']['code'] == 404
        puts Status.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end

  end

end
