module Ayadn
  class Endpoints

    attr_accessor :ayadn_callback_url, :base_url, :config_api_url, :posts_url, :users_url, :files_url, :token_url, :channels_url, :pm_url

    def initialize
      @ayadn_callback_url = "http://aya.io/ayadn/auth.html"
      @base_url = "https://alpha-api.app.net/"
      @config_api_url = @base_url + "stream/0/config"
      @posts_url = @base_url + "stream/0/posts/"
      @users_url = @base_url + "stream/0/users/"
      @files_url = @base_url + "stream/0/files/"
      @token_url = @base_url + "stream/0/token/"
      @channels_url = @base_url + "stream/0/channels/"
      @pm_url = @channels_url + "pm/messages"
    end

    def authorize_url
      "https://account.app.net/oauth/authenticate?client_id=#{MyConfig::AYADN_CLIENT_ID}&response_type=token&redirect_uri=#{@ayadn_callback_url}&scope=basic stream write_post follow public_messages messages files&include_marker=1"
    end

    def file(file_id)
      "#{@files_url}#{file_id}?access_token=#{MyConfig.user_token}"
    end

    def unified(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:unified]})
      end
      "#{@posts_url}stream/unified?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def checkins(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:checkins]})
      end
      "#{@posts_url}stream/explore/checkins?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def global(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:global]})
      end
      "#{@posts_url}stream/global?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def trending(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:trending]})
      end
      "#{@posts_url}stream/explore/trending?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def photos(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:photos]})
      end
      "#{@posts_url}stream/explore/photos?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def conversations(options)
      if options[:count] || options[:since_id]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:conversations]})
      end
      "#{@posts_url}stream/explore/conversations?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def mentions(username, options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:mentions]})
      end
      "#{@users_url}#{username}/mentions/?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def posts(username, options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:posts]})
      end
      "#{@users_url}#{username}/posts/?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def whatstarred(username, options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:default]})
      end
      "#{@users_url}#{username}/stars/?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def interactions
      "#{@users_url}me/interactions?access_token=#{MyConfig.user_token}"
    end

    def whoreposted(post_id)
      "#{@posts_url}#{post_id}/reposters/?access_token=#{MyConfig.user_token}"
    end

    def whostarred(post_id)
      "#{@posts_url}#{post_id}/stars/?access_token=#{MyConfig.user_token}"
    end

    def convo(post_id, options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:convo]})
      end
      "#{@posts_url}#{post_id}/replies/?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def followings(username, options)
      "#{@users_url}#{username}/following/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def followers(username, options)
      "#{@users_url}#{username}/followers/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def muted(options)
      "#{@users_url}me/muted/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def blocked(options)
      "#{@users_url}me/blocked/?access_token=#{MyConfig.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def hashtag(hashtag)
      "#{@posts_url}tag/#{hashtag}"
    end

    def search(words, options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:search]})
      end
      "#{@posts_url}search?text=#{words}&access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def user(username)
      "#{@users_url}#{username}?access_token=#{MyConfig.user_token}"
    end

    def single_post(post_id, options)
      @options_list = MyConfig.build_query(options)
      "#{@posts_url}#{post_id}?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def files_list(options)
      if options[:count]
        @options_list = MyConfig.build_query(options)
      else
        @options_list = MyConfig.build_query({count: MyConfig.options[:counts][:files]})
      end
      "#{@users_url}me/files?access_token=#{MyConfig.user_token}#{@options_list}"
    end

    def delete_post(post_id)
      "#{@posts_url}#{post_id}?access_token=#{MyConfig.user_token}"
    end

    def follow(username)
      "#{@users_url}#{username}/follow?access_token=#{MyConfig.user_token}"
    end

    def mute(username)
      "#{@users_url}#{username}/mute?access_token=#{MyConfig.user_token}"
    end

    def block(username)
      "#{@users_url}#{username}/block?access_token=#{MyConfig.user_token}"
    end

    def repost(post_id)
      "#{@posts_url}#{post_id}/repost?access_token=#{MyConfig.user_token}"
    end

    def star(post_id)
      "#{@posts_url}#{post_id}/star?access_token=#{MyConfig.user_token}"
    end

    def channels(options)
      "#{@channels_url}?access_token=#{MyConfig.user_token}#{MyConfig.build_query(options)}"
    end

    def messages(channel_id, options)
      "#{@channels_url}#{channel_id}/messages?access_token=#{MyConfig.user_token}#{MyConfig.build_query(options)}"
    end

  end
end
