# encoding: utf-8
module Ayadn
  class Status

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def self.done
      "\nDone.\n".color(:green)
    end
    def self.downloaded(name)
      "\nFile downloaded in #{Settings.config[:paths][:downloads]}/#{name}\n".color(:green)
    end
    def self.links_saved(name)
      "\nLinks exported to file #{Settings.config[:paths][:lists]}/#{name}\n".color(:green)
    end
    def self.downloading
      "Downloading from ADN...\n\n".inverse
    end
    def self.uploading files
      files.length > 1 ? pl = "s" : pl = ""
      "\nUploading file#{pl} to ADN...".color(:cyan)
    end

    def self.posting
      "Posting to ADN...\n\n".inverse
    end
    def posting
      # @thor.say_status :status, 'posting', :yellow
      "Posting to ADN...\n\n".inverse
    end

    def self.deleting_post(post_id)
      "\nDeleting post #{post_id}\n".inverse
    end
    def self.deleting_message(message_id)
      "\nDeleting message #{message_id}\n".inverse
    end
    def self.unfollowing(username)
      "\nUnfollowing #{username}".inverse
    end
    def self.following(username)
      "\nFollowing #{username}".inverse
    end
    def self.unmuting(username)
      "\nUnmuting #{username}".inverse
    end
    def self.muting(username)
      "\nMuting #{username}".inverse
    end
    def self.unblocking(username)
      "\nUnblocking #{username}".inverse
    end
    def self.blocking(username)
      "\nBlocking #{username}".inverse
    end
    def self.unreposting(post_id)
      "\nUnreposting #{post_id}".inverse
    end
    def self.reposting(post_id)
      "\nReposting #{post_id}".inverse
    end
    def self.unstarring(post_id)
      "\nUnstarring #{post_id}".inverse
    end
    def self.starring(post_id)
      "\nStarring #{post_id}".inverse
    end
    def self.not_deleted(post_id)
      "\nCould not delete post #{post_id} (post isn't yours, or is already deleted)\n".color(:red)
    end
    def self.not_starred(post_id)
      "\nCould not star post #{post_id} (post doesn't exist, or is already starred)\n".color(:red)
    end
    def self.not_unreposted(post_id)
      "\nCould not unrepost post #{post_id} (post isn't yours, isn't a repost, or has been deleted)\n".color(:red)
    end
    def self.not_reposted(post_id)
      "\nCould not repost post #{post_id} (post has been deleted?)\n".color(:red)
    end
    def self.not_unstarred(post_id)
      "\nCould not unstar post #{post_id} (post isn't yours, isn't starred, or has been deleted)\n".color(:red)
    end
    def self.not_unfollowed(post_id)
      "\nCould not unfollow user #{username} (doesn't exist, or wasn't already followed)\n".color(:red)
    end
    def self.not_followed(post_id)
      "\nCould not follow user #{username} (doesn't exist, or you already follow)\n".color(:red)
    end
    def self.not_unmuted(post_id)
      "\nCould not unmute user #{username} (doesn't exist, or wasn't already muted)\n".color(:red)
    end
    def self.not_muted(post_id)
      "\nCould not mute user #{username} (doesn't exist, or is already muted)\n".color(:red)
    end
    def self.not_unblocked(post_id)
      "\nCould not unblock user #{username} (doesn't exist, or wasn't already blocked)\n".color(:red)
    end
    def self.not_blocked(post_id)
      "\nCould not block user #{username} (doesn't exist, or is already blocked)\n".color(:red)
    end

    def deleted(post_id)
      print("deleted", "post #{post_id}", "green")
    end

    def deleted_m(message_id)
      print("deleted", "message #{message_id}", "green")
    end

    def starred(post_id)
      print("starred", "post #{post_id}", "green")
    end

    def unreposted(post_id)
      print("unreposted", "post #{post_id}", "green")
    end

    def reposted(post_id)
      print("reposted", "post #{post_id}", "green")
    end

    def unstarred(post_id)
      print("unstarred", "post #{post_id}", "green")
    end

    def already_starred
      print("ok", "already starred", "green")
    end

    def already_reposted
      print("ok", "already reposted", "green")
    end

    def unfollowed(username)
      print("unfollowed", username, "green")
    end

    def followed(username)
      print("followed", username, "green")
    end

    def unmuted(username)
      print("unmuted", username, "green")
    end

    def muted(username)
      print("muted", username, "green")
    end

    def unblocked(username)
      print("unblocked", username, "green")
    end

    def blocked(username)
      print("blocked", username, "green")
    end

    def self.error_missing_title
      "\nYou have to specify (part of) a movie title.\n".color(:red)
    end

    def error_missing_username
      print("error", "please specify a username", "red")
    end

    def error_missing_post_id
      print("error", "please specify a post id", "red")
    end

    def self.error_missing_message_id
      "\nYou have to specify a message id.\n".color(:red)
    end
    def self.error_missing_channel_id
      "\nYou have to specify a channel id.\n".color(:red)
    end
    def self.error_missing_hashtag
      "\nYou have to specify one or more hashtag(s).\n".color(:red)
    end
    def self.error_missing_parameters
      "\nYou have to submit valid items. See 'ayadn -sg' for a list of valid parameters and values.\n".color(:red)
    end

    def empty_list
      print("info", "the list is empty", "yellow")
    end

    def self.not_found
      "\n\n404 NOT FOUND - Object does not exist or has been deleted\n\n"
    end
    def self.stopped
      "\n\nStopped.".color(:red)
    end
    def self.writing
      "\nPosting as ".color(:cyan) + "#{Settings.config[:identity][:handle]}".color(:green) + ".".color(:cyan)
    end
    def self.yourpost
      "Your post:\n".color(:cyan)
    end
    def self.yourmessage username = nil
      if username.nil?
        "Your message:\n\n".color(:cyan)
      else
        "Your message to ".color(:cyan) + username.color(:green) + ":\n\n".color(:cyan)
      end
    end
    def self.message_from(username)
      "\nMessage from ".color(:cyan) + "#{Settings.config[:identity][:handle]} ".color(:green) + "to ".color(:cyan) + "#{username[0]}".color(:yellow) + ".".color(:cyan)
    end
    def self.replying_to(post_id)
      "\nReplying to post #{post_id}...\n".color(:green)
    end
    def self.readline
      "\nType your text. ".color(:cyan) + "[CTRL+D] ".color(:green) + "to validate, ".color(:cyan) + "[CTRL+C] ".color(:red) + "to cancel.\n".color(:cyan)
    end
    # def self.classic
    #   "\nType your text. ".color(:cyan) + "[ENTER] ".color(:green) + "to validate, ".color(:cyan) + "[CTRL+C] ".color(:red) + "to cancel.\n\n".color(:cyan)
    # end
    def self.reply
      "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum.\n"
    end
    def self.post
      "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum.\n"
    end
    def self.message
      "\n#{Settings.config[:message_max_length]} ".color(:yellow) + "characters maximum.\n"
    end
    # def self.method_missing(meth, args)
    #   "\nThe command '#{meth} #{args}' doesn't exist.\n".color(:red)
    # end
    def self.valid_colors(colors_list)
      "\nThe valid colors are: #{colors_list}\n".color(:cyan)
    end
    def self.not_mutable
      "\nThis parameter is not modifiable for the time being, sorry.\n".color(:red)
    end
    def self.must_be_integer
      "\nThis paramater must be an integer between 1 and 200.\n".color(:red)
    end

    def no_new_posts
      print("info", "no new posts since your last visit with Ayadn", "cyan")
    end

    def self.no_new_messages
      "\n   No new messages since your last visit.\n".color(:cyan)
    end
    def self.type_and_target_missing
      "\nYou have to submit a TYPE ('mention', 'hashtag', 'client') and a TARGET (a @username, a hashtag, a client name)\n\n".color(:red)
    end
    def self.wrong_arguments
      "\nYou have to submit valid arguments.\n\n".color(:red)
    end
    def self.no_pin_creds
      "\nAyadn couldn't find your Pinboard credentials.\n".color(:red)
    end
    def self.pin_creds_saved
      "\n\nCredentials successfully encoded and saved in database.\n\n".color(:green)
    end
    def self.saving_pin
      "\nSaving post text and links to Pinboard...\n\n".color(:yellow)
    end
    def self.error_only_osx
      "\nThis feature only works with iTunes by default. If you've got a Last.fm account, add the option:\n\n`ayadn -np --lastfm` (short: `-l`).\n\n".color(:red)
    end
    def self.empty_fields
      "\nCanceled: couldn't get enough information (empty field).\n\n".color(:red)
    end
    def self.canceled
      "\n\nCanceled.\n\n".color(:cyan)
    end
    def self.not_authorized
      "\nYou need to authorize Ayadn before using it.\n\nPlease run 'ayadn -auth' :)\n\n".color(:red)
    end
    def self.wtf
      "\nSomething wrong happened. :(\n\n".color(:red)
    end
    def self.redirecting
      "\nPost is a repost. Redirecting...\n".color(:cyan)
    end
    def self.nobody_reposted
      "\nNobody reposted this post.\n\n".color(:red)
    end
    def self.nobody_starred
      "\nNobody starred this post.\n\n".color(:red)
    end
    def self.not_your_repost
      "\nThis post isn't one of your reposts.\n\n".color(:red)
    end
    def self.not_your_starred
      "\nThis isn't one of your starred posts.\n\n".color(:red)
    end
    def self.auto
      view = "\nEntering the auto posting mode.\n\n".color(:cyan)
      view << "In this mode, each line you type (each time you hit ENTER!) is automatically posted to ADN.\n\n".color(:cyan)
      view << "At any moment, starting now, hit CTRL+C to exit.\n\n".color(:yellow)
      view << "\n\t--AUTO POSTING MODE ACTIVATED--\n\n".color(:red)
    end
    def self.reducing db
      "\nPlease wait while Ayadn is pruning and compacting the #{db} database...\n".color(:cyan)
    end
    def self.cache_range
      "\nPlease enter a number of hours between 1 and 168.\n\n".color(:red)
    end
    def self.threshold
      "\nPlease enter a value between 0.1 and 3.5, example: 2.1\n\n".color(:red)
    end
    def self.must_be_in_index
      "\nNumber must be in the range of the indexed posts.\n".color(:red)
    end

    def user_404(username)
      print("error", "user #{username} doesn't exist (it could be a deleted account)", "red")
    end

    def post_404(post_id)
      print("error", "impossible to find #{post_id} (it may have been deleted)", "red")
    end

    def self.no_alias
      "\nThis alias doesn't exist.\n\n".color(:red)
    end
    def self.no_itunes
      "\nCanceled: unable to get info from iTunes.\n".color(:red)
    end
    def self.pin_username
      "Please enter your Pinboard username (CTRL+C to cancel): ".color(:green)
    end
    def self.pin_password
      "\nPlease enter your Pinboard password (invisible, CTRL+C to cancel): ".color(:green)
    end
    def self.too_long size, max_size
      "\n\nCanceled: too long. #{max_size} max, #{size - max_size} characters to remove.\n\n\n".color(:red)
    end
    def self.no_text
      "\n\nYou should provide some text.\n\n".color(:red)
    end
    def self.bad_path
      "\n\nCouldn't upload this file (path seems wrong).\n\n".color(:red)
    end
    def self.no_curl
      "\n\nAyadn needs 'curl' to upload files. Please install 'curl' (or check that it's properly declared in your $PATH).\n\n".color(:red)
    end
    def self.itunes_store
      "Fetching informations from the Itunes Store...\n".color(:green)
    end
    def self.fetching_from source
      "\nFetching informations from #{source}...\n".color(:green)
    end
    def self.no_movie
      "\nSorry, can't find this movie.\n".color(:blue)
    end
    def self.no_show
      "\nSorry, can't find this show.\n".color(:blue)
    end
    def self.no_show_infos
      "\nSorry, can't find informations about this show.\n".color(:blue)
    end
    def self.no_force target
      "\n'#{target}' can't be displayed (could be muted, blocked, in the Blacklist, etc). Use option '--force' ('-f') to try and display this content anyway.\n\n".color(:blue)
    end
    def self.profile_options
      "\n\nYou have to specify what to update or delete: --bio, --name, --blog, --twitter or --web.\n\n".color(:red)
    end
    def self.one_username
      "\n\nYou can specify only one username.\n".color(:red)
    end

    private

    def print(status, message, color = nil)
      if color.nil?
        lamb = lambda { @thor.say_status(status.to_sym, message.to_s) }
      else
        lamb = lambda { @thor.say_status(status.to_sym, message.to_s, color.to_sym) }
      end
      puts "\n"
      lamb.call
      puts "\n"
    end

  end
end
