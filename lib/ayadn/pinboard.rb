module Ayadn
	class PinBoard

		def encode(username, password)
			enc_me = [username, password].join(":")
			"AyadnPinboard #{Base64.strict_encode64(enc_me)}"
		end

		def decode(encoded_pinboard_credentials)
			dec_me = encoded_pinboard_credentials[/AyadnPinboard (.*)/, 1]
			Base64.strict_decode64(dec_me).split(":")
		end

		def save_credentials(encoded_pinboard_credentials)
			f = File.new(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db', 'w')
			f.write(encoded_pinboard_credentials)
			f.close
		end

		def load_credentials
			File.read(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db')
		end

		def has_credentials_file?
			File.exist?(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db')
		end

		def pin(data)
			pinboard = Pinboard::Client.new(:username => data.username, :password => data.password)
			pinboard.add(:url => data.url, :tags => data.tags, :extended => data.text, :description => data.description)
		end

		def client(username, password)
			Pinboard::Client.new(:username => username, :password => password)
		end

		def get_pinboard_links(username, password, count)
			pin = client(username, password)
			pin.posts(:results => count)
		end

	end
end
