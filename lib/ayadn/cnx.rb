module Ayadn
	class CNX

		def self.get_response_from(url)
			begin
				RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).get
			rescue => e
				$logger.error "From cnx/get: #{e}"
			end
		end

		# def check_errors(meta)
		# 	if meta['code'] != 200
		# 		puts "\nERROR #{meta['code']}\n"
		# 		puts meta.inspect
		# 	end
		# end

	end
end