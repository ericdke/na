module Ayadn
	class App < Thor
		package_name "ayadn"

		%w{stream api descriptions endpoints cnx view workers myconfig status}.each { |r| require_relative "#{r}" }
		
		desc "unified", "Shows the Unified Stream (aka your App.net timeline)"
		map "-U" => :unified
		map "uni" => :unified
		map "stream" => :unified
		long_desc Descriptions.unified
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def unified
			init
			Stream.new.unified(options)
		end

		desc "checkins", "Shows the Checkins Stream"
		map "-W" => :checkins
		map "chk" => :checkins
		long_desc Descriptions.checkins
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def checkins
			init
			Stream.new.checkins(options)
		end

		desc "global", "Shows the Global Stream"
		map "-G" => :global
		map "glo" => :global
		long_desc Descriptions.global
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def global
			init
			Stream.new.global(options)
		end

		desc "trending", "Shows the Trending Stream"
		map "-T" => :trending
		map "tre" => :trending
		long_desc Descriptions.trending
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def trending
			init
			Stream.new.trending(options)
		end

		desc "photos", "Shows the Photos Stream"
		map "-P" => :photos
		map "pho" => :photos
		long_desc Descriptions.photos
		option :count, aliases: "-c", type: :numeric, desc: "Specify the number of posts to retrieve"
		option :index, aliases: "-i", type: :boolean, desc: "Use an ordered index instead of the posts ids"
		def photos
			init
			Stream.new.photos(options)
		end







		private

		def init
			$config = MyConfig.new
		end

	end
end