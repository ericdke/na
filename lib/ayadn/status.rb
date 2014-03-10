module Ayadn
  class Status
    def self.done
      "\nDone.\n".color(:green)
    end
    def self.downloading
      "Downloading from ADN...\n".inverse
    end
    def self.posting
      "Posting to ADN...\n".inverse
    end
    def self.deleting_post(post_id)
      "Deleting post #{post_id}\n".inverse
    end
    def self.unfollowing(username)
      "Unfollowing #{username}\n".inverse
    end
    def self.following(username)
      "Following #{username}\n".inverse
    end
    def self.unmuting(username)
      "Unmuting #{username}\n".inverse
    end
    def self.muting(username)
      "Muting #{username}\n".inverse
    end
    def self.unblocking(username)
      "Unblocking #{username}\n".inverse
    end
    def self.blocking(username)
      "Blocking #{username}\n".inverse
    end
    def self.unreposting(post_id)
      "Unreposting #{post_id}\n".inverse
    end
    def self.reposting(post_id)
      "Reposting #{post_id}\n".inverse
    end
    def self.unstarring(post_id)
      "Unstarring #{post_id}\n".inverse
    end
    def self.starring(post_id)
      "Starring #{post_id}\n".inverse
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
      "Post #{post_id} has been deleted.\n".color(:green)
    end
    def self.starred(post_id)
      "Post #{post_id} has been starred.\n".color(:green)
    end
    def self.unreposted(post_id)
      "Post #{post_id} has been unreposted.\n".color(:green)
    end
    def self.reposted(post_id)
      "Post #{post_id} has been reposted.\n".color(:green)
    end
    def self.unstarred(post_id)
      "Post #{post_id} has been unstarred.\n".color(:green)
    end
    def self.unfollowed(username)
      "User #{username} has been unfollowed.\n".color(:green)
    end
    def self.followed(username)
      "User #{username} has been followed.\n".color(:green)
    end
    def self.unmuted(username)
      "User #{username} has been unmuted.\n".color(:green)
    end
    def self.muted(username)
      "User #{username} has been muted.\n".color(:green)
    end
    def self.unblocked(username)
      "User #{username} has been unblocked.\n".color(:green)
    end
    def self.blocked(username)
      "User #{username} has been blocked.\n".color(:green)
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
    def self.yourpost
      "\nYour post:\n\n".color(:cyan)
    end
    def self.replying_to(post_id)
      "\nReplying to post #{post_id}...\n".color(:green)
    end
    def self.readline
      "\nType your text. ".color(:cyan) + "[CTRL+D] ".color(:green) + "to validate, ".color(:cyan) + "[CTRL+C] ".color(:red) + "to cancel.\n\n".color(:cyan)
    end
    def self.classic
      "\nType your text. ".color(:cyan) + "[ENTER] ".color(:green) + "to validate, ".color(:cyan) + "[CTRL+C] ".color(:red) + "to cancel.\n\n".color(:cyan)
    end
    def self.reply
      "\n#{MyConfig.config[:post_max_length]} ".color(:yellow) + "characters maximum. If the original post has mentions, you text will be inserted after the first one. Markdown links are supported.\n\n"
    end
    def self.post
      "\n#{MyConfig.config[:post_max_length]} ".color(:yellow) + "characters maximum. Markdown links are supported.\n\n"
    end
    def self.message
      "\n#{MyConfig.config[:message_max_length]} ".color(:yellow) + "characters maximum. Markdown links are supported.\n\n"
    end
    def self.method_missing(meth, args)
      "\nThe command '#{meth} #{args}' doesn't exist.\n".color(:red)
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
  end
end
