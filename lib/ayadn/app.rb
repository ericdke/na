module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{action api descriptions endpoints cnx view workers myconfig status extend databases fileops logs pinboard}.each { |r| require_relative "#{r}" }

		desc "unified", "Show the Unified Stream, aka your App.net timeline (ayadn -u)"
		map "-u" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def unified
			Action.new.unified(options)
		end

		desc "checkins", "Show the Checkins Stream (ayadn -ck)"
		map "-ck" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def checkins
			Action.new.checkins(options)
		end

		desc "global", "Show the Global Stream (ayadn -gl)"
		map "-gl" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def global
			Action.new.global(options)
		end

		desc "trending", "Show the Trending Stream (ayadn -tr)"
		map "-tr" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def trending
			Action.new.trending(options)
		end

		desc "photos", "Show the Photos Stream (ayadn -ph)"
		map "-ph" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def photos
			Action.new.photos(options)
		end

		desc "conversations", "Show the Conversations Stream (ayadn -cq)"
		map "-cq" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def conversations
			Action.new.conversations(options)
		end

		desc "mentions @USERNAME", "Show posts containing a mention of a @username (ayadn -m @username)"
		map "-m" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def mentions(*username)
			Action.new.mentions(username, options)
		end

		desc "posts @USERNAME", "Show posts of @username (ayadn -po @username)"
		map "-po" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
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
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def whatstarred(*username)
			Action.new.whatstarred(username, options)
		end

		desc "whoreposted POST", "List users who reposted a post (ayadn -wor POST)"
		map "-wor" => :whoreposted
		long_desc Descriptions.whoreposted
		def whoreposted(post_id)
			Action.new.whoreposted(post_id)
		end

		desc "whostarred POST", "List users who starred a post (ayadn -wos POST)"
		map "-wos" => :whostarred
		long_desc Descriptions.whostarred
		def whostarred(post_id)
			Action.new.whostarred(post_id)
		end

		desc "convo POST", "Show the conversation thread around a post (ayadn -co POST)"
		map "-co" => :convo
		map "thread" => :convo
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		long_desc Descriptions.convo
		def convo(post_id)
			Action.new.convo(post_id, options)
		end

		desc "followings @USERNAME", "List users @username is following (ayadn -fg @username)"
		map "-fg" => :followings
		long_desc Descriptions.followings
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def followings(*username)
			Action.new.followings(username, options)
		end

		desc "followers @USERNAME", "List users following @username (ayadn -fr @username)"
		map "-fr" => :followers
		long_desc Descriptions.followers
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def followers(*username)
			Action.new.followers(username, options)
		end

		desc "muted", "List the users you muted (ayadn -mtd)"
		map "-mtd" => :muted
		long_desc Descriptions.muted
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def muted
			Action.new.muted(options)
		end

		desc "blocked", "List the users you blocked (ayadn -bkd)"
		map "-bkd" => :blocked
		long_desc Descriptions.blocked
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def blocked
			Action.new.blocked(options)
		end

		desc "hashtag HASHTAG", "Show recent posts containing #HASHTAG (ayadn -t hashtag)"
		map "-t" => :hashtag
		long_desc Descriptions.hashtag
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def hashtag(hashtag)
			Action.new.hashtag(hashtag, options)
		end

		desc "search WORD(S)", "Show recents posts containing WORD(S) (ayadn -s word1 word2 ...)"
		map "-s" => :search
		long_desc Descriptions.search
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def search(*words)
			Action.new.search(words.join(","), options)
		end

		desc "settings", "List current Ayadn settings (ayadn -sg)"
		map "-sg" => :settings
		long_desc Descriptions.settings
		def settings
			Action.new.view_settings
		end

		desc "userinfo @USERNAME", "Show detailed informations about @username (ayadn -ui @username)"
		map "-ui" => :userinfo
		long_desc Descriptions.userinfo
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def userinfo(*username)
			Action.new.userinfo(username, options)
		end

		desc "postinfo POST", "Show detailed informations about a post (ayadn -pi POST)"
		map "-pi" => :postinfo
		long_desc Descriptions.postinfo
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def postinfo(post_id)
			Action.new.postinfo(post_id, options)
		end

		desc "files", "List your files (ayadn -fl)"
		map "-fl" => :files
		long_desc Descriptions.files
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def files
			Action.new.files(options)
		end

		desc "delete POST", "Delete a post (ayadn -del POST)"
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

		desc "unrepost POST", "Unrepost a post (ayadn -unr POST)"
		map "-unr" => :unrepost
		long_desc Descriptions.unrepost
		def unrepost(post_id)
			Action.new.unrepost(post_id)
		end

		desc "unstar POST", "Unstar a post (ayadn -uns POST)"
		map "-uns" => :unstar
		long_desc Descriptions.unstar
		def unstar(post_id)
			Action.new.unstar(post_id)
		end

		desc "star POST", "Star a post (ayadn -st POST)"
		map "-st" => :star
		long_desc Descriptions.star
		def star(post_id)
			Action.new.star(post_id)
		end

		desc "repost POST", "Repost a post (ayadn -rp POST)"
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

		desc "mute @USERNAME", "Mute @username (ayadn -mu @username)"
		map "-mu" => :mute
		long_desc Descriptions.mute
		def mute(*username)
			Action.new.mute(username)
		end

		desc "block @USERNAME", "Block @username (ayadn -bl @username)"
		map "-bl" => :block
		long_desc Descriptions.block
		def block(*username)
			Action.new.block(username)
		end

		desc "channels", "List your active channels (ayadn -ch)"
		map "-ch" => :channels
		long_desc Descriptions.channels
		def channels
			Action.new.channels
		end

		desc "messages CHANNEL", "Show messages in channel CHANNEL (ayadn -ms CHANNEL)"
		map "-ms" => :messages
		long_desc Descriptions.messages
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of messages to retrieve"
		option :raw, aliases: "-x", type: :boolean, desc: "Outputs the App.net raw JSON response"
		def messages(channel_id)
			Action.new.messages(channel_id, options)
		end













	end
end
