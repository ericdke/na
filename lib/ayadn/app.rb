module Ayadn
	class App < Thor
		package_name "ayadn"
		require_relative "stream"
		require_relative "api"
		require_relative "descriptions"
		require_relative "endpoints"
		require_relative "cnx"
		require_relative "view"
		@desc = Descriptions.new
		
		desc "unified", "Shows your Unified Stream."
		map "-U" => :unified
		map "uni" => :unified
		map "stream" => :unified
		#long_desc @desc.unified
		option :count, aliases: "-c"
		def unified
			puts Stream.new.unified(options)
		end


	end
end