# encoding: utf-8
module Ayadn
  class Status

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def done
      info("done", "", "green")
    end

    def canceled
      say do
        puts "\n"
        @thor.say_status :canceled, "", :red
      end
    end

    def downloaded(name)
      info("downloaded", "#{Settings.config[:paths][:downloads]}/#{name}", "green")
    end

    def links_saved(name)
      info("done", "links exported to file #{Settings.config[:paths][:lists]}/#{name}", "green")
    end

    def downloading
      info("connected", "downloading from ADN", "yellow")
    end

    def posting
      info("connected", "posting to ADN", "yellow")
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

    def error_missing_channel_id
      info("error", "please specify a channel id", "red")
    end

    def error_missing_parameters
      say do
        @thor.say_status :error, "please submit valid items", :red
        @thor.say_status :info, "see `ayadn -sg` for a list of valid parameters and values", :cyan
      end
    end

    def empty_list
      info("info", "the list is empty", "yellow")
    end

    def writing
      puts "\n"
      @thor.say_status "author", "#{Settings.config[:identity][:handle]}", "cyan"
    end

    def yourpost
      @thor.say_status "info", "your post:", "cyan"
    end

    def yourmessage username = nil
      if username.nil?
        @thor.say_status "info", "your message:", "cyan"
      else
        @thor.say_status "info", "your message to #{username}:", "cyan"
      end
    end

    def message_from(username)
      puts "\n"
      @thor.say_status "from", "#{Settings.config[:identity][:handle]}", "yellow"
      @thor.say_status "to", "#{username[0]}", "yellow"
    end

    def replying_to(post_id)
      puts "\n"
      @thor.say_status "replying", "to post #{post_id}", "yellow"
    end

    def readline
      say do
        @thor.say_status :next, "type your text", :cyan
        @thor.say_status :ok, "[CTRL+D] to validate", :cyan
        @thor.say_status :cancel, "[CTRL+C] to cancel", :cyan
      end
    end

    def reply
      @thor.say_status "max", "#{Settings.config[:post_max_length]} characters", "cyan"
    end

    def post
      @thor.say_status "max", "#{Settings.config[:post_max_length]} characters", "cyan"
    end

    def message
      @thor.say_status "max", "#{Settings.config[:message_max_length]} characters", "cyan"
    end

    def valid_colors(colors_list)
      @thor.say_status "info", "valid colors:", "cyan"
      say { puts colors_list }
    end

    def must_be_integer
      info("error", "this paramater must be an integer between 1 and 200", "red")
    end

    def no_new_posts
      info("info", "no new posts since your last visit with Ayadn", "cyan")
    end

    def no_new_messages
      info("info", "no new messages", "cyan")
    end

    def type_and_target_missing
      info("error", "please submit a TYPE ('mention', 'hashtag', 'client') and a TARGET (a @username, a hashtag, a client name)", "red")
    end

    def wrong_arguments
      info("error", "invalid arguments", "red")
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

    def error_only_osx
      say do
        @thor.say_status :error, "this feature only works with iTunes by default", :red
        @thor.say_status :info, "if you've got a Last.fm account, use `ayadn -NP --lastfm` (short: `-l`)", :cyan
      end
    end

    def empty_fields
      info("canceled", "couldn't get enough information (empty field)", "red")
    end

    def not_authorized
      say do
        @thor.say_status :error, "no user authorized", :red
        @thor.say_status :auth, "please run `ayadn -auth` to authorize an account", :yellow
      end
    end

    def wtf
      info("error", "an unkown error happened", "red")
    end

    def redirecting
      say do
        @thor.say_status :info, "post is a repost", :cyan
        @thor.say_status :action, "redirecting", :yellow
      end
    end

    def nobody_reposted
      info("error", "nobody reposted this post", "red")
    end

    def nobody_starred
      info("error", "nobody starred this post", "red")
    end

    def not_your_repost
      info("error", "this post isn't one of your reposts", "red")
    end

    def not_your_starred
      info("error", "this isn't one of your starred posts", "red")
    end

    def auto
      say do
        @thor.say_status :info, "entering the auto posting mode", :cyan
        @thor.say_status :info, "each line you type (each time you hit ENTER) is automatically posted to ADN", :cyan
        @thor.say_status :info, "at any moment, starting now, hit CTRL+C to exit", :cyan
        @thor.say_status :info, "AUTO POSTING MODE ACTIVATED", :yellow
      end
    end

    def threshold
      say do
        @thor.say_status :error, "please enter a value between 0.1 and 3.5", :red
        @thor.say_status :info, "example: 2.1", :green
      end
    end

    def must_be_in_index
      info("error", "number must be in the range of the indexed posts", "red")
    end

    def user_404(username)
      info("error", "user #{username} doesn't exist (it could be a deleted account)", "red")
    end

    def post_404(post_id)
      info("error", "impossible to find #{post_id} (it may have been deleted)", "red")
    end

    def no_alias
      info("error", "this alias doesn't exist", "red")
    end

    def no_itunes
      info("canceled", "unable to get info from iTunes", "red")
    end

    def pin_username
      info("please", "enter your Pinboard username (CTRL+C to cancel)", "green")
    end

    def pin_password
      info("please", "enter your Pinboard password (invisible, CTRL+C to cancel)", "green")
    end

    def too_long(size, max_size)
      say do
        @thor.say_status :error, "text too long", :red
        @thor.say_status :info, "#{max_size} max: #{size - max_size} characters to remove", :green
      end
    end

    def no_text
      info("error", "no text", "red")
    end

    def bad_path
      info("error", "couldn't upload this file (path seems wrong)", "red")
    end

    def no_curl
      say do
        @thor.say_status :error, "Ayadn needs 'curl' to upload files", :red
        @thor.say_status :next, "please install 'curl' (or check that it's properly declared in your $PATH)", :yellow
      end
    end

    def itunes_store
      info("connexion", "fetching informations from the iTunes Store", "green")
    end

    def fetching_from(source)
      info("connexion", "fetching informations from #{source}", "green")
    end

    def no_movie
      info("error", "sorry, can't find this movie", "red")
    end

    def no_show
      info("error", "sorry, can't find this show", "red")
    end

    def no_show_infos
      info("error", "sorry, can't find informations about this show", "red")
    end

    def no_force(target)
      say do
        @thor.say_status :error, "'#{target}' can't be displayed (could be muted, blocked, in the Blacklist, etc)", :red
        @thor.say_status :info, "please use option '--force' ('-f') to try and display this content anyway", :cyan
      end
    end

    def profile_options
      info("error", "please specify what to update or delete: --bio, --name, --blog, --twitter or --web", "red")
    end

    def one_username
      info("error", "please specify only one username", "red")
    end

    def no_username
      say do
        @thor.say_status :error, "Ayadn couldn't get your username", :red
        @thor.say_status :next, "please try again", :yellow
      end
    end

    def has_to_migrate
      say do
        @thor.say_status :upgrade, "Ayadn 1.x user data detected", :red
        @thor.say_status :migrate,  "please run `ayadn migrate` to upgrade your account", :yellow
      end
    end

    def updating_profile
      info("updating", "profile", "yellow")
    end

    def your_post
      info("", "your post:", "cyan")
    end

    def post_info
      info("info", "post", "cyan")
    end

    def repost_info
      info("info", "repost of", "cyan")
    end

    def unread_from_channel(channel_id)
      info("info", "unread message(s) from channel #{channel_id}", "cyan")
    end

    def version
      say do
        @thor.say_status :AYADN, "", :red
        @thor.say_status :version, "#{VERSION}", :green
        @thor.say_status :changelog, "https://github.com/ericdke/na/blob/master/CHANGELOG.md", :yellow
        @thor.say_status :docs, "https://github.com/ericdke/na/tree/master/doc", :yellow
      end
    end

    def ask_clear_databases
      info("question", "are you sure you want to erase all the content of your aliases database? [y/N]", "red")
    end

    def ask_clear_blacklist
      info("question", "are you sure you want to erase all the content of your blacklist database? [y/N]", "red")
    end

    def ask_clear_bookmarks
      info("question", "are you sure you want to erase all the content of your bookmarks database? [y/N]", "red")
    end

    def ok?
      info("confirm", "is it ok? [y/N]", "yellow")
    end

    def itunes_store_track(store)
      puts "\n"
      @thor.say_status "next", "Ayadn will use these elements to insert album artwork and a link", :cyan
    end

    ##---

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

    def say() # expects a block
      puts "\n"
      yield
      puts "\n"
    end

  end
end
