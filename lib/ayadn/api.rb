# encoding: utf-8
module Ayadn
  class API

    def get_unified(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['unified']}
      end
      get_parsed_response(Endpoints.new.unified(options))
    end

    def get_checkins(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['explore:checkins']}
      end
      get_parsed_response(Endpoints.new.checkins(options))
    end

    def get_global(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['global']}
      end
      get_parsed_response(Endpoints.new.global(options))
    end

    def get_trending(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['explore:trending']}
      end
      get_explore(:trending, options)
    end
    def get_photos(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['explore:photos']}
      end
      get_explore(:photos, options)
    end
    def get_conversations(options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination['explore:replies']}
      end
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

    def get_convo(post_id, options)
      get_parsed_response(Endpoints.new.convo(post_id, options))
    end

    def get_hashtag(hashtag)
      get_parsed_response(Endpoints.new.hashtag(hashtag))
    end

    def get_search(words, options)
      get_parsed_response(Endpoints.new.search(words, options))
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
        url = get_list_url(username, target, options)
        resp = get_parsed_response(url)
        big << resp
        break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
        options = {:count => 200, :before_id => resp['meta']['min_id']}
      end
      big
    end

    def get_user(username)
      get_parsed_response(Endpoints.new.user(username))
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

    ###DEBUG
    #def get_niceranks stream
    def get_niceranks stream, iter
      ###DEBUG
      @iter = iter

      user_ids, table, niceranks = [], {}, {}
      stream['data'].each do |post|
        user_ids << post['user']['id'].to_i
        table[post['user']['id'].to_i] = post['user']['username']
      end
      user_ids.uniq!

      db_ranks = Databases.get_niceranks user_ids
      get_these = []
      db_ranks.each do |id,ranks|
        if ranks.nil?
          get_these << id
        elsif (Time.now - ranks[:cached]) > 86400 # 24 hours cache
          get_these << id
        else
          niceranks[id] = {
          username: ranks[:username],
          rank: ranks[:rank],
          is_human: ranks[:is_human],
          cached: ranks[:cached]
          }
        end
      end

      if Settings.options[:timeline][:show_debug] == true
        puts "=====\nNiceRanks\n".color(Settings.options[:colors][:debug])
        puts "From DB:\t#{niceranks}\n".color(Settings.options[:colors][:debug])
        puts "To get:\t\t#{get_these}\n=====\n".color(Settings.options[:colors][:debug])
      end

      unless get_these.empty?
        req = "http://api.search-adn.net/user/nicerank?ids=#{get_these.join(',')}"
        resp = JSON.parse(CNX.get req)

        #Error handling
        if resp['meta']['code'] != 200
          if Settings.options[:timeline][:show_debug] == true
            puts "=====\nNiceRank:\tError #{resp['meta']['code']} (#{resp['meta']['time']})\n=====\n".color(Settings.options[:colors][:debug])
          end
          Errors.nr "REQUESTED: #{get_these.join(' ')}"
          Errors.nr "RESPONSE: #{resp}"

          ###DEBUG
          @iter += 1

          if niceranks
            if Settings.options[:timeline][:show_debug] == true
              puts "=====\nNiceRanks:\t#{niceranks}".color(Settings.options[:colors][:debug])
              puts "=====\n".color(Settings.options[:colors][:debug])
            end

            #return niceranks

            ###DEBUG
            return niceranks, @iter
          else

            # return {}

            ###DEBUG
            return {}, @iter
          end
        end

        ###DEBUG
        @iter += 1

        resp['data'].each do |obj|
          niceranks[obj['user_id']] = {
            username: table[obj['user_id']],
            rank: obj['rank'],
            is_human: obj['is_human'],
            cached: Time.now
          }
        end
        if Settings.options[:timeline][:show_debug] == true
          puts "=====\nNiceRanks:\t#{niceranks}".color(Settings.options[:colors][:debug])
          puts "Resp:\t\t#{resp}".color(Settings.options[:colors][:debug])
          puts "=====\n".color(Settings.options[:colors][:debug])
        end
      end
      Databases.add_niceranks niceranks

      ###DEBUG
      #niceranks
      return niceranks, @iter
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

    def get_messages(channel_id, options)
      if options[:new] || options[:scroll]
        options = {since_id: Databases.pagination["channel:#{channel_id}"]}
      end
      get_parsed_response(Endpoints.new.messages(channel_id, options))
    end

    def get_config
      get_parsed_response(Endpoints.new.config_api_url)
    end

    def check_response_meta_code(res)
      if res['meta']['code'] == 200
        res
      else
        Errors.global_error("api/check_response_meta_code", nil, res['meta'])
      end
    end

    def self.build_query(arg)
      count = Settings.options[:counts][:default]
      if arg[:count]
        if arg[:count].to_s.is_integer?
          count = arg[:count]
        end
      end
      directed = Settings.options[:timeline][:directed]
      if arg[:directed]
        if arg[:directed] == 0 || arg[:directed] == 1
          directed = arg[:directed]
        end
      end
      deleted = Settings.options[:timeline][:deleted]
      if arg[:deleted]
        if arg[:deleted] == 0 || arg[:deleted] == 1
          deleted = arg[:deleted]
        end
      end
      html = Settings.options[:timeline][:html]
      if arg[:html]
        if arg[:html] == 0 || arg[:html] == 1
          html = arg[:html]
        end
      end
      annotations = Settings.options[:timeline][:annotations]
      if arg[:annotations]
        if arg[:annotations] == 0 || arg[:annotations] == 1
          annotations = arg[:annotations]
        end
      end
      if arg[:since_id]
        "&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}&since_id=#{arg[:since_id]}"
      elsif arg[:recent_message]
        "&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}&include_recent_message=#{arg[:recent_message]}"
      else
        "&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}"
      end
    end

    private

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
        url = get_list_url(username, target, options)
        resp = get_parsed_response(url)
        big_hash.merge!(Workers.extract_users(resp))
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
