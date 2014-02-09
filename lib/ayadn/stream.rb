module Ayadn
	class Stream
		def unified(options)
			puts "XXX SHOW UNIFIED"
			puts "with number: #{options[:count]}" if options[:count]
			a = Ayadn::API.new
		end
	end
end