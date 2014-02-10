module Ayadn
	class Stream
		def unified(options)
			puts "XXX SHOW UNIFIED"
			puts "with number: #{options[:count]}" if options[:count]
			puts "Calling API..."
			@stream = API.new.get_unified
			puts @stream
		end
	end
end