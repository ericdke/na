# encoding: utf-8
module Ayadn
  class Status
    def self.done
      "\nDone.\n".color(:green)
    end
    def self.downloaded(name)
      "\nFile downloaded in #{Settings.config[:paths][:downloads]}/#{name}\n".color(:green)
    end
    def self.downloading
      "Downloading from ADN...\n".inverse
    end
    def self.posting
      "Posting to ADN...\n".inverse
    end
    def self.deleting_post(post_id)
      "\nDeleting post #{post_id}\n".inverse
    end
    def self.unfollowing(username)
      "\nUnfollowing #{username}\n".inverse
    end
    def self.following(username)
      "\nFollowing #{username}\n".inverse
    end
    def self.unmuting(username)
      "\nUnmuting #{username}\n".inverse
    end
    def self.muting(username)
      "\nMuting #{username}\n".inverse
    end
    def self.unblocking(username)
      "\nUnblocking #{username}\n".inverse
    end
    def self.blocking(username)
      "\nBlocking #{username}\n".inverse
    end
    def self.unreposting(post_id)
      "\nUnreposting #{post_id}\n".inverse
    end
    def self.reposting(post_id)
      "\nReposting #{post_id}\n".inverse
    end
    def self.unstarring(post_id)
      "\nUnstarring #{post_id}\n".inverse
    end
    def self.starring(post_id)
      "\nStarring #{post_id}\n".inverse
    end
    def self.not_deleted(post_id)
      "Could not delete post #{post_id} (post isn't yours, or is already deleted)\n".color(:red)
    end
    def self.not_starred(post_id)
      "Could not star post #{post_id} (post doesn't exist, or is already starred)\n".color(:red)
    end
    def self.not_unreposted(post_id)
      "Could not unrepost post #{post_id} (post isn't yours, isn't a repost, or has been deleted)\n".color(:red)
    end
    def self.not_reposted(post_id)
      "Could not repost post #{post_id} (post has been deleted?)\n".color(:red)
    end
    def self.not_unstarred(post_id)
      "Could not unstar post #{post_id} (post isn't yours, isn't starred, or has been deleted)\n".color(:red)
    end
    def self.not_unfollowed(post_id)
      "Could not unfollow user #{username} (doesn't exist, or wasn't already followed)\n".color(:red)
    end
    def self.not_followed(post_id)
      "Could not follow user #{username} (doesn't exist, or you already follow)\n".color(:red)
    end
    def self.not_unmuted(post_id)
      "Could not unmute user #{username} (doesn't exist, or wasn't already muted)\n".color(:red)
    end
    def self.not_muted(post_id)
      "Could not mute user #{username} (doesn't exist, or is already muted)\n".color(:red)
    end
    def self.not_unblocked(post_id)
      "Could not unblock user #{username} (doesn't exist, or wasn't already blocked)\n".color(:red)
    end
    def self.not_blocked(post_id)
      "Could not block user #{username} (doesn't exist, or is already blocked)\n".color(:red)
    end
    def self.deleted(post_id)
      "\nPost #{post_id} has been deleted.\n".color(:green)
    end
    def self.starred(post_id)
      "\nPost #{post_id} has been starred.\n".color(:green)
    end
    def self.unreposted(post_id)
      "\nPost #{post_id} has been unreposted.\n".color(:green)
    end
    def self.reposted(post_id)
      "\nPost #{post_id} has been reposted.\n".color(:green)
    end
    def self.unstarred(post_id)
      "\nPost #{post_id} has been unstarred.\n".color(:green)
    end
    def self.unfollowed(username)
      "\nUser #{username} has been unfollowed.\n".color(:green)
    end
    def self.followed(username)
      "\nUser #{username} has been followed.\n".color(:green)
    end
    def self.unmuted(username)
      "\nUser #{username} has been unmuted.\n".color(:green)
    end
    def self.muted(username)
      "\nUser #{username} has been muted.\n".color(:green)
    end
    def self.unblocked(username)
      "\nUser #{username} has been unblocked.\n".color(:green)
    end
    def self.blocked(username)
      "\nUser #{username} has been blocked.\n".color(:green)
    end
    def self.error_missing_username
      "\nYou have to specify a username.\n".color(:red)
    end
    def self.error_missing_post_id
      "\nYou have to specify a post id.\n".color(:red)
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
    def self.empty_list
      "\n\nThe list is empty.\n\n".color(:red)
    end
    def self.not_found
      "\n\n404 NOT FOUND - Object does not exist or has been deleted\n\n"
    end
    def self.stopped
      "\n\nStopped.".color(:red)
    end
    def self.writing
      "\nPosting as ".color(:cyan) + "#{Settings.config[:identity][:handle]}".color(:green) + ".\n".color(:cyan)
    end
    def self.yourpost
      "\nYour post:\n\n".color(:cyan)
    end
    def self.yourmessage
      "\nYour message:\n\n".color(:cyan)
    end
    def self.message_from(username)
      "\nMessage from ".color(:cyan) + "#{Settings.config[:identity][:handle]} ".color(:green) + "to ".color(:cyan) + "#{username[0]}".color(:yellow) + ".\n".color(:cyan)
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
      "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum. If the original post has mentions, you text will be inserted after the first one. Markdown links are supported.\n"
    end
    def self.post
      "\n#{Settings.config[:post_max_length]} ".color(:yellow) + "characters maximum. Markdown links are supported.\n"
    end
    def self.message
      "\n#{Settings.config[:message_max_length]} ".color(:yellow) + "characters maximum. Markdown links are supported.\n"
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
    def self.no_new_posts
      "\nNo new posts since your last visit.\n\n".color(:cyan)
    end
    def self.type_and_target_missing
      "\nYou have to submit a TYPE (mention, hashtag, client name) and a TARGET (a @username, a hashtag, a client name)\n\n".color(:red)
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
      "\nThis feature only works with Mac OS X and iTunes, sorry.\n\n".color(:red)
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
      "\nPost is a repost. Redirecting...\n\n".color(:cyan)
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
  end
end
