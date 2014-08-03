# encoding: utf-8
module Ayadn

  class Stream

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
    end

    def unified options
      @view.downloading(options)
      stream = @api.get_unified(options)
      Check.no_new_posts(stream, options, 'unified')
      Databases.save_max_id(stream)
      @view.render(stream, options)
      Scroll.new(@api, @view).unified(options) if options[:scroll]
    end

    def checkins options
      @view.downloading(options)
      stream = @api.get_checkins(options)
      Check.no_new_posts(stream, options, 'explore:checkins')
      Databases.save_max_id(stream)
      @view.render(stream, options)
      Scroll.new(@api, @view).checkins(options) if options[:scroll]
    end

    def global settings
      options = settings.dup
      options[:filter] = nicerank_true()
      @view.downloading(options)
      stream = @api.get_global(options)
      niceranks = NiceRank.new.get_ranks(stream)
      Check.no_new_posts(stream, options, 'global')
      Databases.save_max_id(stream)
      @view.render(stream, options, niceranks)
      Scroll.new(@api, @view).global(options) if options[:scroll]
    end

    def trending options
      @view.downloading(options)
      stream = @api.get_trending(options)
      Check.no_new_posts(stream, options, 'explore:trending')
      Databases.save_max_id(stream)
      @view.render(stream, options)
      Scroll.new(@api, @view).trending(options) if options[:scroll]
    end

    def photos options
      @view.downloading(options)
      stream = @api.get_photos(options)
      Check.no_new_posts(stream, options, 'explore:photos')
      Databases.save_max_id(stream)
      @view.render(stream, options)
      Scroll.new(@api, @view).photos(options) if options[:scroll]
    end

    def conversations options
      @view.downloading(options)
      stream = @api.get_conversations(options)
      Check.no_new_posts(stream, options, 'explore:replies')
      Databases.save_max_id(stream)
      @view.render(stream, options)
      Scroll.new(@api, @view).replies(options) if options[:scroll]
    end

    def mentions username, options
      Check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_mentions(username, options)
      Check.no_user(stream, username)
      Databases.save_max_id(stream)
      Check.no_data(stream, 'mentions')
      options = options.dup
      options[:in_mentions] = true
      @view.render(stream, options)
      Scroll.new(@api, @view).mentions(username, options) if options[:scroll]
    end

    def posts username, options
      Check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_posts(username, options)
      Check.no_user(stream, username)
      Databases.save_max_id(stream)
      Check.no_data(stream, 'mentions')
      @view.render(stream, options)
      Scroll.new(@api, @view).posts(username, options) if options[:scroll]
    end

    def whatstarred(username, options)
      Check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_whatstarred(username, options)
      Check.no_user(stream, username)
      Check.no_data(stream, 'whatstarred')
      options[:extract] ? @view.all_stars_links(stream) : @view.render(stream, options)
    end

    def followings(username, options)
      Check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      show_raw_list(username, :followings, options)
      list = @api.get_followings(username)
      Check.auto_save_followings(list)
      Errors.no_data('followings') if list.empty?
      @view.list(:followings, list, username)
      Databases.add_to_users_db_from_list(list)
    end

    def followers(username, options)
      Check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      show_raw_list(username, :followers, options)
      list = @api.get_followers(username)
      Check.auto_save_followers(list)
      Errors.no_data('followers') if list.empty?
      @view.list(:followers, list, username)
      Databases.add_to_users_db_from_list(list)
    end

    def muted(options)
      @view.downloading(options)
      show_raw_list(nil, :muted, options)
      list = @api.get_muted
      Check.auto_save_muted(list)
      Errors.no_data('muted') if list.empty?
      @view.list(:muted, list, nil)
      Databases.add_to_users_db_from_list(list)
    end

    def blocked(options)
      @view.downloading(options)
      show_raw_list(nil, :blocked, options)
      list = @api.get_blocked
      Errors.no_data('blocked') if list.empty?
      @view.list(:blocked, list, nil)
      Databases.add_to_users_db_from_list(list)
    end

    def interactions(options)
      @view.downloading(options)
      stream = @api.get_interactions
      @view.if_raw(stream, options)
      @view.clear_screen
      @view.show_interactions(stream['data'])
    end

    def whoreposted(post_id, options)
      Check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      Check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      list = @api.get_whoreposted(id)
      @view.if_raw(list, options)
      abort(Status.nobody_reposted) if list['data'].empty?
      @view.list(:whoreposted, list['data'], post_id)
    end

    def whostarred(post_id, options)
      Check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      Check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      list = @api.get_whostarred(id)
      @view.if_raw(list, options)
      abort(Status.nobody_starred) if list['data'].empty?
      @view.list(:whostarred, list['data'], id)
    end

    def convo(post_id, options)
      Check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      Check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      stream = @api.get_convo(id, options)
      Check.no_post(stream, id)
      Databases.pagination["replies:#{id}"] = stream['meta']['max_id']
      options = options.dup
      options[:reply_to] = details['data']['reply_to'].to_i unless details['data']['reply_to'].nil?
      options[:post_id] = post_id.to_i
      @view.render(stream, options)
      Scroll.new(@api, @view).convo(id, options) if options[:scroll]
    end

    def messages(channel_id, options)
      channel_id = @workers.get_channel_id_from_alias(channel_id)
      @view.downloading(options)
      resp = @api.get_messages(channel_id, options)
      Check.no_new_posts(resp, options, "channel:#{channel_id}")
      Databases.save_max_id(resp)
      @view.if_raw(resp, options)
      Check.no_data(resp, 'messages')
      @view.render(resp, options)
      Scroll.new(@api, @view).messages(channel_id, options) if options[:scroll]
    end

    def random_posts(options)
      #_, cols = @view.winsize
      #max_posts = cols / 16
      max_posts = 6
      @view.clear_screen
      puts "Fetching random posts, please wait...".color(:cyan)
      @max_id = @api.get_global({count: 1})['meta']['max_id'].to_i
      @view.clear_screen
      counter = 1
      wait = options[:wait] || 5
      loop do
        begin
          @random_post_id = rand(@max_id)
          @resp = @api.get_details(@random_post_id, {})
          next if @resp['data']['is_deleted']
          @view.show_simple_post([@resp['data']], {})
          counter += 1
          if counter == max_posts
            wait.downto(1) do |i|
              print "\r#{sprintf("%02d", i)} sec... QUIT WITH [CTRL+C]".color(:cyan)
              sleep 1
            end
            @view.clear_screen
            counter = 1
          end
        rescue Interrupt
          abort(Status.canceled)
        end
      end
    end

    private

    def show_raw_list username, what, options
      if options[:raw]
        @view.show_raw(@api.get_raw_list(username, what), options)
        exit
      end
    end

    def nicerank_true
      return true if Settings.options[:nicerank][:filter] == true
    end

  end

end
