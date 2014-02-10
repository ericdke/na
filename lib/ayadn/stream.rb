module Ayadn
	class Stream

		def initialize
			@view = View.new
		end

		def unified(options)
			@stream = API.new.get_unified(options)
			posts_array = @view.view_stream(@stream['data'])
			@view.show_posts_with_index(posts_array)
		end

	end
end