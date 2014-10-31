# encoding: utf-8
module Ayadn
  class API

    def initialize
      @workers = Workers.new
    end

    def get_unified(options)
      options = paginate options, 'unified'
      get_parsed_response(Endpoints.new.unified(options))
    end

    def get_checkins(options)
      options = paginate options, 'explore:checkins'
      get_parsed_response(Endpoints.new.checkins(options))
    end

    def get_global(options)
      options = paginate options, 'global'
      get_parsed_response(Endpoints.new.global(options))
    end

    def get_trending(options)
      options = paginate options, 'explore:trending'
      get_explore(:trending, options)
    end
    def get_photos(options)
      options = paginate options, 'explore:photos'
      get_explore(:photos, options)
    end
    def get_conversations(options)
      options = paginate options, 'explore:replies'
      get_explore(:conversations, options)
    end

    def get_explore(explore, options)
      url = Endpoints.new.trending(options) if explore == :trending
      url = Endpoints.new.photos(options) if explore == :photos
      url = Endpoints.new.conversations(options) if explore == :conversations
      get_parsed_response(url)
    end

    def get_mentions(username, options)
      get_parsed_response(Endpoints.new.mentions(username, options))
    end

    def get_posts(username, options)
      get_parsed_response(Endpoints.new.posts(username, options))
    end

    def get_whatstarred(username, options)
      get_parsed_response(Endpoints.new.whatstarred(username, options))
    end

    def get_interactions
      get_parsed_response(Endpoints.new.interactions)
    end

    def get_token_info
      get_parsed_response(Endpoints.new.token_info)
    end

    def get_whoreposted(post_id)
      get_parsed_response(Endpoints.new.whoreposted(post_id))
    end

    def get_whostarred(post_id)
      get_parsed_response(Endpoints.new.whostarred(post_id))
    end

    def get_convo(post_id, options = {})
      get_parsed_response(Endpoints.new.convo(post_id, options))
    end

    def get_hashtag(hashtag)
      get_parsed_response(Endpoints.new.hashtag(hashtag))
    end

    def get_search(words, options)
      get_parsed_response(Endpoints.new.search(words, options))
    end

    def search_users words, options
      get_parsed_response(Endpoints.new.search_users(words, options))
    end

    def search_annotations words, options
      get_parsed_response(Endpoints.new.search_annotations(words, options))
    end

    def search_channels words, options
      get_parsed_response(Endpoints.new.search_channels(words, options))
    end

    def search_messages channel_id, words, options
      get_parsed_response(Endpoints.new.search_messages(channel_id, words, options))
    end

    def get_followings(username)
      build_list(username, :followings)
    end

    def get_followers(username)
      build_list(username, :followers)
    end

    def get_muted
      build_list(nil, :muted)
    end

    def get_blocked
      build_list(nil, :blocked)
    end

    def get_raw_list(username, target)
      options = {:count => 200, :before_id => nil}
      big = []
      loop do
        resp = get_parsed_response(get_list_url(username, target, options))
        big << resp
        break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
        options = {:count => 200, :before_id => resp['meta']['min_id']}
      end
      big
    end

    def get_user(username)
      get_parsed_response(Endpoints.new.user(username))
    end

    def get_users(usernames)
      get_parsed_response(Endpoints.new.users(usernames))
    end

    def get_details(post_id, options = {})
      get_parsed_response(Endpoints.new.single_post(post_id, options))
    end

    def get_files_list(options)
      array_of_hashes = []
      unless options[:all]
        resp = get_parsed_response(Endpoints.new.files_list(options))
        resp['data'].each { |p| array_of_hashes << p }
      else
        options = {:count => 200, :before_id => nil}
        loop do
          resp = get_parsed_response(Endpoints.new.files_list(options))
          resp['data'].each { |p| array_of_hashes << p }
          break unless resp['meta']['more']
          options = {:count => 200, :before_id => resp['meta']['min_id']}
        end
      end
      array_of_hashes
    end

    def get_file(file_id)
      get_parsed_response(Endpoints.new.file(file_id))
    end

    def star(post_id)
      JSON.parse(CNX.post(Endpoints.new.star(post_id)))
    end

    def follow(username)
      JSON.parse(CNX.post(Endpoints.new.follow(username)))
    end

    def mute(username)
      JSON.parse(CNX.post(Endpoints.new.mute(username)))
    end

    def block(username)
      JSON.parse(CNX.post(Endpoints.new.block(username)))
    end

    def repost(post_id)
      JSON.parse(CNX.post(Endpoints.new.repost(post_id)))
    end

    def delete_post(post_id)
      JSON.parse(CNX.delete(Endpoints.new.delete_post(post_id)))
    end

    def delete_message(channel_id, message_id)
      JSON.parse(CNX.delete(Endpoints.new.delete_message(channel_id, message_id)))
    end

    def unstar(post_id)
      JSON.parse(CNX.delete(Endpoints.new.star(post_id)))
    end

    def unfollow(username)
      JSON.parse(CNX.delete(Endpoints.new.follow(username)))
    end

    def unmute(username)
      JSON.parse(CNX.delete(Endpoints.new.mute(username)))
    end

    def unblock(username)
      JSON.parse(CNX.delete(Endpoints.new.block(username)))
    end

    def unrepost(post_id)
      resp = JSON.parse(CNX.delete(Endpoints.new.repost(post_id)))
      if resp['data']['repost_of']
        JSON.parse(CNX.delete(Endpoints.new.repost(resp['data']['repost_of']['id'])))
      else
        resp
      end
    end

    def get_channels
      options = {:count => 200, :recent_message => 1, :annotations => 1, :before_id => nil}
      get_parsed_response(Endpoints.new.channels(options))
      # big = []
      # loop do
      #   resp = get_parsed_response(Endpoints.new.channels(options))
      #   #check_response_meta_code(resp)
      #   big << resp
      #   break if resp['meta']['more'] == false
      #   options = {:count => 200, :before_id => resp['meta']['min_id']}
      # end
      # big
    end

    def get_channel channel_id, options = {}
      options = {:recent_message => 1, :annotations => 1, :before_id => nil}
      get_parsed_response(Endpoints.new.channel(channel_id, options))
    end

    def get_messages(channel_id, options)
      options = paginate options, "channel:#{channel_id}"
      get_parsed_response(Endpoints.new.messages(channel_id, options))
    end

    def get_config
      get_parsed_response(Endpoints.new.config_api_url)
    end

    def check_response_meta_code(res)
      if res['meta']['code'] == 200
        res
      else
        Errors.global_error({error: nil, caller: caller, data: [res['meta']]})
      end
    end

    def update_marker(name, last_read_id)
      obj = {
        'name' => name,
        'id' => last_read_id
      }
      url = Endpoints.new.update_marker
      CNX.post(url, obj)
    end

    def self.build_query(arg)
      if arg[:count].to_s.is_integer?
        count = arg[:count]
      else
        count = Settings.options[:counts][:default]
      end
      directed = arg[:directed] || Settings.options[:timeline][:directed]
      if directed == true || directed == 1
        directed = 1
      else
        directed = 0
      end
      html = arg[:html] || Settings.options[:timeline][:html]
      if html == true || html == 1
        html = 1
      else
        html = 0
      end
      if arg[:since_id]
        "&count=#{count}&include_html=#{html}&include_directed_posts=#{directed}&include_deleted=0&include_annotations=1&since_id=#{arg[:since_id]}"
      elsif arg[:recent_message]
        "&count=#{count}&include_html=#{html}&include_directed_posts=#{directed}&include_deleted=0&include_annotations=1&include_recent_message=#{arg[:recent_message]}"
      else
        "&count=#{count}&include_html=#{html}&include_directed_posts=#{directed}&include_deleted=0&include_annotations=1"
      end
    end

    private

    def paginate options, target
      if options[:new] || options[:scroll]
        return {since_id: Databases.pagination[target]}
      end
      return options
    end

    def get_parsed_response(url)
      JSON.parse(CNX.get_response_from(url))
    end

    def get_original_if_repost(resp)
      if resp['repost_of']
        resp['repost_of']
      else
        resp
      end
    end

    def build_list(username, target)
      options = {:count => 200, :before_id => nil}
      big_hash = {}
      loop do
        resp = get_parsed_response(get_list_url(username, target, options))
        abort(Status.user_404(username)) if resp['meta']['code'] == 404
        users = @workers.extract_users(resp)
        big_hash.merge!(users)
        break if resp['meta']['min_id'] == nil
        options = {:count => 200, :before_id => resp['meta']['min_id']}
      end
      big_hash
    end

    def get_list_url(username, target, options)
      case target
      when :followings
        Endpoints.new.followings(username, options)
      when :followers
        Endpoints.new.followers(username, options)
      when :muted
        Endpoints.new.muted(options)
      when :blocked
        Endpoints.new.blocked(options)
      end
    end

  end
end
