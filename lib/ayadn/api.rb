module Ayadn
  class API

    def get_unified(options)
      if options[:new]
        options = {since_id: Databases.pagination['unified']}
      end
      get_parsed_response(Endpoints.new.unified(options))
    end

    def get_checkins(options)
      if options[:new]
        options = {since_id: Databases.pagination['explore:checkins']}
      end
      get_parsed_response(Endpoints.new.checkins(options))
    end

    def get_global(options)
      if options[:new]
        options = {since_id: Databases.pagination['global']}
      end
      get_parsed_response(Endpoints.new.global(options))
    end

    def get_trending(options)
      if options[:new]
        options = {since_id: Databases.pagination['explore:trending']}
      end
      get_explore(:trending, options)
    end
    def get_photos(options)
      if options[:new]
        options = {since_id: Databases.pagination['explore:photos']}
      end
      get_explore(:photos, options)
    end
    def get_conversations(options)
      if options[:new]
        options = {since_id: Databases.pagination['explore:replies']}
      end
      get_explore(:conversations, options)
    end

    def get_explore(explore, options)
      url = Endpoints.new.trending(options) if explore == :trending
      url = Endpoints.new.photos(options) if explore == :photos
      url = Endpoints.new.conversations(options) if explore == :conversations
      resp = get_parsed_response(url)
      #check_error(resp)
      resp
    end

    def get_mentions(username, options)
      if options[:new]
        options = {since_id: Databases.pagination['mentions']}
      end
      get_parsed_response(Endpoints.new.mentions(username, options))
    end

    def get_posts(username, options)
      resp = get_parsed_response(Endpoints.new.posts(username, options))
      #check_error(resp)
      resp
    end

    def get_whatstarred(username, options)
      resp = get_parsed_response(Endpoints.new.whatstarred(username, options))
      #check_error(resp)
      resp
    end

    def get_interactions
      resp = get_parsed_response(Endpoints.new.interactions)
      #check_error(resp)
      resp
    end

    def get_whoreposted(post_id)
      get_parsed_response(Endpoints.new.whoreposted(post_id))
    end

    def get_original_if_repost(resp)
      if resp['repost_of']
        resp['repost_of']
      else
        resp
      end
    end

    def get_whostarred(post_id)
      get_parsed_response(Endpoints.new.whostarred(post_id))
    end

    def get_convo(post_id, options)
      resp = get_parsed_response(Endpoints.new.convo(post_id, options))
      #check_error(resp)
      resp
    end

    def get_hashtag(hashtag)
      resp = get_parsed_response(Endpoints.new.hashtag(hashtag))
      #check_error(resp)
      resp
    end

    def get_search(words, options)
      resp = get_parsed_response(Endpoints.new.search(words, options))
      #check_error(resp)
      resp
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

    def get_raw_list(username, target)
      options = {:count => 200, :before_id => nil}
      big = []
      loop do
        url = get_list_url(username, target, options)
        resp = get_parsed_response(url)
        big << resp
        break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
        options = {:count => 200, :before_id => resp['meta']['min_id']}
      end
      big
    end

    def build_list(username, target)
      options = {:count => 200, :before_id => nil}
      big_hash = {}
      loop do
        url = get_list_url(username, target, options)
        resp = get_parsed_response(url)
        users_hash = {}
        resp['data'].each do |item|
          users_hash[item['id']] = [item['username'], item['name'], item['you_follow'], item['follows_you']]
        end
        big_hash.merge!(users_hash)
        break if resp['meta']['min_id'] == nil
        options = {:count => 200, :before_id => resp['meta']['min_id']}
      end
      big_hash
    end

    def get_user(username)
      resp = get_parsed_response(Endpoints.new.user(username))
      #check_error(resp)
      resp
    end

    def get_details(post_id, options)
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

    def follow(post_id)
      JSON.parse(CNX.post(Endpoints.new.follow(post_id)))
    end

    def mute(post_id)
      JSON.parse(CNX.post(Endpoints.new.mute(post_id)))
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
      #check_error(resp)
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
      #   #check_error(resp)
      #   big << resp
      #   break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
      #   options = {:count => 200, :before_id => resp['meta']['min_id']}
      # end
      # big
    end

    def get_messages(channel_id, options)
      get_parsed_response(Endpoints.new.messages(channel_id, options))
    end

    def get_config
      get_parsed_response(Endpoints.new.config_api_url)
    end

    def self.check_http_error(resp)
      unless resp.code == 200
        raise "#{resp}"
      end
    end

    def check_error(res)
      if res['meta']['code'] == 200
        res
      else
        Errors.global_error("api/check_error", nil, res['meta'])
      end
    end

    def empty_data
      puts "\e[H\e[2J"
      #puts Status.empty_list
      raise Status.empty_list
    end

    def get_raw_response(url)
      CNX.get_response_from(url)
    end

    def get_parsed_response(url)
      JSON.parse(CNX.get_response_from(url))
    end



    def get_data_from_response(response)
      response['data']
    end

  end
end
