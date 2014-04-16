# encoding: utf-8
module Ayadn
  class Action

    def initialize
      @api = API.new
      @view = View.new
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

    def unified(options)
      begin
        doing(options)
        stream = @api.get_unified(options)
        (no_new_posts unless Databases.has_new?(stream, 'unified')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).unified(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/unified", options, e)
      ensure
        Databases.close_all
      end
    end

    def checkins(options)
      begin
        doing(options)
        stream = @api.get_checkins(options)
        (no_new_posts unless Databases.has_new?(stream, 'explore:checkins')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).checkins(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/checkins", options, e)
      ensure
        Databases.close_all
      end
    end

    def global(options)
      begin
        doing(options)
        stream = @api.get_global(options)
        (no_new_posts unless Databases.has_new?(stream, 'global')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).global(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/global", options, e)
      ensure
        Databases.close_all
      end
    end

    def trending(options)
      begin
        doing(options)
        stream = @api.get_trending(options)
        (no_new_posts unless Databases.has_new?(stream, 'explore:trending')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).trending(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/trending", options, e)
      ensure
        Databases.close_all
      end
    end

    def photos(options)
      begin
        doing(options)
        stream = @api.get_photos(options)
        (no_new_posts unless Databases.has_new?(stream, 'explore:photos')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).photos(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/photos", options, e)
      ensure
        Databases.close_all
      end
    end

    def conversations(options)
      begin
        doing(options)
        stream = @api.get_conversations(options)
        (no_new_posts unless Databases.has_new?(stream, 'explore:replies')) if options[:new]
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).conversations(options) if options[:scroll]
      rescue => e
        Errors.global_error("action/conversations", options, e)
      ensure
        Databases.close_all
      end
    end

    def mentions(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        stream = @api.get_mentions(username, options)
        user_404(username) if meta_404(stream)
        Databases.save_max_id(stream)
        options = options.dup
        options[:in_mentions] = true
        no_data('mentions') if stream['data'].empty?
        render_view(stream, options)
        Scroll.new(@api, @view).mentions(username, options) if options[:scroll]
      rescue => e
        Errors.global_error("action/mentions", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def posts(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        stream = @api.get_posts(username, options)
        user_404(username) if meta_404(stream)
        Databases.save_max_id(stream)
        no_data('posts') if stream['data'].empty?
        render_view(stream, options)
        Scroll.new(@api, @view).posts(username, options) if options[:scroll]
      rescue => e
        Errors.global_error("action/posts", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def interactions(options)
      begin
        doing(options)
        stream = @api.get_interactions
        unless options[:raw]
          @view.clear_screen
          @view.show_interactions(stream['data'])
        else
          @view.show_raw(stream)
        end
      rescue => e
        Errors.global_error("action/interactions", options, e)
      ensure
        Databases.close_all
      end
    end

    def whatstarred(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        stream = @api.get_whatstarred(username, options)
        user_404(username) if meta_404(stream)
        stream['data'].empty? ? no_data('whatstarred') : render_view(stream, options)
      rescue => e
        Errors.global_error("action/whatstarred", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def whoreposted(post_id, options)
      begin
        missing_post_id unless post_id.is_integer?
        doing(options)
        id = get_original_id(post_id, @api.get_details(post_id, options))
        list = @api.get_whoreposted(id)
        unless options[:raw]
          unless list['data'].empty?
            get_list(:whoreposted, list['data'], post_id)
          else
            puts Status.nobody_reposted
          end
        else
          @view.show_raw(list)
        end
      rescue => e
        Errors.global_error("action/whoreposted", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def whostarred(post_id, options)
      begin
        missing_post_id unless post_id.is_integer?
        doing(options)
        id = get_original_id(post_id, @api.get_details(post_id, options))
        list = @api.get_whostarred(id)
        unless options[:raw]
          unless list['data'].empty?
            get_list(:whostarred, list['data'], id)
          else
            puts Status.nobody_starred
          end
        else
          @view.show_raw(list)
        end
      rescue => e
        Errors.global_error("action/whostarred", [post_id, id], e)
      ensure
        Databases.close_all
      end
    end

    def convo(post_id, options)
      begin
        missing_post_id unless post_id.is_integer?
        doing(options)
        id = get_original_id(post_id, @api.get_details(post_id, options))
        stream = @api.get_convo(id, options)
        post_404(id) if meta_404(stream)
        Databases.pagination["replies:#{id}"] = stream['meta']['max_id']
        render_view(stream, options)
        Scroll.new(@api, @view).convo(id, options) if options[:scroll]
      rescue => e
        Errors.global_error("action/convo", [post_id, id, options], e)
      ensure
        Databases.close_all
      end
    end

    def delete(post_id)
      begin
        missing_post_id unless post_id.is_integer?
        print Status.deleting_post(post_id)
        check_has_been_deleted(post_id, @api.delete_post(post_id))
      rescue => e
        Errors.global_error("action/delete", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def unfollow(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.unfollowing(username)
        check_has_been_unfollowed(username, @api.unfollow(username))
      rescue => e
        Errors.global_error("action/unfollow", username, e)
      ensure
        Databases.close_all
      end
    end

    def follow(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.following(username)
        check_has_been_followed(username, @api.follow(username))
      rescue => e
        Errors.global_error("action/follow", username, e)
      ensure
        Databases.close_all
      end
    end

    def unmute(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.unmuting(username)
        check_has_been_unmuted(username, @api.unmute(username))
      rescue => e
        Errors.global_error("action/unmute", username, e)
      ensure
        Databases.close_all
      end
    end

    def mute(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.muting(username)
        check_has_been_muted(username, @api.mute(username))
      rescue => e
        Errors.global_error("action/mute", username, e)
      ensure
        Databases.close_all
      end
    end

    def unblock(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.unblocking(username)
        check_has_been_unblocked(username, @api.unblock(username))
      rescue => e
        Errors.global_error("action/unblock", username, e)
      ensure
        Databases.close_all
      end
    end

    def block(username)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        puts Status.blocking(username)
        check_has_been_blocked(username, @api.block(username))
      rescue => e
        Errors.global_error("action/block", username, e)
      ensure
        Databases.close_all
      end
    end

    def repost(post_id)
      begin
        missing_post_id unless post_id.is_integer?
        puts Status.reposting(post_id)
        resp = @api.get_details(post_id)
        check_if_already_reposted(resp)
        id = get_original_id(post_id, resp)
        check_has_been_reposted(id, @api.repost(id))
      rescue => e
        Errors.global_error("action/repost", [post_id, id], e)
      ensure
        Databases.close_all
      end
    end

    def unrepost(post_id)
      begin
        missing_post_id unless post_id.is_integer?
        puts Status.unreposting(post_id)
        if @api.get_details(post_id)['data']['you_reposted']
          check_has_been_unreposted(post_id, @api.unrepost(post_id))
        else
          puts Status.not_your_repost
        end
      rescue => e
        Errors.global_error("action/unrepost", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def unstar(post_id)
      begin
        missing_post_id unless post_id.is_integer?
        puts Status.unstarring(post_id)
        if @api.get_details(post_id)['data']['you_starred']
          check_has_been_unstarred(post_id, @api.unstar(post_id))
        else
          puts Status.not_your_starred
        end
      rescue => e
        Errors.global_error("action/unstar", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def star(post_id)
      begin
        missing_post_id unless post_id.is_integer?
        puts Status.starring(post_id)
        check_if_already_starred(@api.get_details(post_id))
        check_has_been_starred(post_id, @api.star(post_id))
      rescue => e
        Errors.global_error("action/star", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def hashtag(hashtag, options)
      begin
        doing(options)
        stream = @api.get_hashtag(hashtag)
        no_data('hashtag') if stream['data'].empty?
        render_view(stream, options)
      rescue => e
        Errors.global_error("action/hashtag", [hashtag, options], e)
      ensure
        Databases.close_all
      end
    end

    def search(words, options)
      begin
        doing(options)
        stream = @api.get_search(words, options)
        no_data('search') if stream['data'].empty?
        render_view(stream, options)
      rescue => e
        Errors.global_error("action/search", [words, options], e)
      ensure
        Databases.close_all
      end
    end

    def followings(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        unless options[:raw]
          list = @api.get_followings(username)
          auto_save_followings(list)
          no_data('followings') if list.empty?
          get_list(:followings, list, username)
          Databases.add_to_users_db_from_list(list)
        else
          @view.show_raw(@api.get_raw_list(username, :followings))
        end
      rescue => e
        Errors.global_error("action/followings", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def followers(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        unless options[:raw]
          list = @api.get_followers(username)
          auto_save_followers(list)
          no_data('followers') if list.empty?
          get_list(:followers, list, username)
          Databases.add_to_users_db_from_list(list)
        else
          @view.show_raw(@api.get_raw_list(username, :followers))
        end
      rescue => e
        Errors.global_error("action/followers", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def muted(options)
      begin
        doing(options)
        unless options[:raw]
          list = @api.get_muted
          auto_save_muted(list)
          no_data('muted') if list.empty?
          get_list(:muted, list, nil)
          Databases.add_to_users_db_from_list(list)
        else
          @view.show_raw(@api.get_raw_list(nil, :muted))
        end
      rescue => e
        Errors.global_error("action/muted", options, e)
      ensure
        Databases.close_all
      end
    end

    def blocked(options)
      begin
        doing(options)
        unless options[:raw]
          list = @api.get_blocked
          no_data('blocked') if list.empty?
          get_list(:blocked, list, nil)
          Databases.add_to_users_db_from_list(list)
        else
          @view.show_raw(@api.get_raw_list(nil, :blocked))
        end
      rescue => e
        Errors.global_error("action/blocked", options, e)
      ensure
        Databases.close_all
      end
    end

    def view_settings
      begin
        @view.clear_screen
        @view.show_settings
      rescue => e
        Errors.global_error("action/settings", nil, e)
      ensure
        Databases.close_all
      end
    end

    def userinfo(username, options)
      begin
        missing_username if username.empty?
        username = Workers.add_arobase_if_missing(username)
        doing(options)
        unless options[:raw]
          stream = @api.get_user(username)
          user_404(username) if meta_404(stream)
          if same_username?(stream)
            token = @api.get_token_info
            get_infos(stream['data'], token['data'])
          else
            get_infos(stream['data'], nil)
          end
        else
          @view.show_raw(@api.get_user(username))
        end
      rescue => e
        Errors.global_error("action/userinfo", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def postinfo(post_id, options)
      begin
        missing_post_id unless post_id.is_integer?
        doing(options)
        unless options[:raw]
          @view.clear_screen
          response = @api.get_details(post_id, options)
          post_404(post_id) if meta_404(response)
          resp = response['data']
          response = @api.get_user("@#{resp['user']['username']}")
          user_404(username) if meta_404(response)
          if same_username?(response)
            token = @api.get_token_info
          end
          stream = response['data']
          puts "POST:\n".inverse
          @view.show_simple_post([resp], options)
          if resp['repost_of']
            puts "REPOST OF:\n".inverse
            Errors.repost(post_id, resp['repost_of']['id'])
            @view.show_simple_post([resp['repost_of']], options)
          end
          puts "AUTHOR:\n".inverse
          if response['data']['username'] == Settings.config[:identity][:username]
            @view.show_userinfos(stream, token['data'])
          else
            @view.show_userinfos(stream, nil)
          end
        else
          @view.show_raw(@api.get_details(post_id, options))
        end
      rescue => e
        Errors.global_error("action/postinfo", [post_id, options], e)
      ensure
        Databases.close_all
      end
    end

    def files(options)
      begin
        doing(options)
        unless options[:raw]
          list = @api.get_files_list(options)
          @view.clear_screen
          list.empty? ? no_data('files') : @view.show_files_list(list)
        else
          @view.show_raw(@api.get_files_list(options))
        end
      rescue => e
        Errors.global_error("action/files", options, e)
      ensure
        Databases.close_all
      end
    end

    def download(file_id)
      begin
        resp = @api.get_file(file_id)
        file = resp['data']
        FileOps.download_url(file['name'], file['url'])
        puts Status.downloaded(file['name'])
      rescue => e
        Errors.global_error("action/download", [file_id, file['url']], e)
      ensure
        Databases.close_all
      end
    end

    def channels
      begin
        doing
        resp = @api.get_channels
        @view.clear_screen
        @view.show_channels(resp)
      rescue => e
        Errors.global_error("action/channels", resp['meta'], e)
      ensure
        Databases.close_all
      end
    end

    def messages(channel_id, options)
      begin
        channel_id = get_channel_id_from_alias(channel_id)
        doing(options)
        resp = @api.get_messages(channel_id, options)
        (no_new_posts unless Databases.has_new?(resp, "channel:#{channel_id}")) if options[:new]
        Databases.save_max_id(resp)
        if options[:raw]
          @view.show_raw(resp)
          exit
        end
        no_data('messages') if resp['data'].empty?
        render_view(resp, options)
        Scroll.new(@api, @view).messages(channel_id, options) if options[:scroll]
      rescue => e
        Errors.global_error("action/messages", [channel_id, options], e)
      ensure
        Databases.close_all
      end
    end

    def pin(post_id, usertags)
      require 'pinboard'
      require 'base64'
      begin
        missing_post_id unless post_id.is_integer?
        doing
        resp = get_data_from_response(@api.get_details(post_id, {}))
        @view.clear_screen
        links = Workers.new.extract_links(resp)
        resp['text'].nil? ? text = "" : text = resp['text']
        usertags << "ADN"
        post_url = resp['canonical_url']
        handle = "@" + resp['user']['username']
        post_text = "From: #{handle} -- Text: #{text} -- Links: #{links.join(" ")}"
        pinner = Ayadn::PinBoard.new
        unless pinner.has_credentials_file?
          puts Status.no_pin_creds
          pinner.ask_credentials
          puts Status.pin_creds_saved
        end
        credentials = pinner.load_credentials
        maker = Struct.new(:username, :password, :url, :tags, :text, :description)
        bookmark = maker.new(credentials[0], credentials[1], post_url, usertags.join(","), post_text, links[0])
        puts Status.saving_pin
        pinner.pin(bookmark)
        puts Status.done
      rescue => e
        Errors.global_error("action/pin", [post_id, usertags], e)
      ensure
        Databases.close_all
      end
    end

    def post(args)
      begin
        @view.clear_screen
        puts Status.posting
        resp = Post.new.post(args)
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error("action/post", args, e)
      ensure
        Databases.close_all
      end
    end

    def auto(options)
      begin
        @view.clear_screen
        puts Status.auto
        poster = Post.new
        # platform = Settings.config[:platform]
        # case platform
        # when /mswin|mingw|cygwin/
          # poster.auto_classic
        # else
          require "readline"
          poster.auto_readline
        # end
      rescue => e
        #Errors.global_error("action/auto post", [options, platform], e)
        Errors.global_error("action/auto post", [options], e)
      ensure
        Databases.close_all
      end
    end

    def write
      begin
        writer = Post.new
        puts Status.post
        lines_array = writer.compose
        writer.check_post_length(lines_array)
        @view.clear_screen
        puts Status.posting
        resp = writer.send_post(lines_array.join("\n"))
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error("action/write", lines_array.join(" "), e)
      ensure
        Databases.close_all
      end
    end

    def pmess(username)
    	begin
        missing_username if username.empty?
    		messenger = Post.new
    		puts Status.message
    		lines_array = messenger.compose
    		messenger.check_message_length(lines_array)
    		@view.clear_screen
    		puts Status.posting
    		resp = messenger.send_pm(username, lines_array.join("\n"))
        FileOps.save_message(resp) if Settings.options[:backup][:auto_save_sent_messages]
    		@view.clear_screen
    		puts Status.yourmessage
    		@view.show_posted(resp)
    	rescue => e
        Errors.global_error("action/pmess", username, e)
  		ensure
  		  Databases.close_all
    	end
    end

    def send_to_channel(channel_id)
    	begin
        channel_id = get_channel_id_from_alias(channel_id)
  			messenger = Post.new
  			puts Status.post
  			lines_array = messenger.compose
  			messenger.check_message_length(lines_array)
  			@view.clear_screen
  			puts Status.posting
  			resp = messenger.send_message(channel_id, lines_array.join("\n"))
        FileOps.save_message(resp) if Settings.options[:backup][:auto_save_sent_messages]
  			@view.clear_screen
  			puts Status.yourpost
  			@view.show_posted(resp)
    	rescue => e
        Errors.global_error("action/send_to_channel", channel_id, e)
  		ensure
  		  Databases.close_all
    	end
    end

    def reply(post_id)
      begin
        post_id = get_real_post_id(post_id)
      	puts Status.replying_to(post_id)
      	replied_to = @api.get_details(post_id)
        post_404(post_id) if meta_404(replied_to)
        post_id = get_original_id(post_id, replied_to)
        if replied_to['data']['repost_of']
          if post_id == replied_to['data']['repost_of']['id']
            replied_to = @api.get_details(post_id)
            post_404(post_id) if meta_404(replied_to)
          end
        end
        poster = Post.new
        puts Status.reply
        lines_array = poster.compose
        poster.check_post_length(lines_array)
        @view.clear_screen
        reply = poster.reply(lines_array.join("\n"), Workers.new.build_posts([replied_to['data']]))
        puts Status.posting
        resp = poster.send_reply(reply, post_id)
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.done
        render_view(@api.get_convo(post_id, {}), {})
      rescue => e
        Errors.global_error("action/reply", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def nowplaying
      begin
        Databases.close_all
        abort(Status.error_only_osx) unless Settings.config[:platform] =~ /darwin/
        itunes = get_track_infos
        itunes.each do |el|
          abort(Status.empty_fields) if el.length == 0
        end
        @view.clear_screen
        text_to_post = "#nowplaying '#{itunes.track}' from '#{itunes.album}' by #{itunes.artist}"
        show_nowplaying(text_to_post)
        unless STDIN.getch == ("y" || "Y")
          puts "\nCanceled.\n\n".color(:red)
          exit
        end
        puts "\n"
        resp = Post.new.post([text_to_post])
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        puts Status.wtf
        Errors.global_error("action/nowplaying", itunes, e)
      # ensure
      #   Databases.close_all
      end
    end

    def random_posts(options)
      begin
        _, cols = winsize
        max_posts = cols / 12
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
              countdown(wait)
              @view.clear_screen
              counter = 1
            end
          rescue Interrupt
            abort(Status.canceled)
          end
        end
      rescue => e
        Errors.global_error("action/random_posts", [@max_id, @random_post_id, @resp], e)
      ensure
        Databases.close_all
      end
    end

    private

    def get_original_id(post_id, resp)
      if resp['data']['repost_of']
        puts Status.redirecting
        id = resp['data']['repost_of']['id']
        Errors.repost(post_id, id)
        return id
      else
        return post_id
      end
    end

    def check_if_already_starred(resp)
      if resp['data']['you_starred']
        puts "\nYou already starred this post.\n".color(:red)
        exit
      end
    end

    def check_if_already_reposted(resp)
      if resp['data']['you_reposted']
        puts "\nYou already reposted this post.\n".color(:red)
        exit
      end
    end

    def check_has_been_starred(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.starred(post_id)
        Logs.rec.info "Starred #{post_id}."
      else
        whine(Status.not_starred(post_id), resp)
      end
    end

    def check_has_been_reposted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.reposted(post_id)
        Logs.rec.info "Reposted #{post_id}."
      else
        whine(Status.not_reposted(post_id), resp)
      end
    end

    def check_has_been_blocked(username, resp)
      if resp['meta']['code'] == 200
        puts Status.blocked(username)
        Logs.rec.info "Blocked #{username}."
      else
        whine(Status.not_blocked(username), resp)
      end
    end

    def check_has_been_muted(username, resp)
      if resp['meta']['code'] == 200
        puts Status.muted(username)
        Logs.rec.info "Muted #{username}."
      else
        whine(Status.not_muted(username), resp)
      end
    end

    def check_has_been_followed(username, resp)
      if resp['meta']['code'] == 200
        puts Status.followed(username)
        Logs.rec.info "Followed #{username}."
      else
        whine(Status.not_followed(username), resp)
      end
    end

    def check_has_been_deleted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.deleted(post_id)
        Logs.rec.info "Deleted post #{post_id}."
      else
        whine(Status.not_deleted(post_id), resp)
      end
    end

    def check_has_been_unblocked(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unblocked(username)
        Logs.rec.info "Unblocked #{username}."
      else
        whine(Status.not_unblocked(username), resp)
      end
    end

    def check_has_been_unstarred(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.unstarred(post_id)
        Logs.rec.info "Unstarred #{post_id}."
      else
        whine(Status.not_unstarred(post_id), resp)
      end
    end

    def check_has_been_unreposted(post_id, resp)
      if resp['meta']['code'] == 200
        puts Status.unreposted(post_id)
        Logs.rec.info "Unreposted #{post_id}."
      else
        whine(Status.not_unreposted(post_id), resp)
      end
    end

    def check_has_been_unmuted(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unmuted(username)
        Logs.rec.info "Unmuted #{username}."
      else
        whine(Status.not_unmuted(username), resp)
      end
    end

    def check_has_been_unfollowed(username, resp)
      if resp['meta']['code'] == 200
        puts Status.unfollowed(username)
        Logs.rec.info "Unfollowed #{username}."
      else
        whine(Status.not_unfollowed(username), resp)
      end
    end

    def whine(status, resp)
      puts status
      Errors.error("#{status} => #{resp['meta']}")
    end

    def no_data(where)
      Errors.warn "In action/#{where}: no data"
      abort(Status.empty_list)
    end

    def meta_404(stream)
      stream['meta']['code'] == 404
    end

    def user_404(username)
      puts "\nUser #{username} doesn't exist. It could be a deleted account.\n".color(:red)
      Errors.info("User #{username} doesn't exist")
      exit
    end

    def post_404(post_id)
      puts "\nImpossible to find #{post_id}. This post may have been deleted.\n".color(:red)
      Errors.info("Impossible to find #{post_id}")
      exit
    end

    def length_of_index
      Databases.get_index_length
    end

    def get_post_from_index(id)
      Databases.get_post_from_index(id)
    end

    def get_real_post_id(post_id)
      id = post_id.to_i
      if id > 0 && id <= length_of_index
        resp = get_post_from_index(id)
        post_id = resp[:id]
      end
      post_id
    end

    def render_view(data, options = {})
      unless options[:raw]
        #@view.clear_screen
        get_view(data['data'], options)
      else
        @view.show_raw(data)
      end
    end

    def doing(options = {})
      unless options[:raw]
        @view.clear_screen
        print Status.downloading
      end
    end

    def get_data_from_response(response)
      response['data']
    end

    def get_view(stream, options = {})
      @view.clear_screen
      if options[:index]
        @view.show_posts_with_index(stream, options)
      else
        @view.show_posts(stream, options)
      end
    end

    def get_simple_view(stream)
      @view.clear_screen
      @view.show_simple_stream(stream)
    end

    def get_infos(stream, token)
      @view.clear_screen
      @view.show_userinfos(stream, token)
    end

    def get_list(what, list, target)
      @view.clear_screen
      case what
      when :whoreposted
        @view.show_list_reposted(list, target)
      when :whostarred
        @view.show_list_starred(list, target)
      when :followings
        @view.show_list_followings(list, target)
      when :followers
        @view.show_list_followers(list, target)
      when :muted
        @view.show_list_muted(list)
      when :blocked
        @view.show_list_blocked(list)
      end
    end

    def get_channel_id_from_alias(channel_id)
      unless channel_id.is_integer?
        orig = channel_id
        channel_id = Databases.get_channel_id(orig)
        if channel_id.nil?
          Errors.warn("Alias '#{orig}' doesn't exist.")
          puts "\nThis alias doesn't exist.\n\n".color(:red)
          exit
        end
      end
      channel_id
    end

    def winsize
      IO.console.winsize
    end

    def no_new_posts
      @view.clear_screen
      puts Status.no_new_posts
      exit
    end

    def missing_username
      puts Status.error_missing_username
      exit
    end

    def missing_post_id
      puts Status.error_missing_post_id
      exit
    end

    def auto_save_followings(list)
      FileOps.save_followings_list(list) if Settings.options[:backup][:auto_save_lists]
    end
    def auto_save_followers(list)
      FileOps.save_followers_list(list) if Settings.options[:backup][:auto_save_lists]
    end
    def auto_save_muted(list)
      FileOps.save_muted_list(list) if Settings.options[:backup][:auto_save_lists]
    end

    def same_username?(stream)
      stream['data']['username'] == Settings.config[:identity][:username]
    end

    def get_track_infos
      track = `osascript -e 'tell application "iTunes"' -e 'set trackName to name of current track' -e 'return trackName' -e 'end tell'`
      album = `osascript -e 'tell application "iTunes"' -e 'set trackAlbum to album of current track' -e 'return trackAlbum' -e 'end tell'`
      artist = `osascript -e 'tell application "iTunes"' -e 'set trackArtist to artist of current track' -e 'return trackArtist' -e 'end tell'`
      maker = Struct.new(:artist, :album, :track)
      maker.new(artist.chomp!, album.chomp!, track.chomp!)
    end

    def show_nowplaying(text)
      puts "\nThis is what will be posted:\n".color(:cyan)
      puts text + "\n\n"
      puts "Do you confirm? (y/N) ".color(:yellow)
    end

    def countdown(wait)
      wait.downto(1) do |i|
        print "\r#{sprintf("%02d", i)} sec... QUIT WITH [CTRL+C]".color(:cyan)
        sleep 1
      end
    end

  end
end
