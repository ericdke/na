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
			Stream.new.unified(options)
		end

		desc "checkins", "Shows the Checkins Stream (ayadn -K)"
		map "-K" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			Stream.new.checkins(options)
		end

		desc "global", "Shows the Global Stream (ayadn -G)"
		map "-G" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			Stream.new.global(options)
		end

		desc "trending", "Shows the Trending Stream (ayadn -TR)"
		map "-TR" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			Stream.new.trending(options)
		end

		desc "photos", "Shows the Photos Stream (ayadn -PH)"
		map "-PH" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			Stream.new.photos(options)
		end

		desc "conversations", "Shows the Conversations Stream (ayadn -CQ)"
		map "-CQ" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			Stream.new.conversations(options)
		end

		desc "mentions @USERNAME", "Shows posts containing a mention of a @username (ayadn -M @username)"
		map "-M" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def mentions(*username)
			Stream.new.mentions(username, options)
		end

		desc "posts @USERNAME", "Shows posts of @username (ayadn -PO @username)"
		map "-PO" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def posts(*username)
			Stream.new.posts(username, options)
		end

		desc "interactions", "Shows your recent ADN activity (ayadn -INT)"
		map "-INT" => :interactions
		long_desc Descriptions.interactions
		def interactions
			Stream.new.interactions
		end

		desc "whatstarred @USERNAME", "Shows posts starred by @username (ayadn -WAS @username)"
		map "-WAS" => :whatstarred
		long_desc Descriptions.whatstarred
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def whatstarred(*username)
			Stream.new.whatstarred(username, options)
		end

		desc "whoreposted POST-ID", "Lists users who reposted post n°POST-ID (ayadn -WOR POST-ID)"
		map "-WOR" => :whoreposted
		long_desc Descriptions.whoreposted
		def whoreposted(post_id)
			Stream.new.whoreposted(post_id)
		end

		desc "whostarred POST-ID", "Lists users who starred post n°POST-ID (ayadn -WOS POST-ID)"
		map "-WOS" => :whostarred
		long_desc Descriptions.whostarred
		def whostarred(post_id)
			Stream.new.whostarred(post_id)
		end

		desc "convo POST-ID", "Shows the conversation thread around post n°POST_ID (ayadn -CO POST-ID)"
		map "-CO" => :convo
		map "thread" => :convo
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		long_desc Descriptions.convo
		def convo(post_id)
			Stream.new.convo(post_id, options)
		end

		desc "followings @USERNAME", "Lists users @username is following (ayadn -FWG @username)"
		map "-FWG" => :followings
		long_desc Descriptions.followings
		def followings(*username)
			Stream.new.followings(username)
		end

		desc "followers @USERNAME", "Lists users following @username (ayadn -FWR @username)"
		map "-FWR" => :followers
		long_desc Descriptions.followers
		def followers(*username)
			Stream.new.followers(username)
		end

		desc "muted", "Lists the users you muted (ayadn -MTD)"
		map "-MTD" => :muted
		long_desc Descriptions.muted
		def muted
			Stream.new.muted
		end

		desc "blocked", "Lists the users you blocked (ayadn -BKD)"
		map "-BKD" => :blocked
		long_desc Descriptions.blocked
		def blocked
			begin
				Stream.new.blocked
			rescue => e
				$logger.error "From stream/blocked"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		desc "hashtag HASHTAG", "Shows recent posts containing #HASHTAG (ayadn -TAG hashtag)"
		map "-TAG" => :hashtag
		long_desc Descriptions.hashtag
		def hashtag(hashtag)
			begin
				Stream.new.hashtag(hashtag)
			rescue => e
				$logger.error "From stream/hashtag with args: #{hashtag}"
				$logger.error "#{e}"
				global_error(e)
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
			begin
				Stream.new.search(words.join(","), options)
			rescue => e
				$logger.error "From stream/search with args: #{words}"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		desc "settings", "Lists current Ayadn settings (ayadn -OPT)"
		map "-OPT" => :settings
		long_desc Descriptions.settings
		def settings
			begin
				Stream.new.view_settings
			rescue => e
				$logger.error "From stream/settings"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		desc "user @USERNAME", "Shows detailed informations about @username (ayadn -UI @username)"
		map "-UI" => :user
		long_desc Descriptions.user
		def user(*username)
			begin
				unless username.empty?
					username_array = add_arobase_if_absent(username)
					Stream.new.user(username_array.join)
				else
					puts Status.error_missing_username
				end
			rescue => e
				$logger.error "From stream/user with args: #{username}"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		desc "details POST-ID", "Shows detailed informations about post n°POST-ID (ayadn -PI POST-ID)"
		map "-PI" => :details
		long_desc Descriptions.details
		def details(post_id)
			begin
				if post_id.is_integer?
					Stream.new.details(post_id)
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				$logger.error "From stream/details with args: #{post_id}"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		desc "files", "Lists the files in your ADN storage (ayadn -F)"
		map "-F" => :files
		long_desc Descriptions.files
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		def files
			begin
				Stream.new.files(options)
			rescue => e
				$logger.error "From stream/files"
				$logger.error "#{e}"
				global_error(e)
				raise e
			ensure
				$db.close_all
			end
		end

	end
end