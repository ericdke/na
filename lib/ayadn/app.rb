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

		private

		def init
			$config = MyConfig.new
		end

	end
end