# encoding: utf-8
module Ayadn

  class Stream

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
      @check = Check.new
      @status = Status.new
    end

    def global settings
      Settings.options[:force] = true if settings[:force]
      options = settings.dup
      options[:filter] = nicerank_true()
      @view.downloading(options)
      unless options[:scroll]
        stream = @api.get_global(options)
        Settings.options[:force] == true ? niceranks = {} : niceranks = NiceRank.new.get_ranks(stream)
        @check.no_new_posts(stream, options, 'global')
        Databases.save_max_id(stream, 'global') unless stream['meta']['max_id'].nil?
        @view.render(stream, options, niceranks)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).global(options)
      end
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
    end


    def method_missing(meth, options)
      case meth
      when :checkins, :trending, :photos
        stream(meth, options, "explore:#{meth}")
      when :conversations
        stream(meth, options, "explore:replies")
      when :unified
        stream(meth, options, meth.to_s)
      else
        super
      end
    end

    def stream meth, options, target
      Settings.options[:force] = true if options[:force]
      @view.downloading(options)
      unless options[:scroll]
        stream = @api.send("get_#{meth}".to_sym, options)
        @check.no_new_posts(stream, options, target)
        Databases.save_max_id(stream)
        @view.render(stream, options)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).send(meth, options)
      end
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
    end


    def mentions username, options
      Settings.options[:force] = true if options[:force]
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      unless options[:scroll]
        stream = @api.get_mentions(username, options)
        @check.no_user(stream, username)
        Databases.save_max_id(stream)
        @check.no_data(stream, 'mentions')
        options = options.dup
        options[:in_mentions] = true
        @view.render(stream, options)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).mentions(username, options)
      end
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
    end

    def posts username, options
      Settings.options[:force] = true if options[:force]
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_posts(username, options)
      @check.no_user(stream, username)
      Databases.save_max_id(stream) unless stream['meta']['marker'].nil?
      @check.no_data(stream, 'mentions')
      unless options[:raw] || Settings.options[:force]
        # this is just to show a message rather than an empty screen
        if Settings.options[:blacklist][:active] == true
          if Databases.is_in_blacklist?('mention', username)
            @status.no_force("#{username.downcase}")
            exit
          end
        end
      end
      if stream['data'][0]['user']['you_muted'] || stream['data'][0]['user']['you_blocked']
        unless options[:raw] || Settings.options[:force]
          @status.no_force("#{username.downcase}")
          exit
        end
      end
      @view.render(stream, options)
      Scroll.new(@api, @view).posts(username, options) if options[:scroll]
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
    end

    def whatstarred(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_whatstarred(username, options)
      @check.no_user(stream, username)
      @check.no_data(stream, 'whatstarred')
      options[:extract] ? @view.all_stars_links(stream) : @view.render(stream, options)
    end

    def followings(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      show_raw_list(username, :followings, options)
      list = @api.get_followings(username)
      @check.auto_save_followings(list)
      Errors.no_data('followings') if list.empty?
      @view.list(:followings, list, username)
      Databases.add_to_users_db_from_list(list)
    end

    def followers(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      show_raw_list(username, :followers, options)
      list = @api.get_followers(username)
      @check.auto_save_followers(list)
      Errors.no_data('followers') if list.empty?
      @view.list(:followers, list, username)
      Databases.add_to_users_db_from_list(list)
    end

    def muted(options)
      @view.downloading(options)
      show_raw_list(nil, :muted, options)
      list = @api.get_muted
      @check.auto_save_muted(list)
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
      @check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      @check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      list = @api.get_whoreposted(id)
      @view.if_raw(list, options)
      if list['data'].empty?
        @status.nobody_reposted
        exit
      end
      @view.list(:whoreposted, list['data'], post_id)
    end

    def whostarred(post_id, options)
      @check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      @check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      list = @api.get_whostarred(id)
      @view.if_raw(list, options)
      if list['data'].empty?
        @status.nobody_starred
        exit
      end
      @view.list(:whostarred, list['data'], id)
    end

    def convo(post_id, options)
      Settings.options[:force] = true if options[:force]
      @check.bad_post_id(post_id)
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      @check.no_post(details, post_id)
      id = @workers.get_original_id(post_id, details)
      stream = @api.get_convo(id, options)
      @check.no_post(stream, id)
      Databases.pagination_insert("replies:#{id}", stream['meta']['max_id'])
      options = options.dup
      options[:reply_to] = details['data']['reply_to'].to_i unless details['data']['reply_to'].nil?
      options[:post_id] = post_id.to_i
      @view.render(stream, options)
      Scroll.new(@api, @view).convo(id, options) if options[:scroll]
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
    end

    def messages(channel_id, options)
      if options[:silent]
        Settings.options[:marker][:update_messages] = false
      end
      channel_id = @workers.get_channel_id_from_alias(channel_id)
      @view.downloading(options)
      resp = @api.get_messages(channel_id, options)
      name = "channel:#{channel_id}"
      @check.no_new_posts(resp, options, name)
      if Settings.options[:marker][:update_messages] == true
        unless resp['meta']['max_id'].nil?
          marked = @api.update_marker(name, resp['meta']['max_id'])
          updated = JSON.parse(marked)
          if updated['meta']['code'] != 200
            raise "couldn't update channel #{channel_id} as read"
          end
        end
      end
      Databases.save_max_id(resp)
      @view.if_raw(resp, options)
      @check.no_data(resp, 'messages') unless options[:scroll]
      @view.render(resp, options)
      Scroll.new(@api, @view).messages(channel_id, options) if options[:scroll]
      puts "\n" if Settings.options[:timeline][:compact] && options[:raw].nil?
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
          @status.canceled
          exit
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
