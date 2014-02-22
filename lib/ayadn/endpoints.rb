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

		def self.authorize_url
			"https://account.app.net/oauth/authenticate?client_id=#{MyConfig::AYADN_CLIENT_ID}&response_type=token&redirect_uri=#{AYADN_CALLBACK_URL}&scope=basic stream write_post follow public_messages messages files&include_marker=1"
		end

		def self.unified(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:unified]})
			end
			POSTS_URL + "stream/unified?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.checkins(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:checkins]})
			end
			POSTS_URL + "stream/explore/checkins?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.global(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:global]})
			end
			POSTS_URL + "stream/global?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.trending(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:trending]})
			end
			POSTS_URL + "stream/explore/trending?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.photos(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:photos]})
			end
			POSTS_URL + "stream/explore/photos?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.conversations(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:conversations]})
			end
			POSTS_URL + "stream/explore/conversations?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.mentions(username, options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:mentions]})
			end
			USERS_URL + "#{username}/mentions/?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.posts(username, options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:posts]})
			end
			USERS_URL + "#{username}/posts/?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.whatstarred(username, options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:default]})
			end
			USERS_URL + "#{username}/stars/?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.interactions
			USERS_URL + "me/interactions?access_token=#{MyConfig.user_token}"
		end

		def self.whoreposted(post_id)
			POSTS_URL + "#{post_id}/reposters/?access_token=#{MyConfig.user_token}"
		end

		def self.whostarred(post_id)
			POSTS_URL + "#{post_id}/stars/?access_token=#{MyConfig.user_token}"
		end

		def self.convo(post_id, options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:convo]})
			end
			POSTS_URL + "#{post_id}/replies/?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.followings(username, options)
			USERS_URL + "#{username}/following/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def self.followers(username, options)
			USERS_URL + "#{username}/followers/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def self.muted(options)
			USERS_URL + "me/muted/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def self.blocked(options)
			USERS_URL + "me/blocked/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
		end

		def self.hashtag(hashtag)
			POSTS_URL + "tag/#{hashtag}"
		end

		def self.search(words, options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:search]})
			end
			POSTS_URL + "search?text=#{words}&access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.user(username)
			USERS_URL + "#{username}?access_token=#{MyConfig.user_token}"
		end

		def self.single_post(post_id)
			@options_list = MyConfig.build_query_options({annotations: 1})
			POSTS_URL + "#{post_id}?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.files_list(options)
			if options[:count]
				@options_list = MyConfig.build_query_options(options)
			else
				@options_list = MyConfig.build_query_options({count: MyConfig.options[:counts][:files]})
			end
			USERS_URL + "me/files?access_token=#{MyConfig.user_token}#{@options_list}"
		end

		def self.delete_post(post_id)
			POSTS_URL + "#{post_id}?access_token=#{MyConfig.user_token}"
		end

		def self.follow(username)
			USERS_URL + "#{username}/follow?access_token=#{MyConfig.user_token}"
		end

	end
end