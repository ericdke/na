module Ayadn
	# Your code goes here...
	class App < Thor
		package_name "Ayadn"

		desc "unified", "Shows your Unified Stream. You may specify the number of posts to retrieve with '-c NUMBER'."
		option :count, aliases: "-c"
		def unified
			Stream.new.unified(options)
		end
	end
	class Stream
		def unified(options)
			puts "XXX SHOW UNIFIED"
			puts "with number: #{options[:count]}" if options[:count]
		end
	end
end