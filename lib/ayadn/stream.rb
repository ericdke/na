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

		def whatstarred(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_whatstarred(username, options))
			get_view(stream, options)
		end

		def interactions
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_interactions)
			@view.clear_screen
			@view.show_interactions(stream)
		end

		def whoreposted(post_id)
			@view.clear_screen
			print Status.downloading
			list = get_data_from_response(@api.get_whoreposted(post_id))
			get_list(:whoreposted, list, post_id)
		end

		def whostarred(post_id)
			@view.clear_screen
			print Status.downloading
			list = get_data_from_response(@api.get_whostarred(post_id))
			get_list(:whostarred, list, post_id)
		end

		def convo(post_id, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_convo(post_id, options))
			get_view(stream, options)
		end

		def followings(username)
			@view.clear_screen
			print Status.downloading
			list = @api.get_followings(username)
			get_list(:followings, list, username)
		end

		def followers(username)
			@view.clear_screen
			print Status.downloading
			list = @api.get_followers(username)
			get_list(:followers, list, username)
		end

		def muted
			@view.clear_screen
			print Status.downloading
			list = @api.get_muted
			get_list(:muted, list, nil)
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

		def get_list(what, list, target)
			@view.clear_screen
			case what
			when :whoreposted
				@view.show_list_reposted(list, target)
			when :whostarred
				@view.show_list_starred(list, target)
			when :followings
				@view.show_list_followings(list, target)
			when :followers
				@view.show_list_followers(list, target)
			when :muted
				@view.show_list_muted(list)
			end
		end

	end
end