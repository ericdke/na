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
			posts = @workers.build_posts(@stream['data'])
			@view.clear_line
			if options[:index]
				@view.show_posts_with_index(posts)
			else
				@view.show_posts(posts)
			end
		end

	end
end