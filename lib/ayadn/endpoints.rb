# encoding: utf-8
module Ayadn
  class Endpoints

    attr_accessor :ayadn_callback_url, :base_url, :config_api_url, :posts_url, :users_url, :files_url, :token_url, :channels_url, :pm_url

    # Warning
    # comment next line
    require_relative "ids"
    # uncomment and insert your own URL
    # CALLBACK_URL = ""

    def initialize
      @ayadn_callback_url = CALLBACK_URL
      api_file = Dir.home + "/ayadn/.api.yml"
      @base_url = if File.exist?(api_file)
        YAML.load(File.read(api_file))[:root] + "/"
      else
        "https://api.app.net/"
      end
      @config_api_url = @base_url + "config"
      @posts_url = @base_url + "posts/"
      @users_url = @base_url + "users/"
      @files_url = @base_url + "files/"
      @token_url = @base_url + "token/"
      @channels_url = @base_url + "channels/"
      @pm_url = @channels_url + "pm/messages"
    end

    def authorize_url
      "https://account.app.net/oauth/authenticate?client_id=#{Settings::CLIENT_ID}&response_type=token&redirect_uri=#{@ayadn_callback_url}&scope=basic,stream,write_post,follow,public_messages,messages,files,update_profile&include_marker=1"
    end

    def token_info
      "#{@token_url}?access_token=#{Settings.user_token}"
    end

    def file(file_id)
      "#{@files_url}#{file_id}?access_token=#{Settings.user_token}"
    end

    def files
      "#{@files_url}?access_token=#{Settings.user_token}"
    end

    private

    def make_options_list(options)
      @options_list = if options[:count] || options[:since_id]
        API.build_query(options)
      else
        yield
      end
    end

    def make_options_list_simple(options)
      @options_list = if options[:count]
        API.build_query(options)
      else
        yield
      end
    end

    public

    def unified(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.unified})
      end
      "#{@posts_url}stream/unified?access_token=#{Settings.user_token}#{@options_list}"
    end

    def checkins(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.checkins})
      end
      "#{@posts_url}stream/explore/checkins?access_token=#{Settings.user_token}#{@options_list}"
    end

    def global(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.global})
      end
      if Settings.global.force
        "#{@posts_url}stream/global?#{@options_list}"
      else
        "#{@posts_url}stream/global?access_token=#{Settings.user_token}#{@options_list}"
      end
    end

    def trending(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.trending})
      end
      "#{@posts_url}stream/explore/trending?access_token=#{Settings.user_token}#{@options_list}"
    end

    def photos(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.photos})
      end
      "#{@posts_url}stream/explore/photos?access_token=#{Settings.user_token}#{@options_list}"
    end

    def conversations(options)
      make_options_list(options) do
        API.build_query({count: Settings.options.counts.conversations})
      end
      "#{@posts_url}stream/explore/conversations?access_token=#{Settings.user_token}#{@options_list}"
    end

    def mentions(username, options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.mentions})
      end
      "#{@users_url}#{username}/mentions/?access_token=#{Settings.user_token}#{@options_list}"
    end

    def posts(username, options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.posts})
      end
      if Settings.global.force
        "#{@users_url}#{username}/posts/?#{@options_list}"
      else
        "#{@users_url}#{username}/posts/?access_token=#{Settings.user_token}#{@options_list}"
      end
    end

    def whatstarred(username, options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.default})
      end
      "#{@users_url}#{username}/stars/?access_token=#{Settings.user_token}#{@options_list}"
    end

    def interactions
      "#{@users_url}me/interactions?access_token=#{Settings.user_token}"
    end

    def whoreposted(post_id)
      "#{@posts_url}#{post_id}/reposters/?access_token=#{Settings.user_token}"
    end

    def whostarred(post_id)
      "#{@posts_url}#{post_id}/stars/?access_token=#{Settings.user_token}"
    end

    def convo(post_id, options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.convo})
      end
      "#{@posts_url}#{post_id}/replies/?access_token=#{Settings.user_token}#{@options_list}"
    end

    def followings(username, options)
      "#{@users_url}#{username}/following/?access_token=#{Settings.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def followers(username, options)
      "#{@users_url}#{username}/followers/?access_token=#{Settings.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def muted(options)
      "#{@users_url}me/muted/?access_token=#{Settings.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def blocked(options)
      "#{@users_url}me/blocked/?access_token=#{Settings.user_token}&count=#{options[:count]}&before_id=#{options[:before_id]}"
    end

    def hashtag(hashtag)
      "#{@posts_url}tag/#{hashtag}"
    end

    def search(words, options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.search})
      end
      "#{@posts_url}search?text=#{words}&access_token=#{Settings.user_token}#{@options_list}"
    end

    def search_users words, options
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.search})
      end
      "#{@users_url}search?q=#{words}&access_token=#{Settings.user_token}#{@options_list}"
    end

    def search_annotations anno, options
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.search})
      end
      "#{@posts_url}search?annotation_types=#{anno}&access_token=#{Settings.user_token}#{@options_list}"
    end

    def search_messages channel_id, words, options
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.search})
      end
      "#{@channels_url}messages/search?query=#{words}&channel_ids=#{channel_id}&access_token=#{Settings.user_token}#{@options_list}"
    end

    def search_channels words, options
        @options_list = API.build_query({count: Settings.options.counts.search})
      "#{@channels_url}search?q=#{words}&order=popularity&access_token=#{Settings.user_token}#{@options_list}"
    end

    def user(username) # accepts a string
      "#{@users_url}#{username}?access_token=#{Settings.user_token}&include_user_annotations=1"
    end

    def users(usernames) # accepts an array
      "#{@users_url}?ids=#{usernames.join(',')}?access_token=#{Settings.user_token}&include_user_annotations=1"
    end

    def single_post(post_id, options)
      "#{@posts_url}#{post_id}?access_token=#{Settings.user_token}#{API.build_query(options)}"
    end

    def files_list(options)
      make_options_list_simple(options) do
        API.build_query({count: Settings.options.counts.files})
      end
      "#{@users_url}me/files?access_token=#{Settings.user_token}#{@options_list}"
    end

    def delete_post(post_id)
      "#{@posts_url}#{post_id}?access_token=#{Settings.user_token}"
    end

    def delete_message(channel_id, message_id)
      "#{@channels_url}/#{channel_id}/messages/#{message_id}?access_token=#{Settings.user_token}"
    end

    def follow(username)
      "#{@users_url}#{username}/follow?access_token=#{Settings.user_token}"
    end

    def mute(username)
      "#{@users_url}#{username}/mute?access_token=#{Settings.user_token}"
    end

    def block(username)
      "#{@users_url}#{username}/block?access_token=#{Settings.user_token}"
    end

    def repost(post_id)
      "#{@posts_url}#{post_id}/repost?access_token=#{Settings.user_token}"
    end

    def star(post_id)
      "#{@posts_url}#{post_id}/star?access_token=#{Settings.user_token}"
    end

    def channels(options)
      "#{@channels_url}?access_token=#{Settings.user_token}#{API.build_query(options)}"
    end

    def channel(channel_id, options = {})
      "#{@channels_url}?ids=#{channel_id.join(',')}&access_token=#{Settings.user_token}#{API.build_query(options)}&include_marker=1"
    end

    def messages(channel_id, options = {})
      "#{@channels_url}#{channel_id}/messages?access_token=#{Settings.user_token}#{API.build_query(options)}&include_machine=1&include_marker=1"
    end

    def avatar
      "#{@users_url}me/avatar"
    end

    def cover
      "#{@users_url}me/cover"
    end

    def update_marker
      "#{@posts_url}marker?access_token=#{Settings.user_token}"
    end

  end
end
