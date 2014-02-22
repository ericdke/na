module Ayadn
	class Status
		def self.done
			"Done.\n".color(:green)
		end
		def self.downloading
			"Downloading from ADN...\n".inverse
		end
		def self.deleting_post(post_id)
			"Deleting post #{post_id}\n".inverse
		end
		def self.unfollowing(username)
			"Unfollowing #{username}\n".inverse
		end
		def self.unmuting(username)
			"Unmuting #{username}\n".inverse
		end
		def self.not_deleted(post_id)
			"Could not delete post #{post_id} (post isn't yours, or is already deleted)\n".color(:red)
		end
		def self.not_unfollowed(post_id)
			"Could not unfollow user #{username} (doesn't exist, or wasn't already followed)\n".color(:red)
		end
		def self.not_unmuted(post_id)
			"Could not unmute user #{username} (doesn't exist, or wasn't already muted)\n".color(:red)
		end
		def self.deleted(post_id)
			"Post #{post_id} has been deleted.\n".color(:green)
		end
		def self.unfollowed(username)
			"User #{username} has been unfollowed.\n".color(:green)
		end
		def self.unmuted(username)
			"User #{username} has been unmuted.\n".color(:green)
		end
		def self.error_missing_username
			"\nYou have to specify a username.\n".color(:red)
		end
		def self.error_missing_post_id
			"\nYou have to specify a post id.\n".color(:red)
		end
		def self.error_missing_hashtag
			"\nYou have to specify one or more hashtag(s).\n".color(:red)
		end
		def self.empty_list
			"\n\nThe list is empty.\n\n".color(:red)
		end
	end
end