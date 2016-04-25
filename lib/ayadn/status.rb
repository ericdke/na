# encoding: utf-8
module Ayadn
  class Status

    attr_reader :thor

    def initialize
      @thor = Thor::Shell::Color.new
    end

    def done
      info("done", "", "green")
    end

    def canceled
      say do
        puts "\n"
        say_red :canceled, ""
      end
    end

    def downloaded(name)
      info("downloaded", "#{Settings.config.paths.downloads}/#{name}", "green")
    end

    def links_saved(name)
      info("done", "links exported to file #{Settings.config.paths.lists}/#{name}", "green")
    end

    def downloading
      info("connected", "downloading from ADN", "yellow")
    end

    def posting
      info("connected", "posting to ADN", "yellow")
    end

    def deleting_post(post_id)
      say_yellow :deleting, "post #{post_id}"
    end

    def deleting_message(message_id)
      say_yellow :deleting, "message #{message_id}"
    end

    def unfollowing(username)
      say_yellow :unfollowing, username
    end

    def following(username)
      say_yellow :following, username
    end

    def unmuting(username)
      say_yellow :unmuting, username
    end

    def muting(username)
      say_yellow :muting, username
    end

    def unblocking(username)
      say_yellow :unblocking, username
    end

    def blocking(username)
      say_yellow :blocking, username
    end

    def unreposting(post_id)
      say_yellow :unreposting, "post #{post_id}"
    end

    def reposting(post_id)
      say_yellow :reposting, "post #{post_id}"
    end

    def unstarring(post_id)
      say_yellow :unstarring, "post #{post_id}"
    end

    def starring(post_id)
      say_yellow :starring, "post #{post_id}"
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
        say_error "please submit valid items"
        say_info "see `ayadn -sg` for a list of valid parameters and values"
      end
    end

    def empty_list
      info("info", "the list is empty", "yellow")
    end

    def writing
      puts "\n"
      say_cyan :author, "#{Settings.config.identity.handle}"
      puts "\n"
    end

    def yourmessage username = nil
        if username.nil?
          say_center "Your message:"
        else
          say_center "Your message to #{username}:"
        end
        puts "\n\n"
    end

    def message_from(username)
      puts "\n"
      say_yellow :from, "#{Settings.config.identity.handle}"
      say_yellow :to, "#{username[0]}"
    end

    def replying_to(post_id)
      puts "\n"
      say_yellow :replying, "to post #{post_id}"
    end

    def readline
      say do
        say_cyan :next, "type your text"
        say_cyan :ok, "[CTRL+D] to validate"
        say_cyan :cancel, "[CTRL+C] to cancel"
      end
    end

    def reply
      say_cyan :max, "#{Settings.config.post_max_length} characters"
    end

    def post
      say_cyan :max, "#{Settings.config.post_max_length} characters"
    end

    def message
      say_cyan :max, "#{Settings.config.message_max_length} characters"
    end

    def valid_colors(colors_list)
      say_cyan :info, "valid colors:"
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
        say_error "this feature only works with iTunes by default"
        say_info "if you've got a Last.fm account, use `ayadn -NP --lastfm` (short: `-l`)"
      end
    end

    def empty_fields
      info("canceled", "couldn't get enough information (empty field)", "red")
    end

    def not_authorized
      say do
        say_error "no user authorized"
        say_info "please run `ayadn -auth` to authorize an account"
      end
    end

    def wtf
      info("error", "an unkown error happened", "red")
    end

    def redirecting
      say do
        say_info "post is a repost"
        say_yellow :action, "redirecting"
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
        say_info "entering the auto posting mode"
        say_info "each line you type (each time you hit ENTER) is automatically posted to ADN"
        say_info "at any moment, starting now, hit CTRL+C to exit"
        say_yellow :info, "AUTO POSTING MODE ACTIVATED"
      end
    end

    def threshold
      say do
        say_error "please enter a value between 0.1 and 3.5"
        say_green :info, "example: 2.1"
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
      diff = size - max_size
      diff > 1 ? pl = "s" : pl = ""
      say do
        say_error "text too long"
        say_green :info, "#{max_size} max: #{diff} character#{pl} to remove"
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
        say_error "Ayadn needs 'curl' to upload files"
        say_yellow :next, "please install 'curl' (or check that it's properly declared in your $PATH)"
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
        say_error "'#{target}' can't be displayed (could be muted, blocked, in the Blacklist, etc)"
        say_info "please use option '--force' ('-f') to try and display this content anyway"
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
        say_error "Ayadn couldn't get your username"
        say_yellow :next, "please try again"
      end
    end

    def deprecated_ayadn
      say do
        say_red :deprecated, "Ayadn 1.x user data detected"
        say_yellow :warning,  "please delete your old ayadn folder then try again"
      end
    end

    def updating_profile
      info("updating", "profile", "yellow")
    end

    def to_be_posted
      info("", "Your post:")
    end

    def yourpost
      # info("", "Your post:")
      say_center "Your post:"
    end

    def post_info
      info("info", "post", "cyan")
    end

    def repost_info
      info("info", "repost of", "cyan")
    end

    def unread_from_channel(channel_id)
      say_info "unread message(s) from channel #{channel_id}"
      puts "\n\n"
    end

    def ayadn
      <<-AYADN

\t\t     _____ __ __ _____ ____  _____
\t\t    |  _  |  |  |  _  |    \\|   | |
\t\t    |     |_   _|     |  |  | | | |
\t\t    |__|__| |_| |__|__|____/|_|___|


      AYADN
    end
    def version
      puts ayadn()
      say_green :version, "#{VERSION}"
      say_yellow :changelog, "https://github.com/ericdke/na/blob/master/CHANGELOG.md"
      say_yellow :docs, "https://github.com/ericdke/na/tree/master/doc"
      puts "\n\n"
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
      say_cyan :next, "Ayadn will use these elements to insert album artwork and a link"
    end

    def server_error(bool)
      if bool
        say do
          say_error "Ayadn couldn't get the JSON reponse"
          say_yellow :next, "trying again in 10 seconds"
        end
      else
        say do
          say_error "Ayadn couldn't get the JSON reponse"
          say_yellow :status, "Current command canceled after one retry"
        end
      end
    end

    ##---

    def info(status, message, color = nil)
      if color.nil?
        lamb = lambda { say_nocolor(status.to_sym, message.to_s) }
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

    def say_center(message)
      @thor.say_status nil, message
    end

    def say_nocolor(tag, message)
      @thor.say_status tag, message
    end

    def say_error(message)
      @thor.say_status :error, message, :red
    end

    def say_info(message)
      @thor.say_status :info, message, :cyan
    end

    def say_green(tag, message)
      @thor.say_status tag, message, :green
    end

    def say_blue(tag, message)
      @thor.say_status tag, message, :blue
    end

    def say_cyan(tag, message)
      @thor.say_status tag, message, :cyan
    end

    def say_red(tag, message)
      @thor.say_status tag, message, :red
    end

    def say_yellow(tag, message)
      @thor.say_status tag, message, :yellow
    end

    def say_end
      say { say_green :done, "end of diagnostics" }
    end

    def say_header(message)
      say { say_info message }
    end

    def say_text(text)
      say { puts text }
    end

    def say_trace(message)
      @thor.say_status :message, message, :yell
    end

  end
end
