module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{stream api descriptions endpoints cnx view workers myconfig status extend db}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Shows the Unified Stream, aka your App.net timeline (ayadn -U)"
		map "-U" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			init
			begin
				Stream.new.unified(options)
			rescue Exception => e
				$logger.error "\n(in stream/unified) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "checkins", "Shows the Checkins Stream (ayadn -K)"
		map "-K" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			init
			begin
				Stream.new.checkins(options)
			rescue Exception => e
				$logger.error "\n(in stream/checkins) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "global", "Shows the Global Stream (ayadn -G)"
		map "-G" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			init
			begin
				Stream.new.global(options)
			rescue Exception => e
				$logger.error "\n(in stream/global) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "trending", "Shows the Trending Stream (ayadn -TR)"
		map "-TR" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			init
			begin
				Stream.new.trending(options)
			rescue Exception => e
				$logger.error "\n(in stream/trending) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "photos", "Shows the Photos Stream (ayadn -PH)"
		map "-PH" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			init
			begin
				Stream.new.photos(options)
			rescue Exception => e
				$logger.error "\n(in stream/photos) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "conversations", "Shows the Conversations Stream (ayadn -CQ)"
		map "-CQ" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			init
			begin
				Stream.new.conversations(options)
			rescue Exception => e
				$logger.error "\n(in stream/conversations) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "mentions @USERNAME", "Shows posts containing a mention of a @username (ayadn -M @username)"
		map "-M" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def mentions(*username)
			init
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.mentions(username_array.join, options)
				else
					puts Status.error_missing_username
				end
			rescue Exception => e
				$logger.error "\n(in stream/mentions) =>\n\n#{e}"
			ensure
				$db.close_all
			end
			
		end

		desc "posts @USERNAME", "Shows posts of @username (ayadn -PO @username)"
		map "-PO" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def posts(*username)
			init
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.posts(username_array.join, options)
				else
					puts Status.error_missing_username
				end
			rescue Exception => e
				$logger.error "\n(in stream/posts) =>\n\n#{e}"
			ensure
				$db.close_all
			end
			
		end

		desc "interactions", "Shows your recent ADN activity (ayadn -INT)"
		map "-INT" => :interactions
		long_desc Descriptions.interactions
		def interactions
			init
			begin
				Stream.new.interactions(options)
			rescue Exception => e
				$logger.error "\n(in stream/interactions) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "whatstarred @USERNAME", "Shows posts starred by @username (ayadn -WAS @username)"
		map "-WAS" => :whatstarred
		long_desc Descriptions.whatstarred
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def whatstarred(*username)
			init
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.whatstarred(username_array.join, options)
				else
					puts Status.error_missing_username
				end
			rescue Exception => e
				$logger.error "\n(in stream/whatstarred) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "whoreposted POST-ID", "Lists users who reposted post n°POST-ID (ayadn -WOR POST-ID)"
		map "-WOR" => :whoreposted
		long_desc Descriptions.whoreposted
		def whoreposted(post_id)
			init
			begin
				if post_id.is_integer?
					Stream.new.whoreposted(post_id)
				else
					puts Status.error_missing_post_id
				end
			rescue Exception => e
				$logger.error "\n(in stream/whoreposted) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "whostarred POST-ID", "Lists users who starred post n°POST-ID (ayadn -WOS POST-ID)"
		map "-WOS" => :whostarred
		long_desc Descriptions.whostarred
		def whostarred(post_id)
			init
			begin
				if post_id.is_integer?
					Stream.new.whostarred(post_id)
				else
					puts Status.error_missing_post_id
				end
			rescue Exception => e
				$logger.error "\n(in stream/whostarred) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "convo POST-ID", "Shows the conversation thread around post n°POST_ID (ayadn -CO POST-ID)"
		map "-CO" => :convo
		map "thread" => :convo
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		long_desc Descriptions.convo
		def convo(post_id)
			init
			begin
				if post_id.is_integer?
					Stream.new.convo(post_id, options)
				else
					puts Status.error_missing_post_id
				end
			rescue Exception => e
				$logger.error "\n(in stream/convo) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "followings @USERNAME", "Lists users @username is following (ayadn -FWG @username)"
		map "-FWG" => :followings
		long_desc Descriptions.followings
		def followings(*username)
			init
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.followings(username_array.join)
				else
					puts Status.error_missing_username
				end
			rescue Exception => e
				$logger.error "\n(in stream/followings) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "followers @USERNAME", "Lists users following @username (ayadn -FWR @username)"
		map "-FWR" => :followers
		long_desc Descriptions.followers
		def followers(*username)
			init
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.followers(username_array.join)
				else
					puts Status.error_missing_username
				end
			rescue Exception => e
				$logger.error "\n(in stream/followers) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "muted", "Lists the users you muted (ayadn -MTD)"
		map "-MTD" => :muted
		long_desc Descriptions.muted
		def muted
			init
			begin
				Stream.new.muted
			rescue Exception => e
				$logger.error "\n(in stream/muted) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "blocked", "Lists the users you blocked (ayadn -BKD)"
		map "-BKD" => :blocked
		long_desc Descriptions.blocked
		def blocked
			init
			begin
				Stream.new.blocked
			rescue Exception => e
				$logger.error "\n(in stream/blocked) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "hashtag HASHTAG", "Shows recent posts containing #HASHTAG (ayadn -TAG hashtag)"
		map "-TAG" => :hashtag
		long_desc Descriptions.hashtag
		def hashtag(hashtag)
			init
			begin
				Stream.new.hashtag(hashtag)
			rescue Exception => e
				$logger.error "\n(in stream/hashtag) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "search WORD(S)", "Shows recents posts containing WORD(S) (ayadn -S word1 word2 ...)"
		map "-S" => :search
		long_desc Descriptions.search
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def search(*words)
			init
			begin
				Stream.new.search(words.join(","), options)
			rescue Exception => e
				$logger.error "\n(in stream/search) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end

		desc "settings", "Lists current Ayadn settings (ayadn -OPT)"
		map "-OPT" => :settings
		long_desc Descriptions.settings
		def settings
			init
			begin
				Stream.new.view_settings
			rescue Exception => e
				$logger.error "\n(in stream/settings) =>\n\n#{e}"
			ensure
				$db.close_all
			end
		end


		private

		def init
			$config = MyConfig.new
			$logger = Logger.new($config.config[:paths][:log] + "/ayadn.log", 'monthly')
			$db = Databases.new
		end

		def add_arobase_if_absent(username)
			unless username.first == "me"
				username = username.first.chars.to_a
				username.unshift("@") unless username.first == "@"
			else
				username = "me".chars.to_a
			end
			username
		end

		# def remove_octothorpe_if_present(hashtags)
		# 	hashtags = hashtags.first.chars.to_a
		# 	hashtags.shift("#") if hashtags.first == "#"
		# 	hashtags
		# end

	end
end