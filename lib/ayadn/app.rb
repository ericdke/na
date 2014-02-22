module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{action api descriptions endpoints cnx view workers myconfig status extend databases fileops logs}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Shows the Unified Stream, aka your App.net timeline (ayadn -U)"
		map "-U" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			Action.new.unified(options)
		end

		desc "checkins", "Shows the Checkins Stream (ayadn -K)"
		map "-K" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			Action.new.checkins(options)
		end

		desc "global", "Shows the Global Stream (ayadn -G)"
		map "-G" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			Action.new.global(options)
		end

		desc "trending", "Shows the Trending Stream (ayadn -TR)"
		map "-TR" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			Action.new.trending(options)
		end

		desc "photos", "Shows the Photos Stream (ayadn -PH)"
		map "-PH" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			Action.new.photos(options)
		end

		desc "conversations", "Shows the Conversations Stream (ayadn -CQ)"
		map "-CQ" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			Action.new.conversations(options)
		end

		desc "mentions @USERNAME", "Shows posts containing a mention of a @username (ayadn -M @username)"
		map "-M" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def mentions(*username)
			Action.new.mentions(username, options)
		end

		desc "posts @USERNAME", "Shows posts of @username (ayadn -PO @username)"
		map "-PO" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def posts(*username)
			Action.new.posts(username, options)
		end

		desc "interactions", "Shows your recent ADN activity (ayadn -INT)"
		map "-INT" => :interactions
		long_desc Descriptions.interactions
		def interactions
			Action.new.interactions
		end

		desc "whatstarred @USERNAME", "Shows posts starred by @username (ayadn -WAS @username)"
		map "-WAS" => :whatstarred
		long_desc Descriptions.whatstarred
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def whatstarred(*username)
			Action.new.whatstarred(username, options)
		end

		desc "whoreposted POST-ID", "Lists users who reposted post n°POST-ID (ayadn -WOR POST-ID)"
		map "-WOR" => :whoreposted
		long_desc Descriptions.whoreposted
		def whoreposted(post_id)
			Action.new.whoreposted(post_id)
		end

		desc "whostarred POST-ID", "Lists users who starred post n°POST-ID (ayadn -WOS POST-ID)"
		map "-WOS" => :whostarred
		long_desc Descriptions.whostarred
		def whostarred(post_id)
			Action.new.whostarred(post_id)
		end

		desc "convo POST-ID", "Shows the conversation thread around post n°POST_ID (ayadn -CO POST-ID)"
		map "-CO" => :convo
		map "thread" => :convo
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		long_desc Descriptions.convo
		def convo(post_id)
			Action.new.convo(post_id, options)
		end

		desc "followings @USERNAME", "Lists users @username is following (ayadn -FWG @username)"
		map "-FWG" => :followings
		long_desc Descriptions.followings
		def followings(*username)
			Action.new.followings(username)
		end

		desc "followers @USERNAME", "Lists users following @username (ayadn -FWR @username)"
		map "-FWR" => :followers
		long_desc Descriptions.followers
		def followers(*username)
			Action.new.followers(username)
		end

		desc "muted", "Lists the users you muted (ayadn -MTD)"
		map "-MTD" => :muted
		long_desc Descriptions.muted
		def muted
			Action.new.muted
		end

		desc "blocked", "Lists the users you blocked (ayadn -BKD)"
		map "-BKD" => :blocked
		long_desc Descriptions.blocked
		def blocked
			Action.new.blocked
		end

		desc "hashtag HASHTAG", "Shows recent posts containing #HASHTAG (ayadn -TAG hashtag)"
		map "-TAG" => :hashtag
		long_desc Descriptions.hashtag
		def hashtag(hashtag)
			Action.new.hashtag(hashtag)
		end

		desc "search WORD(S)", "Shows recents posts containing WORD(S) (ayadn -S word1 word2 ...)"
		map "-S" => :search
		long_desc Descriptions.search
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def search(*words)
			Action.new.search(words.join(","), options)
		end

		desc "settings", "Lists current Ayadn settings (ayadn -OPT)"
		map "-OPT" => :settings
		long_desc Descriptions.settings
		def settings
			Action.new.view_settings
		end

		desc "user_info @USERNAME", "Shows detailed informations about @username (ayadn -UI @username)"
		map "-UI" => :user_info
		long_desc Descriptions.user_info
		def user_info(*username)
			Action.new.user_info(username)
		end

		desc "post_info POST-ID", "Shows detailed informations about post n°POST-ID (ayadn -PI POST-ID)"
		map "-PI" => :post_info
		long_desc Descriptions.post_info
		def post_info(post_id)
			Action.new.post_info(post_id)
		end

		desc "files", "Lists the files in your ADN storage (ayadn -F)"
		map "-F" => :files
		long_desc Descriptions.files
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		def files
			Action.new.files(options)
		end

		desc "delete", "Delete a post (ayadn -DEL POST-ID)"
		map "-DEL" => :delete
		long_desc Descriptions.delete
		def delete(post_id)
			Action.new.delete(post_id)
		end










	end
end