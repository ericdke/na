module Ayadn
	class CNX
		def get_response_from(url)
			return RestClient::Resource.new(
				url,
				:verify_ssl       =>  OpenSSL::SSL::VERIFY_NONE
			).get 
		end
	end
end