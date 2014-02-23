module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{action api descriptions endpoints cnx view workers myconfig status extend databases fileops logs}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Show the Unified Stream, aka your App.net timeline (ayadn -u)"
		map "-u" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			Action.new.unified(options)
		end

		desc "checkins", "Show the Checkins Stream (ayadn -ch)"
		map "-ch" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			Action.new.checkins(options)
		end

		desc "global", "Show the Global Stream (ayadn -gl)"
		map "-gl" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			Action.new.global(options)
		end

		desc "trending", "Show the Trending Stream (ayadn -tr)"
		map "-tr" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			Action.new.trending(options)
		end

		desc "photos", "Show the Photos Stream (ayadn -ph)"
		map "-ph" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			Action.new.photos(options)
		end

		desc "conversations", "Show the Conversations Stream (ayadn -cq)"
		map "-cq" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			Action.new.conversations(options)
		end

		desc "mentions @USERNAME", "Show posts containing a mention of a @username (ayadn -m @username)"
		map "-m" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def mentions(*username)
			Action.new.mentions(username, options)
		end

		desc "posts @USERNAME", "Show posts of @username (ayadn -po @username)"
		map "-po" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def posts(*username)
			Action.new.posts(username, options)
		end

		desc "interactions", "Show your recent ADN activity (ayadn -int)"
		map "-int" => :interactions
		long_desc Descriptions.interactions
		def interactions
			Action.new.interactions
		end

		desc "whatstarred @USERNAME", "Show posts starred by @username (ayadn -was @username)"
		map "-was" => :whatstarred
		long_desc Descriptions.whatstarred
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def whatstarred(*username)
			Action.new.whatstarred(username, options)
		end

		desc "whoreposted POST-ID", "List users who reposted a post (ayadn -wor POST-ID)"
		map "-wor" => :whoreposted
		long_desc Descriptions.whoreposted
		def whoreposted(post_id)
			Action.new.whoreposted(post_id)
		end

		desc "whostarred POST-ID", "List users who starred a post (ayadn -wos POST-ID)"
		map "-wos" => :whostarred
		long_desc Descriptions.whostarred
		def whostarred(post_id)
			Action.new.whostarred(post_id)
		end

		desc "convo POST-ID", "Show the conversation thread around a post (ayadn -co POST-ID)"
		map "-co" => :convo
		map "thread" => :convo
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		long_desc Descriptions.convo
		def convo(post_id)
			Action.new.convo(post_id, options)
		end

		desc "followings @USERNAME", "List users @username is following (ayadn -fg @username)"
		map "-fg" => :followings
		long_desc Descriptions.followings
		def followings(*username)
			Action.new.followings(username)
		end

		desc "followers @USERNAME", "List users following @username (ayadn -fr @username)"
		map "-fr" => :followers
		long_desc Descriptions.followers
		def followers(*username)
			Action.new.followers(username)
		end

		desc "muted", "List the users you muted (ayadn -mtd)"
		map "-mtd" => :muted
		long_desc Descriptions.muted
		def muted
			Action.new.muted
		end

		desc "blocked", "List the users you blocked (ayadn -bkd)"
		map "-bkd" => :blocked
		long_desc Descriptions.blocked
		def blocked
			Action.new.blocked
		end

		desc "hashtag HASHTAG", "Show recent posts containing #HASHTAG (ayadn -t hashtag)"
		map "-t" => :hashtag
		long_desc Descriptions.hashtag
		def hashtag(hashtag)
			Action.new.hashtag(hashtag)
		end

		desc "search WORD(S)", "Show recents posts containing WORD(S) (ayadn -s word1 word2 ...)"
		map "-s" => :search
		long_desc Descriptions.search
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def search(*words)
			Action.new.search(words.join(","), options)
		end

		desc "settings", "List current Ayadn settings (ayadn -sg)"
		map "-sg" => :settings
		long_desc Descriptions.settings
		def settings
			Action.new.view_settings
		end

		desc "user_info @USERNAME", "Show detailed informations about @username (ayadn -ui @username)"
		map "-ui" => :user_info
		long_desc Descriptions.user_info
		def user_info(*username)
			Action.new.user_info(username)
		end

		desc "post_info POST-ID", "Show detailed informations about a post (ayadn -pi POST-ID)"
		map "-pi" => :post_info
		long_desc Descriptions.post_info
		def post_info(post_id)
			Action.new.post_info(post_id)
		end

		desc "files", "List your files (ayadn -fl)"
		map "-fl" => :files
		long_desc Descriptions.files
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		def files
			Action.new.files(options)
		end

		desc "delete POST-ID", "Delete a post (ayadn -del POST-ID)"
		map "-del" => :delete
		long_desc Descriptions.delete
		def delete(post_id)
			Action.new.delete(post_id)
		end

		desc "unfollow @USERNAME", "Unfollow @username (ayadn -unf @username)"
		map "-unf" => :unfollow
		long_desc Descriptions.unfollow
		def unfollow(*username)
			Action.new.unfollow(username)
		end

		desc "unmute @USERNAME", "Unmute @username (ayadn -unm @username)"
		map "-unm" => :unmute
		long_desc Descriptions.unmute
		def unmute(*username)
			Action.new.unmute(username)
		end

		desc "unblock @USERNAME", "Unblock @username (ayadn -unb @username)"
		map "-unb" => :unblock
		long_desc Descriptions.unblock
		def unblock(*username)
			Action.new.unblock(username)
		end

		desc "unrepost POST-ID", "Unrepost a post (ayadn -unr POST-ID)"
		map "-unr" => :unrepost
		long_desc Descriptions.unrepost
		def unrepost(post_id)
			Action.new.unrepost(post_id)
		end

		desc "unstar POST-ID", "Unstar a post (ayadn -uns POST-ID)"
		map "-uns" => :unstar
		long_desc Descriptions.unstar
		def unstar(post_id)
			Action.new.unstar(post_id)
		end

		desc "star POST-ID", "Star a post (ayadn -st POST-ID)"
		map "-st" => :star
		long_desc Descriptions.star
		def star(post_id)
			Action.new.star(post_id)
		end

		desc "repost POST-ID", "Repost a post (ayadn -rp POST-ID)"
		map "-rp" => :repost
		long_desc Descriptions.repost
		def repost(post_id)
			Action.new.repost(post_id)
		end

		desc "follow @USERNAME", "Follow @username (ayadn -fo @username)"
		map "-fo" => :follow
		long_desc Descriptions.follow
		def follow(*username)
			Action.new.follow(username)
		end








	end
end