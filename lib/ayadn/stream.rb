module Ayadn
	class Stream

		def initialize
			@api = API.new
			@view = View.new
		end

		def unified(options)
			print Status.downloading
			stream = @api.get_unified(options)
			@view.clear_line
			if options[:index]
				@view.show_posts_with_index(stream['data'])
			else
				@view.show_posts(stream['data'])
			end
		end

	end
end