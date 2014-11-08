# encoding: utf-8
module Ayadn
  class Status

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def self.done
      "\nDone.\n".color(:green)
    end

    def downloaded(name)
      info("downloaded", "#{Settings.config[:paths][:downloads]}/#{name}", "green")
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

    def posting
      info("connexion", "posting to ADN", "yellow")
    end

    def deleting_post(post_id)
      info("deleting", "post #{post_id}", "yellow")
    end

    def deleting_message(message_id)
      info("deleting", "message #{message_id}", "yellow")
    end

    def unfollowing(username)
      info("unfollowing", username, "yellow")
    end

    def following(username)
      info("following", username, "yellow")
    end

    def unmuting(username)
      info("unmuting", username, "yellow")
    end

    def muting(username)
      info("muting", username, "yellow")
    end

    def unblocking(username)
      info("unblocking", username, "yellow")
    end

    def blocking(username)
      info("blocking", username, "yellow")
    end

    def unreposting(post_id)
      info("unreposting", "post #{post_id}", "yellow")
    end

    def reposting(post_id)
      info("reposting", "post #{post_id}", "yellow")
    end

    def unstarring(post_id)
      info("unstarring", "post #{post_id}", "yellow")
    end

    def starring(post_id)
      info("starring", "post #{post_id}", "yellow")
    end

    def not_deleted(post_id)
      info("error", "could not delete post #{post_id} (post isn't yours, or is already deleted)", "red")
    end

    def not_deleted_m(post_id)
      info("error", "could not delete post #{post_id} (post isn't yours, or is already deleted)", "red")
    end

    def not_starred(post_id)
      info("error", "could not star post #{post_id} (post doesn't exist, or is already starred)", "red")
    end

    def not_unreposted(post_id)
      info("error", "could not unrepost post #{post_id} (post isn't yours, isn't a repost, or has been deleted)", "red")
    end

    def not_reposted(post_id)
      info("error", "could not repost post #{post_id} (post has been deleted?)", "red")
    end

    def not_unstarred(post_id)
      info("error", "could not unstar post #{post_id} (post isn't yours, isn't starred, or has been deleted)", "red")
    end

    def not_unfollowed(username)
      info("error", "could not unfollow user #{username} (doesn't exist, or wasn't already followed)", "red")
    end

    def not_followed(username)
      info("error", "could not follow user #{username} (doesn't exist, or you already follow)", "red")
    end

    def not_unmuted(username)
      info("error", "could not unmute user #{username} (doesn't exist, or wasn't already muted)", "red")
    end

    def not_muted(username)
      info("error", "could not mute user #{username} (doesn't exist, or is already muted)", "red")
    end

    def not_unblocked(username)
      info("error", "could not unblock user #{username} (doesn't exist, or wasn't already blocked)", "red")
    end

    def not_blocked(username)
      info("error", "could not block user #{username} (doesn't exist, or is already blocked)", "red")
    end

    def deleted(post_id)
      info("deleted", "post #{post_id}", "green")
    end

    def deleted_m(message_id)
      info("deleted", "message #{message_id}", "green")
    end

    def starred(post_id)
      info("starred", "post #{post_id}", "green")
    end

    def unreposted(post_id)
      info("unreposted", "post #{post_id}", "green")
    end

    def reposted(post_id)
      info("reposted", "post #{post_id}", "green")
    end

    def unstarred(post_id)
      info("unstarred", "post #{post_id}", "green")
    end

    def already_starred
      info("ok", "already starred", "green")
    end

    def already_reposted
      info("ok", "already reposted", "green")
    end

    def unfollowed(username)
      info("unfollowed", username, "green")
    end

    def followed(username)
      info("followed", username, "green")
    end

    def unmuted(username)
      info("unmuted", username, "green")
    end

    def muted(username)
      info("muted", username, "green")
    end

    def unblocked(username)
      info("unblocked", username, "green")
    end

    def blocked(username)
      info("blocked", username, "green")
    end

    def error_missing_title
      info("error", "please specify (part of) a movie title", "red")
    end

    def error_missing_username
      info("error", "please specify a username", "red")
    end

    def error_missing_post_id
      info("error", "please specify a post id", "red")
    end

    def error_missing_message_id
      info("error", "please specify a message id", "red")
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
      info("info", "the list is empty", "yellow")
    end

    def self.not_found
      "\n\n404 NOT FOUND - Object does not exist or has been deleted\n\n"
    end
    def self.stopped
      "\n\nStopped.".color(:red)
    end

    def writing
      puts "\nPosting as ".color(:cyan) + "#{Settings.config[:identity][:handle]}".color(:green) + ".".color(:cyan)
    end

    def yourpost
      puts "Your post:\n".color(:cyan)
    end

    def yourmessage username = nil
      if username.nil?
        puts "Your message:\n\n".color(:cyan)
      else
        puts "Your message to ".color(:cyan) + username.color(:green) + ":\n\n".color(:cyan)
      end
    end

    def message_from(username)
      puts "\nMessage from ".color(:cyan) + "#{Settings.config[:identity][:handle]} ".color(:green) + "to ".color(:cyan) + "#{username[0]}".color(:yellow) + ".".color(:cyan)
    end

    def replying_to(post_id)
      puts "\nReplying to post #{post_id}...\n".color(:green)
    end

    def self.readline
      "\nType your text. ".color(:cyan) + "[CTRL+D] ".color(:green) + "to validate, ".color(:cyan) + "[CTRL+C] ".color(:red) + "to cancel.\n".color(:cyan)
    end

    def reply
      puts "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum.\n"
    end

    def post
      puts "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum.\n"
    end

    def message
      puts "\n#{Settings.config[:message_max_length]} ".color(:yellow) + "characters maximum.\n"
    end

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
      info("info", "no new posts since your last visit with Ayadn", "cyan")
    end

    def no_new_messages
      info("info", "no new messages", "cyan")
    end

    def self.type_and_target_missing
      "\nYou have to submit a TYPE ('mention', 'hashtag', 'client') and a TARGET (a @username, a hashtag, a client name)\n\n".color(:red)
    end

    def self.wrong_arguments
      "\nYou have to submit valid arguments.\n\n".color(:red)
    end

    def no_pin_creds
      info("error", "Ayadn couldn't find your Pinboard credentials", "red")
    end

    def pin_creds_saved
      info("done", "credentials successfully encoded and saved", "green")
    end

    def saving_pin
      info("saving", "post text and links to Pinboard", "yellow")
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

    def wtf
      info("error", "an unkown error happened", "red")
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

    def not_your_repost
      info("error", "this post isn't one of your reposts", "red")
    end

    def not_your_starred
      info("error", "this isn't one of your starred posts", "red")
    end

    def auto
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
      info("error", "user #{username} doesn't exist (it could be a deleted account)", "red")
    end

    def post_404(post_id)
      info("error", "impossible to find #{post_id} (it may have been deleted)", "red")
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

    def no_movie
      info("error", "sorry, can't find this movie", "red")
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

    def info(status, message, color = nil)
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
