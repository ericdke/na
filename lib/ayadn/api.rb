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