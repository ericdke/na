module Ayadn
	require_relative "descriptions"
	$desc = Descriptions.new

	class App < Thor
		package_name "ayadn"
		require_relative "stream"
		
		desc "unified", "Shows your Unified Stream."
		map "-U" => :unified
		map "uni" => :unified
		map "stream" => :unified
		long_desc $desc.unified
		option :count, aliases: "-c"
		def unified
			Stream.new.unified(options)
		end

		
	end
end