module Ayadn
	class Stream
		def unified(options)
			@stream = API.new.get_unified(options)
			puts @stream['data']
		end
	end
end