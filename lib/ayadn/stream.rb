# encoding: utf-8
module Ayadn

  class Stream

    require_relative("scroll")

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
      @check = Check.new
      @status = Status.new
    end

    def global settings
      Settings.global.force = true if settings[:force]
      options = settings.dup
      options[:filter] = nicerank_true()
      @view.downloading(options)
      unless options[:scroll]
        stream_object = StreamObject.new(@api.get_global(options))
        Settings.global.force ? niceranks = {} : niceranks = NiceRank.new.get_ranks(stream_object)
        @check.no_new_posts(stream_object, options, 'global')
        Databases.save_max_id(stream_object, 'global') unless stream_object.meta.max_id.nil?
        @view.render(stream_object, options, niceranks)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).global(options)
      end
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
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
      Settings.global.force = true if options[:force]
      @view.downloading(options)
      unless options[:scroll]
        stream = @api.send("get_#{meth}".to_sym, options)
        stream_object = StreamObject.new(stream)
        @check.no_new_posts(stream_object, options, target)
        Databases.save_max_id(stream_object)
        @view.render(stream_object, options)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).send(meth, options)
      end
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
    end


    def mentions username, options
      Settings.global.force = true if options[:force]
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      unless options[:scroll]
        stream = @api.get_mentions(username, options)
        stream_object = StreamObject.new(stream)
        @check.no_user(stream_object, username)
        Databases.save_max_id(stream_object)
        @check.no_data(stream_object, 'mentions')
        options = options.dup
        options[:in_mentions] = true
        @view.render(stream_object, options)
      end
      if options[:scroll]
        @view.clear_screen()
        Scroll.new(@api, @view).mentions(username, options)
      end
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
    end

    def posts username, options
      Settings.global.force = true if options[:force]
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options)
      stream = @api.get_posts(username, options)
      stream_object = StreamObject.new(stream)
      @check.no_user(stream_object, username)
      Databases.save_max_id(stream_object) unless stream_object.meta.marker.nil?
      @check.no_data(stream_object, 'mentions')
      unless options[:raw] || Settings.global.force
        # this is just to show a message rather than an empty screen
        if Settings.options.blacklist.active
          if Databases.is_in_blacklist?('mention', username)
            @status.no_force("#{username.downcase}")
            exit
          end
        end
      end
      if stream_object.posts[0].user.you_muted || stream_object.posts[0].user.you_blocked
        unless options[:raw] || Settings.global.force
          @status.no_force("#{username.downcase}")
          exit
        end
      end
      @view.render(stream_object, options)
      Scroll.new(@api, @view).posts(username, options) if options[:scroll]
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
    end

    def whatstarred(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options) unless options["again"]
      if options["again"]
        stream = FileOps.cached_list("whatstarred")
        stream_object = StreamObject.new(stream)
        Errors.no_data('cached whatstarred') if stream.nil?
      else
        stream = @api.get_whatstarred(username, options)
        stream_object = StreamObject.new(stream)
      end

      @check.no_user(stream_object, username)
      @check.no_data(stream_object, 'whatstarred')

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(stream_object.input, "whatstarred")
      end

      if options[:extract]
        @view.all_stars_links(stream_object)
      else
        @view.render(stream_object, options)
      end
      puts "\n" if Settings.options.timeline.compact
    end

    def followings(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options) unless options["again"]
      show_raw_list(username, :followings, options)
      if options["again"]
        list = FileOps.cached_list("followings")
        Errors.no_data('cached followings') if list.nil?
      else
        list = @api.get_followings(username)
      end
      @check.auto_save_followings(list)
      Errors.no_data('followings') if list.empty?
      if options["lastpost"] && options["again"].nil?
        count = list.size
        @workers.status.thor.say_status :downloading, "please wait, it may take a while...", :red
        puts "\n"
        idx = 0
        list.each do |str_id, obj|
          idx += 1
          tmp_username = "@#{obj[0]}"
          colored_username = tmp_username.color(Settings.options.colors.username)
          iter = "#{idx}/#{count}"
          @workers.status.thor.say_status iter.to_sym, "last post from #{colored_username}", :cyan
          resp = @api.get_posts(tmp_username, {count: 1})
          obj << resp["data"][0]
        end
      end
      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "followings")
      end
      @view.list(:followings, list, username, options)
      Databases.add_to_users_db_from_list(list)
    end

    def followers(username, options)
      @check.no_username(username)
      username = @workers.add_arobase(username)
      @view.downloading(options) unless options["again"]
      show_raw_list(username, :followers, options)

      if options["again"]
        list = FileOps.cached_list("followers")
        Errors.no_data('cached followers') if list.nil?
      else
        list = @api.get_followers(username)
      end

      @check.auto_save_followers(list)

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "followers")
      end

      Errors.no_data('followers') if list.empty?
      @view.list(:followers, list, username, options)
      Databases.add_to_users_db_from_list(list)
    end

    def muted(options)
      @view.downloading(options) unless options["again"]
      show_raw_list(nil, :muted, options)

      if options["again"]
        list = FileOps.cached_list("muted")
        Errors.no_data('cached muted') if list.nil?
      else
        list = @api.get_muted
      end

      @check.auto_save_muted(list)

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "muted")
      end

      Errors.no_data('muted') if list.empty?
      @view.list(:muted, list, nil, options)
      Databases.add_to_users_db_from_list(list)
    end

    def blocked(options)
      @view.downloading(options) unless options["again"]
      show_raw_list(nil, :blocked, options)
      if options["again"]
        list = FileOps.cached_list("blocked")
        Errors.no_data('cached blocked') if list.nil?
      else
        list = @api.get_blocked
      end
      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "blocked")
      end
      Errors.no_data('blocked') if list.empty?
      @view.list(:blocked, list, nil, options)
      Databases.add_to_users_db_from_list(list)
    end

    def interactions(options)
      @view.downloading(options)
      stream = @api.get_interactions
      @view.if_raw(stream, options)
      @view.clear_screen
      @view.show_interactions(stream['data'])
      puts "\n" if Settings.options.timeline.compact
    end

    def whoreposted(post_id, options)
      @check.bad_post_id(post_id)
      unless options[:force]
        post_id = @workers.get_real_post_id(post_id)
      end
      @view.downloading(options) unless options["again"]

      if options["again"]
        details = FileOps.cached_list("whoreposted_details")
        Errors.no_data('cached whoreposted details') if details.nil?
      else
        details = @api.get_details(post_id, options)
      end
      
      @check.no_details(details, post_id)
      id = @workers.get_original_id(post_id, details)
      
      if options["cache"] && options["again"].nil?
        FileOps.cache_list(details, "whoreposted_details")
      end

      if options["again"]
        list = FileOps.cached_list("whoreposted")
        Errors.no_data('cached whoreposted') if list.nil?
      else
        list = @api.get_whoreposted(id)
      end

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "whoreposted")
      end
      
      @view.if_raw(list, options)
      if list['data'].empty?
        @status.nobody_reposted
        exit
      end
      @view.list(:whoreposted, list['data'], post_id)
    end

    def whostarred(post_id, options)
      @check.bad_post_id(post_id)
      unless options[:force]
        post_id = @workers.get_real_post_id(post_id)
      end
      @view.downloading(options) unless options["again"]

      if options["again"]
        details = FileOps.cached_list("whostarred_details")
        Errors.no_data('cached whostarred details') if details.nil?
      else
        details = @api.get_details(post_id, options)
      end

      @check.no_details(details, post_id)
      id = @workers.get_original_id(post_id, details)

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(details, "whostarred_details")
      end

      if options["again"]
        list = FileOps.cached_list("whostarred")
        Errors.no_data('cached whostarred') if list.nil?
      else
        list = @api.get_whostarred(id)
      end

      if options["cache"] && options["again"].nil?
        FileOps.cache_list(list, "whostarred")
      end

      @view.if_raw(list, options)
      if list['data'].empty?
        @status.nobody_starred
        exit
      end
      @view.list(:whostarred, list['data'], id)
    end

    def convo(post_id, options)
      @check.bad_post_id(post_id)
      if options[:force]
        Settings.global.force = true
      else
        post_id = @workers.get_real_post_id(post_id)
      end
      @view.downloading(options)
      details = @api.get_details(post_id, options)
      @check.no_details(details, post_id)
      id = @workers.get_original_id(post_id, details)
      stream = @api.get_convo(id, options)
      stream_object = StreamObject.new(stream)
      @check.no_post(stream_object, id)
      Databases.pagination_insert("replies:#{id}", stream_object.meta.max_id)
      options = options.dup
      options[:reply_to] = details['data']['reply_to'].to_i unless details['data']['reply_to'].nil?
      options[:post_id] = post_id.to_i
      @view.render(stream_object, options)
      Scroll.new(@api, @view).convo(id, options) if options[:scroll]
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
    end

    def messages(channel_id, options)
      if options[:silent]
        Settings.options.marker.messages = false
      end
      channel_id = @workers.get_channel_id_from_alias(channel_id)
      @view.downloading(options)
      resp = @api.get_messages(channel_id, options)
      stream_object = StreamObject.new(resp)
      name = "channel:#{channel_id}"
      @check.no_new_posts(stream_object, options, name)
      if Settings.options.marker.messages
        unless stream_object.meta.max_id.nil?
          marked = @api.update_marker(name, stream_object.meta.max_id)
          updated = JSON.parse(marked)
          if updated['meta']['code'] != 200
            raise "couldn't update channel #{channel_id} as read"
          end
        end
      end
      Databases.save_max_id(stream_object)
      @view.if_raw(stream_object, options)
      @check.no_data(stream_object, 'messages') unless options[:scroll]
      @view.render(stream_object, options)
      Scroll.new(@api, @view).messages(channel_id, options) if options[:scroll]
      puts "\n" if Settings.options.timeline.compact && options[:raw].nil?
    end

    def random_posts(options)
      Settings.global.force = true
      #_, cols = @view.winsize
      #max_posts = cols / 16
      max_posts = 6
      @view.clear_screen
      @status.info("connected", "fetching random posts", "cyan")
      @max_id = @api.get_global({count: 1})['meta']['max_id'].to_i
      @view.clear_screen
      counter = 1
      wait = options[:wait] || 10
      loop do
        begin
          @random_post_id = rand(@max_id)
          @resp = @api.get_details(@random_post_id, {})
          next if @resp.nil?
          next if @resp['data'].nil? || @resp['data'].empty?
          next if @resp['data']['is_deleted']
          @view.show_simple_post([PostObject.new(@resp['data'])], {})
          counter += 1
          if counter == max_posts
            wait.downto(1) do |i|
              print "\r#{sprintf("%02d", i)} sec... ([CTRL+C] to quit)".color(:cyan)
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

        if options["again"]
          list = FileOps.cached_list("#{username}_#{what}")
          Errors.no_data("#{username}_#{what}") if list.nil?
        else
          list = @api.get_raw_list(username, what)
        end

        if options["cache"] && options["again"].nil?
          FileOps.cache_list(list, "#{username}_#{what}")
        end
        
        @view.show_raw(list, options)
        exit
      end
    end

    def nicerank_true
      return true if Settings.options.nicerank.filter
    end

  end

end
