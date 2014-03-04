module Ayadn
  class Action

    def initialize
      @api = API.new
      @view = View.new
      MyConfig.load_config
      Logs.create_logger
      Databases.open_databases
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

    def unified(options)
      begin
        doing(options)
        stream = @api.get_unified(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/unified"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def checkins(options)
      begin
        doing(options)
        stream = @api.get_checkins(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/checkins"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def global(options)
      begin
        doing(options)
        stream = @api.get_global(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/global"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def trending(options)
      begin
        doing(options)
        stream = @api.get_trending(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/trending"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def photos(options)
      begin
        doing(options)
        stream = @api.get_photos(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/photos"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def conversations(options)
      begin
        doing(options)
        stream = @api.get_conversations(options)
        render_view(stream, options)
      rescue => e
        Logs.rec.error "In action/conversations"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def mentions(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          stream = @api.get_mentions(username, options)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/mentions with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
        #raise e
      ensure
        Databases.close_all
      end
    end

    def posts(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          stream = @api.get_posts(username, options)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/posts with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def interactions
      begin
        doing({})
        stream = get_data_from_response(@api.get_interactions)
        @view.clear_screen
        @view.show_interactions(stream)
      rescue => e
        Logs.rec.error "In action/interactions"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def whatstarred(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          stream = @api.get_whatstarred(username, options)
          render_view(stream, options)
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/whatstarred with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def whoreposted(post_id)
      begin
        if post_id.is_integer?
          doing({})
          list = get_data_from_response(@api.get_whoreposted(post_id))
          get_list(:whoreposted, list, post_id)
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/whoreposted with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def whostarred(post_id)
      begin
        if post_id.is_integer?
          doing({})
          list = get_data_from_response(@api.get_whostarred(post_id))
          get_list(:whostarred, list, post_id)
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/whostarred with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def convo(post_id, options)
      begin
        if post_id.is_integer?
          doing(options)
          stream = @api.get_convo(post_id, options)
          render_view(stream, options)
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/convo with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def delete(post_id)
      begin
        if post_id.is_integer?
          @view.clear_screen
          print Status.deleting_post(post_id)
          resp = @api.delete_post(post_id)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.deleted(post_id)
          else
            puts Status.not_deleted(post_id)
            Logs.rec.warn "#{Status.not_deleted(post_id)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/delete with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def unfollow(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.unfollowing(username)
          resp = @api.unfollow(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unfollowed(username)
          else
            puts Status.not_unfollowed(username)
            Logs.rec.warn "#{Status.not_unfollowed(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/unfollow with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def follow(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.following(username)
          resp = @api.follow(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.followed(username)
          else
            puts Status.not_followed(username)
            Logs.rec.warn "#{Status.not_followed(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/follow with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def unmute(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.unmuting(username)
          resp = @api.unmute(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unmuted(username)
          else
            puts Status.not_unmuted(username)
            Logs.rec.warn "#{Status.not_unmuted(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/unmute with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def mute(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.muting(username)
          resp = @api.mute(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.muted(username)
          else
            puts Status.not_muted(username)
            Logs.rec.warn "#{Status.not_muted(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/mute with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def unblock(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.unblocking(username)
          resp = @api.unblock(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unblocked(username)
          else
            puts Status.not_unblocked(username)
            Logs.rec.warn "#{Status.not_unblocked(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/unblock with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def block(username)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          @view.clear_screen
          puts Status.blocking(username)
          resp = @api.block(username)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.blocked(username)
          else
            puts Status.not_blocked(username)
            Logs.rec.warn "#{Status.not_blocked(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/block with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def unrepost(post_id)
      begin
        if post_id.is_integer?
          @view.clear_screen
          puts Status.unreposting(post_id)
          resp = @api.unrepost(post_id)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unreposted(post_id)
          else
            puts Status.not_unreposted(post_id)
            Logs.rec.warn "#{Status.not_unreposted(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/unrepost with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def unstar(post_id)
      begin
        if post_id.is_integer?
          @view.clear_screen
          puts Status.unstarring(post_id)
          resp = @api.unstar(post_id)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.unstarred(post_id)
          else
            puts Status.not_unstarred(post_id)
            Logs.rec.warn "#{Status.not_unstarred(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/unstar with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def star(post_id)
      begin
        if post_id.is_integer?
          @view.clear_screen
          puts Status.starring(post_id)
          resp = @api.star(post_id)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.starred(post_id)
          else
            puts Status.not_starred(post_id)
            Logs.rec.warn "#{Status.not_starred(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/star with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def repost(post_id)
      begin
        if post_id.is_integer?
          @view.clear_screen
          puts Status.reposting(post_id)
          resp = @api.repost(post_id)
          @view.clear_screen
          if resp['meta']['code'] == 200
            puts Status.reposted(post_id)
          else
            puts Status.not_reposted(post_id)
            Logs.rec.warn "#{Status.not_reposted(username)}"
            Logs.rec.warn "#{resp['meta']}"
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/repost with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
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
        Logs.rec.error "In action/hashtag with args: #{hashtag}"
        Logs.rec.error "#{e}"
        global_error(e)
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
        Logs.rec.error "In action/search with args: #{words}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def followings(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          unless options[:raw]
            list = @api.get_followings(username)
            unless list.empty?
              get_list(:followings, list, username)
              FileOps.add_to_users_db_from_list(list)
            else
              Logs.rec.warn "In followings: no data"
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
        Logs.rec.error "In action/followings with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def followers(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          unless options[:raw]
            list = @api.get_followers(username)
            unless list.empty?
              get_list(:followers, list, username)
              FileOps.add_to_users_db_from_list(list)
            else
              Logs.rec.warn "In followers: no data"
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
        Logs.rec.error "In action/followers with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def muted(options)
      begin
        doing(options)
        unless options[:raw]
          list = @api.get_muted
          unless list.empty?
            get_list(:muted, list, nil)
            FileOps.add_to_users_db_from_list(list)
          else
            Logs.rec.warn "In muted: no data"
            abort(Status.empty_list)
          end
        else
          list = @api.get_raw_list(nil, :muted)
          @view.show_raw(list)
        end
      rescue => e
        Logs.rec.error "In action/muted"
        Logs.rec.error "#{e}"
        global_error(e)
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
            FileOps.add_to_users_db_from_list(list)
          else
            Logs.rec.warn "In blocked: no data"
            abort(Status.empty_list)
          end
        else
          list = @api.get_raw_list(nil, :blocked)
          @view.show_raw(list)
        end
      rescue => e
        Logs.rec.error "In action/blocked"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def view_settings
      begin
        @view.clear_screen
        @view.settings
      rescue => e
        Logs.rec.error "In action/settings"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def userinfo(username, options)
      begin
        unless username.empty?
          username = Workers.add_arobase_if_absent(username)
          doing(options)
          unless options[:raw]
            stream = get_data_from_response(@api.get_user(username))
            get_infos(stream)
          else
            @view.show_raw(@api.get_user(username))
          end
        else
          puts Status.error_missing_username
        end
      rescue => e
        Logs.rec.error "In action/userinfo with args: #{username}"
        Logs.rec.error "#{e}"
        global_error(e)
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
            resp = get_data_from_response(@api.get_details(post_id, options))
            stream = get_data_from_response(@api.get_user("@#{resp['user']['username']}"))
            puts "POST:\n".inverse
            @view.show_simple_post([resp], options)
            puts "AUTHOR:\n".inverse
            @view.show_userinfos(stream)
          else
            @view.show_raw(@api.get_details(post_id, options))
          end
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/postinfo with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
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
        Logs.rec.error "In action/files"
        Logs.rec.error "#{e}"
        global_error(e)
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
        Logs.rec.error "In action/channels"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def messages(channel_id, options)
      begin
        if channel_id.is_integer?
          doing
          resp = @api.get_messages(channel_id, options)
          render_view(resp, options)
        else
          puts Status.error_missing_channel_id
          #TODO: replace with get from aliased channel
          #if not int && not in db then err
        end
      rescue => e
        Logs.rec.error "In action/messages with args: #{channel_id}"
        Logs.rec.error "#{e}"
        global_error(e)
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
          gandalf = Ayadn::PinBoard.new
          unless gandalf.has_credentials_file?
            puts "\nAyadn couldn't find your Pinboard credentials.\n".color(:red)
            gandalf.save_credentials(gandalf.ask_credentials)
            puts "\n\nCredentials successfully encoded and saved in database.\n\n".color(:green)
          end
          credentials = gandalf.decode(gandalf.load_credentials)
          ring = Struct.new(:username, :password, :url, :tags, :text, :description)
          hobbit = ring.new(credentials[0], credentials[1], post_url, usertags.join(","), post_text, links[0])
          puts "\nSaving post text and links to Pinboard...\n\n".color(:yellow)
          gandalf.pin(hobbit)
          puts "Done!\n\n".color(:green)
        else
          puts Status.error_missing_post_id
        end
      rescue => e
        Logs.rec.error "In action/pin with args: #{post_id} #{usertags}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def post(args)
      begin
        @view.clear_screen
        puts Status.posting
        resp = Post.new.post(args)
        @view.clear_screen
        puts Status.done
        @view.show_posted(resp)
      rescue => e
        Logs.rec.error "In action/post with args: #{args}"
        Logs.rec.error "#{e}"
        global_error(e)
      ensure
        Databases.close_all
      end
    end

    def write
      begin
        obj = Post.new
        lines_array = obj.compose
        #lines_array = Post.new.compose
        #puts lines_array.inspect
        obj.check_length(lines_array, :post)
        puts "---"
        puts lines_array.join("\n")
        #post = lines_array.join("\n")
        #resp = post.send_post(text)
        #show_posted(resp)
      rescue => e
        Logs.rec.error "In action/write"
        Logs.rec.error "#{e}"
        global_error(e)
        raise e #temp
      ensure
        Databases.close_all
      end
    end

    def reply(post_id)
      begin
        Post.new.reply(post_id)
      rescue => e
        Logs.rec.error "In action/reply with args: #{post_id}"
        Logs.rec.error "#{e}"
        global_error(e)
        raise e #temp
      ensure
        Databases.close_all
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

    def get_infos(stream)
      @view.clear_screen
      @view.show_userinfos(stream)
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


    def global_error(e)
      @view.clear_screen
      puts "\n\nERROR (see #{MyConfig.config[:paths][:log]}/ayadn.log)\n".color(:red)
    end



  end
end
