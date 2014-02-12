module Ayadn
	class Stream

		def initialize
			@api = API.new
			@view = View.new
		end

		def unified(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_unified(options))
			get_view(stream, options)
		end

		def checkins(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_checkins(options))
			get_view(stream, options)
		end

		def global(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_global(options))
			get_view(stream, options)
		end

		def trending(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_trending(options))
			get_view(stream, options)
		end

		def photos(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_photos(options))
			get_view(stream, options)
		end

		def conversations(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_conversations(options))
			get_view(stream, options)
		end

		def mentions(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_mentions(username, options))
			get_view(stream, options)
		end

		def posts(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_posts(username, options))
			get_view(stream, options)
		end

		def starred(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_starred(username, options))
			get_view(stream, options)
		end

		def interactions
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_interactions)
			@view.clear_screen
			@view.show_interactions(stream)
		end

		def reposted(post_id)
			@view.clear_screen
			print Status.downloading
			list = get_data_from_response(@api.get_reposted(post_id))
			get_list(list)
		end



		private

		def get_data_from_response(response)
			response['data']
		end

		def get_view(stream, options = {})
			@view.clear_screen
			if options[:index]
				@view.show_posts_with_index(stream)
			else
				@view.show_posts(stream)
			end
		end

		def get_simple_view(stream)
			@view.clear_screen
			@view.show_simple_stream(stream)
		end

		def get_list(list)
			@view.clear_screen
			@view.show_list(list)
		end

	end
end