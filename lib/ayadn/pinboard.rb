module Ayadn
	class PinBoard
		require 'base64'
		#TODO: extract link/text/tags + create post, post it

		def self.encode(username, password)
			enc_me = [username, password].join(":")
			"AyadnPinboard #{Base64.strict_encode64(enc_me)}"
		end
		def self.decode(encoded_pinboard_credentials)
			dec_me = encoded_pinboard_credentials[/AyadnPinboard (.*)/, 1]
			Base64.strict_decode64(dec_me).split(":")
		end
		def self.save_credentials(encoded_pinboard_credentials)
			f = File.new(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.enc', 'w')
			f.write(self.encode(username, password))
			f.close
		end
		def self.load_credentials
			File.read(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.enc')
		end

	end
end
