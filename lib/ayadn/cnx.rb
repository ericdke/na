module Ayadn
	class CNX

		def get_response_from(url)
			return RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).get 
		end

		def check_errors(meta)
			if meta['code'] != 200
				puts "\nERROR #{meta['code']}\n"
				puts meta.inspect
			end
		end

	end
end