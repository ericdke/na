module Ayadn
	class CNX

		def self.get_response_from(url)
			begin
				RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).get
			rescue => e
				Logs.rec.error "From cnx/get"
				Logs.rec.error "#{e}"
			end
		end

		def self.delete(url)
			begin
				RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).delete
			rescue => e
				Logs.rec.error "From cnx/delete"
				Logs.rec.error "#{e}"
			end
		end

	end
end