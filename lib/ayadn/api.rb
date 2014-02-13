module Ayadn
	class API

		def initialize
			@endpoints = Endpoints.new
			@cnx = CNX.new
		end
		
		def get_unified(options)
			url = @endpoints.unified(options)
			get_parsed_response(url)
		end

		def get_checkins(options)
			url = @endpoints.checkins(options)
			get_parsed_response(url)
		end

		def get_global(options)
			url = @endpoints.global(options)
			get_parsed_response(url)
		end

		def get_trending(options)
			get_explore(:trending, options)
		end
		def get_photos(options)
			get_explore(:photos, options)
		end
		def get_conversations(options)
			get_explore(:conversations, options)
		end

		def get_explore(explore, options)
			url = @endpoints.trending(options) if explore == :trending
			url = @endpoints.photos(options) if explore == :photos
			url = @endpoints.conversations(options) if explore == :conversations
			get_parsed_response(url)
		end

		def get_mentions(username, options)
			url = @endpoints.mentions(username, options)
			get_parsed_response(url)
		end

		def get_posts(username, options)
			url = @endpoints.posts(username, options)
			get_parsed_response(url)
		end

		def get_whatstarred(username, options)
			url = @endpoints.whatstarred(username, options)
			get_parsed_response(url)
		end

		def get_interactions
			url = @endpoints.interactions
			get_parsed_response(url)
		end

		def get_whoreposted(post_id)
			url = @endpoints.whoreposted(post_id)
			get_parsed_response(url)
		end

		def get_whostarred(post_id)
			url = @endpoints.whostarred(post_id)
			get_parsed_response(url)
		end

		def get_convo(post_id, options)
			url = @endpoints.convo(post_id, options)
			get_parsed_response(url)
		end

		private

		def get_raw_response(url)
			@cnx.get_response_from(url)
		end

		def get_parsed_response(url)
			r = JSON.parse(@cnx.get_response_from(url))
			@cnx.check_errors(r['meta'])
			return r
		end

	end
end