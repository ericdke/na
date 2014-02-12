module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{stream api descriptions endpoints cnx view workers myconfig status extend}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Shows the Unified Stream, aka your App.net timeline (ayadn -U)"
		map "-U" => :unified
		map "uni" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			init
			Stream.new.unified(options)
		end

		desc "checkins", "Shows the Checkins Stream (ayadn -K)"
		map "-K" => :checkins
		map "chk" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			init
			Stream.new.checkins(options)
		end

		desc "global", "Shows the Global Stream (ayadn -G)"
		map "-G" => :global
		map "glo" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			init
			Stream.new.global(options)
		end

		desc "trending", "Shows the Trending Stream (ayadn -TR)"
		map "-TR" => :trending
		map "tre" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			init
			Stream.new.trending(options)
		end

		desc "photos", "Shows the Photos Stream (ayadn -PH)"
		map "-PH" => :photos
		map "pho" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			init
			Stream.new.photos(options)
		end

		desc "conversations", "Shows the Conversations Stream (ayadn -CQ)"
		map "-CQ" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			init
			Stream.new.conversations(options)
		end

		desc "mentions @USERNAME", "Shows posts containing a mention of a @username (ayadn -M @username)"
		map "-M" => :mentions
		map "men" => :mentions
		long_desc Descriptions.mentions
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def mentions(*username)
			init
			unless username.empty?
				username_array = add_arobase_if_absent(username)
				Stream.new.mentions(username_array.join, options)
			else
				puts Status.error_missing_username
			end
		end

		desc "posts @USERNAME", "Shows posts of @username (ayadn -PO @username)"
		map "-PO" => :posts
		long_desc Descriptions.posts
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def posts(*username)
			init
			unless username.empty?
				username_array = add_arobase_if_absent(username)
				Stream.new.posts(username_array.join, options)
			else
				puts Status.error_missing_username
			end
		end

		desc "starred @USERNAME", "Shows posts starred by @username (ayadn -ST @username)"
		map "-ST" => :starred
		long_desc Descriptions.starred
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def starred(*username)
			init
			unless username.empty?
				username_array = add_arobase_if_absent(username)
				Stream.new.starred(username_array.join, options)
			else
				puts Status.error_missing_username
			end
		end

		desc "interactions", "Shows your recent ADN activity (ayadn -HIST)"
		map "-HIST" => :interactions
		long_desc Descriptions.interactions
		def interactions
			init
			Stream.new.interactions
		end

		desc "reposted POST-ID", "Lists users who reposted post n° POST-ID"
		map "-WR" => :reposted
		long_desc Descriptions.reposted
		def reposted(post_id)
			init

		end


		#desc "starred POST-ID", "Lists users who starred post n° POST-ID"




		private

		def init
			$config = MyConfig.new
		end

		def add_arobase_if_absent(username)
			username = username.first.chars.to_a
			username.unshift("@") unless username.first == "@"
		end

	end
end