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
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'unified')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).unified(options)
        end
      rescue => e
        Errors.global_error("action/unified", options, e)
      ensure
        Databases.close_all
      end
    end

    def random_posts(options = {wait: 5})
      begin
        rows, cols = winsize
        max_posts = cols / 13
        @view.clear_screen
        puts "Fetching random posts, please wait... Quit with [CTRL+C]\n\n".color(:cyan)
        stream = @api.get_global({count: 1})
        max_id = stream['meta']['max_id'].to_i
        @view.clear_screen
        @counter = 1
        loop do
          begin
            random_post_id = rand(max_id + 1)
            @resp = get_data_from_response(@api.get_details(random_post_id, {}))
            next if @resp['is_deleted']
            @view.show_simple_post([@resp], {})
            @counter += 1
            if @counter == max_posts
              puts "\n(Quit with [CTRL+C])".color(:cyan)
              sleep options[:wait]
              @view.clear_screen
              @counter = 1
            end
          rescue Interrupt
            puts Status.canceled
            exit
          rescue => e
            raise e
          end
        end
      rescue => e
        Errors.global_error("action/random_posts", @resp, e)
      ensure
        Databases.close_all
      end
    end

    def checkins(options)
      begin
        doing(options)
        stream = @api.get_checkins(options)
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'explore:checkins')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).checkins(options)
        end
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
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'global')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).global(options)
        end
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
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'explore:trending')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).trending(options)
        end
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
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'explore:photos')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).photos(options)
        end
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
        if options[:new]
          no_new_posts unless Databases.has_new?(stream, 'explore:replies')
        end
        Databases.save_max_id(stream)
        render_view(stream, options)
        if options[:scroll]
          Scroll.new(@api, @view).conversations(options)
        end
      rescue => e
        Errors.global_error("action/conversations", options, e)
      ensure
        Databases.close_all
      end
    end

    def mentions(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          stream = @api.get_mentions(username, options)
          user_404(username) if meta_404(stream)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/mentions", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def posts(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          stream = @api.get_posts(username, options)
          user_404(username) if meta_404(stream)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
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
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          stream = @api.get_whatstarred(username, options)
          user_404(username) if meta_404(stream)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/whatstarred", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def whoreposted(post_id, options)
      begin
        if post_id.is_integer?
          doing(options)
          resp = @api.get_details(post_id, options)
          if resp['data']['repost_of']
            puts Status.redirecting
            list = @api.get_whoreposted(resp['data']['repost_of']['id'])
          else
            list = @api.get_whoreposted(post_id)
          end
          unless options[:raw]
            unless list['data'].empty?
              get_list(:whoreposted, list['data'], post_id)
            else
              puts "\nNobody reposted this post.\n\n".color(:red)
            end
          else
            @view.show_raw(list)
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/whoreposted", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def whostarred(post_id, options)
      begin
        if post_id.is_integer?
          doing(options)
          resp = @api.get_details(post_id, options)
          if resp['data']['repost_of']
            puts Status.redirecting
            list = @api.get_whostarred(resp['data']['repost_of']['id'])
          else
            list = @api.get_whostarred(post_id)
          end
          unless options[:raw]
            unless list['data'].empty?
              get_list(:whostarred, list['data'], post_id)
            else
              puts "\nNobody starred this post.\n\n".color(:red)
            end
          else
            @view.show_raw(list)
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/whostarred", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def convo(post_id, options)
      begin
        if post_id.is_integer?
          doing(options)
          resp = @api.get_details(post_id, options)
          if resp['data']['repost_of']
            puts Status.redirecting
            stream = @api.get_convo(resp['data']['repost_of']['id'], options)
          else
            stream = @api.get_convo(post_id, options)
          end
          post_404(post_id) if meta_404(stream)
          render_view(stream, options)
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/convo", [post_id, options], e)
      ensure
        Databases.close_all
      end
    end

    def delete(post_id)
      begin
        if post_id.is_integer?
          #@view.clear_screen
          print Status.deleting_post(post_id)
          resp = @api.delete_post(post_id)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.deleted(post_id)
            Logs.rec.info "Deleted post #{post_id}."
          else
            puts Status.not_deleted(post_id)
            Errors.warn("#{Status.not_deleted(post_id)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/delete", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def unfollow(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.unfollowing(username)
          resp = @api.unfollow(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unfollowed(username)
            Logs.rec.info "Unfollowed #{username}."
          else
            puts Status.not_unfollowed(username)
            Errors.warn("#{Status.not_unfollowed(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/unfollow", username, e)
      ensure
        Databases.close_all
      end
    end

    def follow(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.following(username)
          resp = @api.follow(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.followed(username)
            Logs.rec.info "Followed #{username}."
          else
            puts Status.not_followed(username)
            Errors.warn("#{Status.not_followed(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/follow", username, e)
      ensure
        Databases.close_all
      end
    end

    def unmute(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.unmuting(username)
          resp = @api.unmute(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unmuted(username)
            Logs.rec.info "Unmuted #{username}."
          else
            puts Status.not_unmuted(username)
            Errors.warn("#{Status.not_unmuted(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/unmute", username, e)
      ensure
        Databases.close_all
      end
    end

    def mute(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.muting(username)
          resp = @api.mute(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.muted(username)
            Logs.rec.info "Muted #{username}."
          else
            puts Status.not_muted(username)
            Errors.warn("#{Status.not_muted(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/mute", username, e)
      ensure
        Databases.close_all
      end
    end

    def unblock(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.unblocking(username)
          resp = @api.unblock(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unblocked(username)
            Logs.rec.info "Unblocked #{username}."
          else
            puts Status.not_unblocked(username)
            Errors.warn("#{Status.not_unblocked(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/unblock", username, e)
      ensure
        Databases.close_all
      end
    end

    def block(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          #@view.clear_screen
          puts Status.blocking(username)
          resp = @api.block(username)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.blocked(username)
            Logs.rec.info "Blocked #{username}."
          else
            puts Status.not_blocked(username)
            Errors.warn("#{Status.not_blocked(username)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/block", username, e)
      ensure
        Databases.close_all
      end
    end

    def unrepost(post_id)
      begin
        if post_id.is_integer?
          #@view.clear_screen
          puts Status.unreposting(post_id)
          resp = @api.unrepost(post_id)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            if resp['data']['you_reposted']
              puts Status.unreposted(post_id)
              Logs.rec.info "Unreposted #{post_id}."
            else
              puts "\nThis post isn't one of your reposts.\n\n".color(:red)
            end
          else
            puts Status.not_unreposted(post_id)
            Errors.warn("#{Status.not_unreposted(post_id)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/unrepost", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def unstar(post_id)
      begin
        if post_id.is_integer?
          #@view.clear_screen
          puts Status.unstarring(post_id)
          resp = @api.unstar(post_id)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unstarred(post_id)
            Logs.rec.info "Unstarred #{post_id}."
          else
            puts Status.not_unstarred(post_id)
            Errors.warn("#{Status.not_unstarred(post_id)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/unstar", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def star(post_id)
      begin
        if post_id.is_integer?
          #@view.clear_screen
          puts Status.starring(post_id)
          resp = @api.star(post_id)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.starred(post_id)
            Logs.rec.info "Starred #{post_id}."
          else
            puts Status.not_starred(post_id)
            Errors.warn("#{Status.not_starred(post_id)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/star", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def repost(post_id)
      begin
        if post_id.is_integer?
          #@view.clear_screen
          puts Status.reposting(post_id)
          resp = @api.repost(post_id)
          #@view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.reposted(post_id)
            Logs.rec.info "Reposted #{post_id}."
          else
            puts Status.not_reposted(post_id)
            Errors.warn("#{Status.not_reposted(post_id)} => #{resp['meta']}")
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Errors.global_error("action/repost", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def hashtag(hashtag, options)
      begin
        doing(options)
        stream = @api.get_hashtag(hashtag)
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
        render_view(stream, options)
      rescue => e
        Errors.global_error("action/search", [words, options], e)
      ensure
        Databases.close_all
      end
    end

    def followings(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          unless options[:raw]
            list = @api.get_followings(username)
            if Settings.options[:backup][:auto_save_lists]
              FileOps.save_followings_list(list)
            end
            unless list.empty?
              get_list(:followings, list, username)
              Databases.add_to_users_db_from_list(list)
            else
              Errors.warn "In followings: no data"
              abort(Status.empty_list)
            end
          else
            list = @api.get_raw_list(username, :followings)
            @view.show_raw(list)
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/followings", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def followers(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          unless options[:raw]
            list = @api.get_followers(username)
            if Settings.options[:backup][:auto_save_lists]
              FileOps.save_followers_list(list)
            end
            unless list.empty?
              get_list(:followers, list, username)
              Databases.add_to_users_db_from_list(list)
            else
              Errors.warn "In followers: no data"
              abort(Status.empty_list)
            end
          else
            list = @api.get_raw_list(username, :followers)
            @view.show_raw(list)
          end
        else
          puts Status.error_missing_username
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
          if Settings.options[:backup][:auto_save_lists]
            FileOps.save_muted_list(list)
          end
          unless list.empty?
            get_list(:muted, list, nil)
            Databases.add_to_users_db_from_list(list)
          else
            Errors.warn "In muted: no data"
            abort(Status.empty_list)
          end
        else
          list = @api.get_raw_list(nil, :muted)
          @view.show_raw(list)
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
          unless list.empty?
            get_list(:blocked, list, nil)
            Databases.add_to_users_db_from_list(list)
          else
            Errors.warn "In blocked: no data"
            abort(Status.empty_list)
          end
        else
          list = @api.get_raw_list(nil, :blocked)
          @view.show_raw(list)
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
        unless username.empty?
          username = Workers.add_arobase_if_missing(username)
          doing(options)
          unless options[:raw]
            stream = @api.get_user(username)
            user_404(username) if meta_404(stream)
            if stream['data']['username'] == Settings.config[:identity][:username]
              token = @api.get_token_info
              get_infos(stream['data'], token['data'])
            else
              get_infos(stream['data'], nil)
            end
          else
            @view.show_raw(@api.get_user(username))
            #@view.show_raw(@api.get_token_info)
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Errors.global_error("action/userinfo", [username, options], e)
      ensure
        Databases.close_all
      end
    end

    def postinfo(post_id, options)
      begin
        if post_id.is_integer?
          doing(options)
          unless options[:raw]
            @view.clear_screen
            response = @api.get_details(post_id, options)
            post_404(post_id) if meta_404(response)
            resp = response['data']
            response = @api.get_user("@#{resp['user']['username']}")
            user_404(username) if meta_404(response)
            if response['data']['username'] == Settings.config[:identity][:username]
              token = @api.get_token_info
            end
            stream = response['data']
            puts "POST:\n".inverse
            @view.show_simple_post([resp], options)
            if resp['repost_of']
              puts "REPOST OF:\n".inverse
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
        else
          puts Status.error_missing_post_id
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
          @view.show_files_list(list)
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
        doing
        resp = @api.get_messages(channel_id, options)
        if options[:new]
          no_new_posts unless Databases.has_new?(resp, "channel:#{channel_id}")
        end
        Databases.save_max_id(resp)
        render_view(resp, options)
        if options[:scroll]
          Scroll.new(@api, @view).messages(channel_id, options)
        end
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
        if post_id.is_integer?
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
        else
          puts Status.error_missing_post_id
        end
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
        if Settings.options[:backup][:auto_save_sent_posts]
          FileOps.save_post(resp)
        end
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error("action/post", args, e)
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
        if Settings.options[:backup][:auto_save_sent_posts]
          FileOps.save_post(resp)
        end
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error("action/write", lines_array.join(" "), e)
      ensure
        Databases.close_all
      end
    end

    # def attach(filepath)
    #   begin
    #     #test
    #     puts Endpoints.new.files
    #     puts filepath.inspect

    #     resp = CNX.upload(Endpoints.new.files, filepath)
    #     puts resp
    #   rescue => e
    #     Errors.global_error("action/attach", filepath, e)
    #   ensure
    #     Databases.close_all
    #   end
    # end

    def pmess(username)
    	begin
    		unless username.empty?
	    		messenger = Post.new
	    		puts Status.post
	    		lines_array = messenger.compose
	    		messenger.check_message_length(lines_array)
	    		@view.clear_screen
	    		puts Status.posting
	    		resp = messenger.send_pm(username, lines_array.join("\n"))
          if Settings.options[:backup][:auto_save_sent_messages]
            FileOps.save_message(resp)
          end
	    		@view.clear_screen
	    		puts Status.yourpost
	    		@view.show_posted(resp)
	    	else
	    		puts Status.error_missing_username
	    	end
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
        if Settings.options[:backup][:auto_save_sent_messages]
          FileOps.save_message(resp)
        end
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
      	replied_to = @api.get_details(post_id, {})
        messenger = Post.new
        puts Status.reply
        lines_array = messenger.compose
        messenger.check_post_length(lines_array)
        @view.clear_screen
        reply = messenger.reply(lines_array.join("\n"), Workers.new.build_posts([replied_to]))
        puts Status.posting
        resp = messenger.send_reply(reply, post_id)
        if Settings.options[:backup][:auto_save_sent_posts]
          FileOps.save_post(resp)
        end
        @view.clear_screen
        puts Status.done
        stream = @api.get_convo(post_id, {})
        render_view(stream, {})
      rescue => e
        Errors.global_error("action/reply", post_id, e)
      ensure
        Databases.close_all
      end
    end

    def nowplaying
      unless Settings.config[:platform] =~ /darwin/
        puts Status.error_only_osx
        exit
      end
      track = `osascript -e 'tell application "iTunes"' -e 'set trackName to name of current track' -e 'return trackName' -e 'end tell'`
      album = `osascript -e 'tell application "iTunes"' -e 'set trackAlbum to album of current track' -e 'return trackAlbum' -e 'end tell'`
      artist = `osascript -e 'tell application "iTunes"' -e 'set trackArtist to artist of current track' -e 'return trackArtist' -e 'end tell'`
      track.chomp!
      artist.chomp!
      album.chomp!
      if track.length == 0 || artist.length == 0 || album.length == 0
        puts Status.empty_fields
        exit
      end
      @view.clear_screen
      text_to_post = "#nowplaying '#{track}' from '#{album}' by #{artist}"
      puts "\nAyadn will post this for you:\n".color(:cyan)
      puts text_to_post + "\n\n"
      puts "Do you confirm? (y/N) ".color(:yellow)
      abort("\nCanceled.\n\n".color(:red)) unless STDIN.getch == ("y" || "Y")
      puts "\n"
      post([text_to_post])
    end

    private

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
        @view.clear_screen
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
        channel_id = Databases.get_channel_id(channel_id)
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

  end
end
