module Ayadn
	class Endpoints
		USER_TOKEN = IO.read(File.expand_path("../../../token", __FILE__)).chomp
		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"
		AYADN_CALLBACK_URL = "http://aya.io/ayadn/auth.html"
		BASE_URL = "https://alpha-api.app.net/"
		CONFIG_API_URL = BASE_URL + "stream/0/config"
		POSTS_URL = BASE_URL + "stream/0/posts/"
		USERS_URL = BASE_URL + "stream/0/users/"
		FILES_URL = BASE_URL + "stream/0/files/"
		TOKEN_URL = BASE_URL + "stream/0/token/"
		CHANNELS_URL = BASE_URL + "stream/0/channels/"
		PM_URL = CHANNELS_URL + "pm/messages"
		def authorize_url
			"https://account.app.net/oauth/authenticate?client_id=#{AYADN_CLIENT_ID}&response_type=token&redirect_uri=#{AYADN_CALLBACK_URL}&scope=basic stream write_post follow public_messages messages files&include_marker=1"
		end
		def unified(options)
			count = options[:count] || 200
			return POSTS_URL + "stream/unified?access_token=#{USER_TOKEN}&count=#{count}"
		end
	end
end