module Ayadn
	class Stream

		def initialize
			@view = View.new
		end

		def unified(options)
			@stream = API.new.get_unified(options)
			@view.view_stream(@stream['data'])
		end

	end
end