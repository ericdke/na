module Ayadn
	class Stream

		def initialize
			@view = View.new
			@workers = Workers.new
		end

		def unified(options)
			@stream = API.new.get_unified(options)
			posts_array = @workers.build_stream(@stream['data'])
			@view.show_posts_with_index(posts_array)
			#@view.show_posts(posts_array)
		end

	end
end