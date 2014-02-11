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