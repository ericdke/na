module Ayadn
	class Stream

		def initialize
			@api = API.new
			@view = View.new
			@workers = Workers.new
		end

		def unified(options)
			print Status.downloading
			@stream = @api.get_unified(options)
			posts = @workers.build_stream(@stream['data'])
			@view.clear_line
			ap posts
			#@view.show_posts_with_index(posts_array)
			#@view.show_posts(posts_array)
		end

	end
end