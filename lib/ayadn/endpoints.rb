module Ayadn
	class Endpoints

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
			"https://account.app.net/oauth/authenticate?client_id=#{MyConfig::AYADN_CLIENT_ID}&response_type=token&redirect_uri=#{AYADN_CALLBACK_URL}&scope=basic stream write_post follow public_messages messages files&include_marker=1"
		end

		def unified(options)
			init(options)
			POSTS_URL + "stream/unified?access_token=#{$config.user_token}#{@options_list}"
		end

		def checkins(options)
			init(options)
			POSTS_URL + "stream/explore/checkins?access_token=#{$config.user_token}#{@options_list}"
		end

		def global(options)
			init(options)
			POSTS_URL + "stream/global?access_token=#{$config.user_token}#{@options_list}"
		end

		def trending(options)
			init(options)
			POSTS_URL + "stream/explore/trending?access_token=#{$config.user_token}#{@options_list}"
		end

		def photos(options)
			init(options)
			POSTS_URL + "stream/explore/photos?access_token=#{$config.user_token}#{@options_list}"
		end

		def conversations(options)
			init(options)
			POSTS_URL + "stream/explore/conversations?access_token=#{$config.user_token}#{@options_list}"
		end

		def mentions(username, options)
			init(options)
			USERS_URL + "#{username}/mentions/?access_token=#{$config.user_token}#{@options_list}"
		end

		def posts(username, options)
			init(options)
			USERS_URL + "#{username}/posts/?access_token=#{$config.user_token}#{@options_list}"
		end

		def whatstarred(username, options)
			init(options)
			USERS_URL + "#{username}/stars/?access_token=#{$config.user_token}#{@options_list}"
		end

		def interactions
			USERS_URL + "me/interactions?access_token=#{$config.user_token}"
		end

		def whoreposted(post_id)
			POSTS_URL + "#{post_id}/reposters/?access_token=#{$config.user_token}"
		end

		def whostarred(post_id)
			POSTS_URL + "#{post_id}/stars/?access_token=#{$config.user_token}"
		end

		private

		def init(options)
			@options_list = $config.build_query_options(options)
		end

	end
end