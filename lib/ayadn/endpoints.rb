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
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:unified]})
			end
			POSTS_URL + "stream/unified?access_token=#{$config.user_token}#{@options_list}"
		end

		def checkins(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:checkins]})
			end
			POSTS_URL + "stream/explore/checkins?access_token=#{$config.user_token}#{@options_list}"
		end

		def global(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:global]})
			end
			POSTS_URL + "stream/global?access_token=#{$config.user_token}#{@options_list}"
		end

		def trending(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:trending]})
			end
			POSTS_URL + "stream/explore/trending?access_token=#{$config.user_token}#{@options_list}"
		end

		def photos(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:photos]})
			end
			POSTS_URL + "stream/explore/photos?access_token=#{$config.user_token}#{@options_list}"
		end

		def conversations(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:conversations]})
			end
			POSTS_URL + "stream/explore/conversations?access_token=#{$config.user_token}#{@options_list}"
		end

		def mentions(username, options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:mentions]})
			end
			USERS_URL + "#{username}/mentions/?access_token=#{$config.user_token}#{@options_list}"
		end

		def posts(username, options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:posts]})
			end
			USERS_URL + "#{username}/posts/?access_token=#{$config.user_token}#{@options_list}"
		end

		def whatstarred(username, options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:default]})
			end
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

		def convo(post_id, options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:convo]})
			end
			POSTS_URL + "#{post_id}/replies/?access_token=#{$config.user_token}#{@options_list}"
		end

		def followings(username, options)
			USERS_URL + "#{username}/following/?access_token=#{$config.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def followers(username, options)
			USERS_URL + "#{username}/followers/?access_token=#{$config.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def muted(options)
			USERS_URL + "me/muted/?access_token=#{$config.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def blocked(options)
			USERS_URL + "me/blocked/?access_token=#{$config.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def hashtag(hashtag)
			POSTS_URL + "tag/#{hashtag}"
		end

		def search(words, options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:search]})
			end
			POSTS_URL + "search?text=#{words}&access_token=#{$config.user_token}#{@options_list}"
		end

		def user(username)
			USERS_URL + "#{username}?access_token=#{$config.user_token}"
		end

		def single_post(post_id)
			init({annotations: 1})
			POSTS_URL + "#{post_id}?access_token=#{$config.user_token}#{@options_list}"
		end

		def files_list(options)
			if options[:count]
				init(options)
			else
				init({count: $config.options[:counts][:files]})
			end
			USERS_URL + "me/files?access_token=#{$config.user_token}#{@options_list}"
		end

		private

		def init(options)
			@options_list = $config.build_query_options(options)
		end

	end
end