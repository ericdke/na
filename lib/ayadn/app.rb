module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{stream api descriptions endpoints cnx view workers myconfig status}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Shows the Unified Stream, aka your App.net timeline (ayadn -U)"
		map "-U" => :unified
		map "uni" => :unified
		map "un" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			init
			Stream.new.unified(options)
		end

		desc "checkins", "Shows the Checkins Stream (ayadn -W)"
		map "-W" => :checkins
		map "ch" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			init
			Stream.new.checkins(options)
		end

		desc "global", "Shows the Global Stream (ayadn -G)"
		map "-G" => :global
		map "gl" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			init
			Stream.new.global(options)
		end

		desc "trending", "Shows the Trending Stream (ayadn -T)"
		map "-T" => :trending
		map "tr" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			init
			Stream.new.trending(options)
		end

		desc "photos", "Shows the Photos Stream (ayadn -H)"
		map "-H" => :photos
		map "ph" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			init
			Stream.new.photos(options)
		end

		desc "conversations", "Shows the Conversations Stream (ayadn -Q)"
		map "-Q" => :conversations
		long_desc Descriptions.conversations
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def conversations
			init
			Stream.new.conversations(options)
		end

		desc "mentions @USERNAME", "Shows posts containing a mention of a @username (ayadn -M @username)"
		map "-M" => :mentions
		map "mn" => :mentions
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

		desc "posts @USERNAME", "Shows posts of @username (ayadn -P @username)"
		map "-P" => :posts
		map "ps" => :posts
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

		desc "starred @USERNAME", "Shows posts starred by @username"
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