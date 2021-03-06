# encoding: utf-8
module Ayadn
  class Action

    ##
    # This class is the main initializer + dispatcher
    # It responds to the CLI commands dispatcher, app.rb

    require_relative "stream"

    def initialize
      @api = API.new
      @status = Status.new      
      @workers = Workers.new(@status)
      @view = View.new(@status, @workers)
      @check = Check.new(@status)
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

    # Uses method_missing to template a single method for several streams
    def method_missing(meth, *args)
      begin
        options = if args.size > 1
          args[1]
        else
          args[0]
        end
        Settings.options.timeline.compact = true if options[:compact]
        Settings.global.force = true if options[:force]
        stream = Stream.new(@api, @view, @workers, @check, @status)
        case meth
        when :mentions, :posts, :whatstarred, :whoreposted, :whostarred, :convo, :followings, :followers, :messages
          stream.send(meth, args[0], options)
        when :unified, :checkins, :global, :trending, :photos, :conversations, :interactions, :muted, :blocked, :random_posts
          stream.send(meth, options)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [meth, options]})
      end
    end

    def delete(post_ids, options = {})
      begin
        ids = get_posts_ids_or_exit(post_ids) { @status.error_missing_post_id }
        ids = get_real_posts_ids_or_force(options, ids)
        puts "\n"
        ids.each do |post_id|
          @status.deleting_post(post_id)
          resp = @api.delete_post(post_id)
          @check.has_been_deleted(post_id, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_ids]})
      end
    end

    def delete_m(args)
      begin
        unless args.length >= 2
          @status.error_missing_message_id
          exit
        end
        channel = args[0]
        args.shift
        ids = get_posts_ids_or_exit(args) { @status.error_missing_message_id }
        channel_id = @workers.get_channel_id_from_alias(channel)
        puts "\n"
        ids.each do |message_id|
          @status.deleting_message(message_id)
          resp = @api.delete_message(channel_id, message_id)
          @check.message_has_been_deleted(message_id, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      end
    end

    def unfollow(usernames)
      begin
        # Verify CLI input, remove current user from list (you never know) to avoid API error
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.unfollowing(users.join(','))
        users.each do |user|
          resp = @api.unfollow(user)
          @check.has_been_unfollowed(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def follow(usernames)
      begin
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.following(users.join(','))
        users.each do |user|
          resp = @api.follow(user)
          @check.has_been_followed(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def unmute(usernames)
      begin
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.unmuting(users.join(','))
        users.each do |user|
          resp = @api.unmute(user)
          @check.has_been_unmuted(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def mute(usernames)
      begin
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.muting(users.join(','))
        users.each do |user|
          resp = @api.mute(user)
          @check.has_been_muted(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def unblock(usernames)
      begin
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.unblocking(users.join(','))
        users.each do |user|
          resp = @api.unblock(user)
          @check.has_been_unblocked(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def block(usernames)
      begin
        users = get_all_usernames_but_me(usernames)
        puts "\n"
        @status.blocking(users.join(','))
        users.each do |user|
          resp = @api.block(user)
          @check.has_been_blocked(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def repost(post_ids, options = {})
      begin
        ids = get_posts_ids_or_exit(post_ids) { @status.error_missing_post_id }
        ids = get_real_posts_ids_or_force(options, ids)
        puts "\n"
        ids.each do |post_id|
          @status.reposting(post_id)
          # Retrieve the post we want to repost
          resp = @api.get_details(post_id)
          # Verify it hasn't been already reposted by us
          @check.already_reposted(resp)
          # Maybe the post is already a repost by someone else?
          id = @workers.get_original_id(post_id, resp)
          # Repost then verify it has been done
          @check.has_been_reposted(id, @api.repost(id))
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_ids, id]})
      end
    end

    def unrepost(post_ids, options = {})
      begin
        ids = get_posts_ids_or_exit(post_ids) { @status.error_missing_post_id }
        ids = get_real_posts_ids_or_force(options, ids)
        puts "\n"
        ids.each do |post_id|
          @status.unreposting(post_id)
          if @api.get_details(post_id)['data']['you_reposted']
            @check.has_been_unreposted(post_id, @api.unrepost(post_id))
          else
            @status.not_your_repost
          end
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_ids]})
      end
    end

    def unstar(post_ids, options = {})
      begin
        ids = get_posts_ids_or_exit(post_ids) { @status.error_missing_post_id }
        ids = get_real_posts_ids_or_force(options, ids)
        puts "\n"
        ids.each do |post_id|
          @status.unstarring(post_id)
          resp = @api.get_details(post_id)
          id = @workers.get_original_id(post_id, resp)
          resp = @api.get_details(id)
          if resp['data']['you_starred']
            @check.has_been_unstarred(id, @api.unstar(id))
          else
            @status.not_your_starred
          end
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_ids]})
      end
    end

    def star(post_ids, options = {})
      begin
        ids = get_posts_ids_or_exit(post_ids) { @status.error_missing_post_id }
        ids = get_real_posts_ids_or_force(options, ids)
        puts "\n"
        ids.each do |post_id|
          @status.starring(post_id)
          resp = @api.get_details(post_id)
          @check.already_starred(resp)
          id = @workers.get_original_id(post_id, resp)
          @check.has_been_starred(id, @api.star(id))
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_ids]})
      end
    end

    def hashtag(hashtag, options)
      begin
        search = Search.new(@api, @view, @workers)
        search.hashtag(hashtag, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [hashtag, options]})
      end
    end

    def search(words, options)
      begin
        search = Search.new(@api, @view, @workers)
        search.find(words, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [words, options]})
      end
    end

    def view_settings(options)
      begin
        if options[:raw]
          jj JSON.parse(Settings.options.to_h.to_json)
        else
          Settings.options.timeline.compact = true if options[:compact]
          @view.show_settings
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def userupdate options
      begin
        profile = Profile.new(options)
        profile.get_text_from_user
        profile.prepare_payload
        @status.updating_profile
        profile.update
        @status.done
        userinfo(['me'], options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def userinfo(username, options = {})
      begin
        Settings.options.timeline.compact = true if options[:compact]
        @check.no_username(username)
        usernames = @workers.add_arobases_to_usernames(username)
        usernames.each.with_index do |username, index|
          if options[:raw]
            @view.show_raw(@api.get_user(username), options)
          else
            @view.downloading if index == 0
            user_object = UserObject.new(@api.get_user(username), username)
            # Is it us? If yes, get *our* info
            @check.same_username(user_object) ? token = @api.get_token_info['data'] : token = nil
            @view.clear_screen if index == 0
            @view.infos(user_object, token)
          end
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def postinfo(post_id, options)
      begin
        @check.bad_post_id(post_id)
        Settings.options.timeline.compact = true if options[:compact]
        post_id = get_real_post_id_or_force(options, post_id)
        details = lambda { @api.get_details(post_id, options) }
        if options[:raw]
          @view.show_raw(details.call, options)
          exit
        end
        @view.clear_screen
        response = details.call
        @check.no_details(response, post_id)

        post_object = PostObject.new(response["data"])

        if post_object.is_deleted
          @status.user_404(post_object.id)
          Errors.global_error({error: "user 404", caller: caller, data: [post_id, options]})
        end

        response = @api.get_user("@#{post_object.user.username}")
        user_object = UserObject.new(response, post_object.user.username)

        @status.post_info
        @view.show_simple_post([post_object], options)
        puts "\n" if Settings.options.timeline.compact
        @status.say_info "author"
        puts "\n" unless Settings.options.timeline.compact
        # Is it us? ...
        if user_object.username == Settings.config.identity.username
          @view.show_userinfos(post_object.user, @api.get_token_info['data'], true)
        else
          @view.show_userinfos(post_object.user, nil, true)
        end

        if !post_object.repost_of.nil?
          @status.repost_info
          # If we ask infos for a reposted post, fetch the original instead
          Errors.repost(post_id, post_object.repost_of.id)
          @view.show_simple_post([post_object.repost_of], options)
          puts "\n" if Settings.options.timeline.compact
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def files(options)
      begin
        get_files = lambda { @api.get_files_list(options) }
        if options[:raw]
          @view.show_raw(get_files.call)
        else
          @view.downloading
          list = get_files.call
          Errors.no_data('files') if list.empty?
          @view.clear_screen
          @view.show_files_list(list)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def download(file_id)
      begin
        file = @api.get_file(file_id)['data']
        FileOps.download_url(file['name'], file['url'])
        @status.downloaded(file['name'])
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [file_id, file['url']]})
      end
    end

    def channels options
      begin
        # Input could be channel IDs or channel aliases
        channels = if options[:id]
          channel_id = options[:id].map {|id| @workers.get_channel_id_from_alias(id)}
          lambda { @api.get_channel(channel_id, options) }
        else
          lambda { @api.get_channels }
        end
        if options[:raw]
          @view.show_direct_raw(channels.call)
          exit
        else
          @view.downloading
          resp = channels.call
          @view.clear_screen
          data = resp["data"] 
          channels = data.map { |ch| ChannelObject.new(ch) }
          @view.show_channels(channels, options)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def messages_unread(options)
      begin
        Settings.options.timeline.compact = true if options[:compact]
        Settings.options.marker.messages = false if options[:silent] # Option to not mark the messages as read
        puts "\n"
        @status.say_nocolor :searching, "channels with unread PMs"
        channels_objects = @api.get_channels['data'].map { |obj| ChannelObject.new(obj) }
        unread_channels = []
        channels_objects.each do |ch|
          # Channels can be of many types, PMs are only one type
          if ch.type == "net.app.core.pm" && ch.has_unread
            unread_channels << ch.id
          end
        end
        if unread_channels.empty?
          @status.no_new_messages
          exit
        end
        unread_messages = {}
        unread_channels.reverse.each do |id|
          @status.say_nocolor :downloading, "messages from channel #{id}"
          # Find the last time we've done this
          since = Databases.find_last_id_from("channel:#{id}")
          unless since.nil?
            api_options = {count: 20, since_id: since}
          else
            api_options = {count: 20}
          end
          ch = @api.get_messages(id, api_options)
          # Find the last message seen and the last message in the channel
          last_read_id = ch['meta']['marker']['last_read_id'].to_i
          last_message_id = ch['meta']['max_id']
          messages = ch['data'].map { |msg| msg if msg['id'].to_i > last_read_id }
          unread_messages[id] = [messages, last_message_id]
        end
        # If we want to mark the messages as read
        if Settings.options.marker.messages
          unread_messages.each do |k,v|
            name = "channel:#{k}"
            # Save the reading position locally
            Databases.pagination_insert(name, v[1])
            # Mark as read
            resp = @api.update_marker(name, v[1])
            res = JSON.parse(resp)
            if res['meta']['code'] != 200
              @status.say_error "couldn't update channel #{k} as read"
            else
              @status.say_green :updated, "channel #{k} as read"
            end
          end
        end
        @view.clear_screen
        unread_messages.each do |k,v|
          @status.unread_from_channel(k)
          messages_objects = v[0].map { |post_hash| PostObject.new(post_hash) }
          @view.show_messages(messages_objects)
        end
        puts "\n" if Settings.options.timeline.compact
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def pin(post_id, usertags, options = {})
      begin
        require 'pinboard'
        require 'base64'
      rescue LoadError => e
        puts "\nAYADN: Error while loading Gems\n\n"
        puts "RUBY: #{e}\n\n"
        exit
      end
      begin
        @check.bad_post_id(post_id)
        Settings.options.timeline.compact = true if options[:compact]
        post_id = get_real_post_id_or_force(options, post_id)
        @view.downloading
        # Get the details from the post we want to send to Pinboard
        # resp = @api.get_details(post_id)['data']
        @view.clear_screen
        # Extract links from the post
        post_object = PostObject.new(@api.get_details(post_id)['data'])
        links = @workers.extract_links(post_object)
        # In case the post has no text, to prevent an error
        post_object.text.nil? ? text = "" : text = post_object.text
        # The first tag is always "ADN"
        usertags << "ADN"
        handle = "@" + post_object.user.username
        post_text = "From: #{handle} -- Text: #{text} -- Links: #{links.join(" ")}"
        pinner = Ayadn::PinBoard.new
        unless pinner.has_credentials_file?
          # No Pinboard account registered? Ask for one.
          @status.no_pin_creds
          pinner.ask_credentials(@status)
          @status.pin_creds_saved
        end
        # Get stored credentials
        credentials = pinner.load_credentials
        maker = Struct.new(:username, :password, :url, :tags, :text, :description)
        bookmark = maker.new(credentials[0], credentials[1], post_object.canonical_url, usertags.join(","), post_text, post_object.canonical_url)
        @status.saving_pin
        pinner.pin(bookmark)
        @status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, usertags]})
      end
    end

    def auto(options)
      begin
        @view.clear_screen
        @status.auto
        Post.new(@status).auto_readline
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def post(args, options)
      begin
        Settings.options.timeline.compact = true if options[:compact]
        post_and_show(Post.new(@status), args.join(" "), options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    def write(options)
      begin
        Settings.options.timeline.compact = true if options[:compact]
        writer = Post.new(@status)
        @status.writing
        @status.post
        text = writer.compose.join("\n")
        post_and_show(writer, text, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [text, options]})
      end
    end

    def pmess(username, options = {})
      begin
        Settings.options.timeline.compact = true if options[:compact]
        Settings.options.marker.messages = false if options[:silent]
        @check.no_username(username)
        username = [@workers.add_arobase(username)]
        writer = Post.new(@status)
        @status.message_from(username)
        @status.message
        text = writer.compose.join("\n")
        writer.message_size_error(text) if !writer.message_size_ok?(text)
        @view.clear_screen
        @status.posting
        resp = writer.pm({options: options, text: text, username: username})
        post_object = PostObject.new(resp["data"])
        if Settings.options.marker.messages
          if resp['meta']['code'] == 200
            name = "channel:#{post_object.channel_id}"
            Databases.pagination_insert(name, post_object.id)
            marked = @api.update_marker(name, post_object.id)
            updated = JSON.parse(marked)
            if updated['meta']['code'] != 200
              raise "couldn't update channel #{post_object.channel_id} as read"
            end
          end
        end
        FileOps.save_message(resp) if Settings.options.backup.messages
        @view.clear_screen
        @status.yourmessage(username[0])
        @view.show_simple_post([post_object])
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def reply(post_id, options = {})
      begin
        Settings.options.timeline.compact = true if options[:compact]
        @check.bad_post_id(post_id)
        post_id = get_real_post_id_or_force(options, post_id)
        @status.replying_to(post_id)
        replied_to = @api.get_details(post_id)
        @check.no_details(replied_to, post_id)
        # API specifies to always reply to the original post of a reposted post. We offer the user an option to not.
        unless options[:noredirect]
          post_id = @workers.get_original_id(post_id, replied_to)
        end
        if replied_to['data']['repost_of']
          if post_id == replied_to['data']['repost_of']['id']
            replied_to = @api.get_details(post_id)
            @check.no_details(replied_to, post_id)
          end
        end
        # ----
        writer = Post.new(@status)
        @status.writing
        @status.reply
        text = writer.compose.join("\n")
        # Text length is tested in Post class for the reply command
        @view.clear_screen
        replied_to = @workers.build_posts([PostObject.new(replied_to['data'])])[0]
        resp = writer.reply({options: options, text: text, id: post_id, reply_to: replied_to})
        FileOps.save_post(resp) if Settings.options.backup.posts
        # ----
        # "options" from CLI is immutable, we have to make a copy to add items
        options = options.dup
        unless resp['data']['reply_to'].nil?
          options[:reply_to] = resp['data']['reply_to'].to_i
        end
        options[:post_id] = resp['data']['id'].to_i
        stream = @api.get_convo(post_id)
        stream_object = StreamObject.new(stream)
        @view.render(stream_object, options)
        puts "\n" if Settings.options.timeline.compact && !options[:raw]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def send_to_channel(channel_id, options = {})
      begin
        Settings.options.timeline.compact = true if options[:compact]
        Settings.options.marker.messages = false if options[:silent]
        channel_id = @workers.get_channel_id_from_alias(channel_id)
        writer = Post.new(@status)
        @status.writing
        @status.message
        text = writer.compose.join("\n")
        writer.message_size_error(text) if !writer.message_size_ok?(text)
        @view.clear_screen
        @status.posting
        resp = writer.message({options: options, id: channel_id, text: text})
        post_object = PostObject.new(resp["data"])
        if Settings.options.marker.messages
          if resp['meta']['code'] == 200
            name = "channel:#{post_object.channel_id}"
            Databases.pagination_insert(name, post_object.id)
            marked = @api.update_marker(name, post_object.id)
            updated = JSON.parse(marked)
            if updated['meta']['code'] != 200
              raise "couldn't update channel #{post_object.channel_id} as read"
            end
          end
        end
        FileOps.save_message(resp) if Settings.options.backup.messages
        @view.clear_screen
        @status.yourpost
        @view.show_simple_post([post_object])
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [channel_id, options]})
      end
    end

    def nowplaying(options = {})
      Settings.options.timeline.compact = true if options[:compact]
      np = NowPlaying.new(@api, @view, @workers, @status, options)
      if options[:lastfm]
        np.lastfm(options)
      elsif options[:deezer]
        np.deezer(options)
      else
        np.itunes(options)
      end
    end

    private

    def save_and_view(resp)
      FileOps.save_post(resp) if Settings.options.backup.posts
      @view.clear_screen
      @status.yourpost
      puts "\n\n"
      @view.show_posted(resp)
    end

    def get_posts_ids_or_exit ids
      int_ids = ids.select { |post_id| post_id.is_integer? }
      if int_ids.empty?
        yield
        exit
      end
      int_ids
    end

    def get_all_usernames_but_me usernames
      @check.no_username(usernames)
      @workers.all_but_me(usernames)
    end

    def get_real_posts_ids_or_force options, posts_ids
      if options[:force]
        Settings.global.force = true
        posts_ids
      else
        posts_ids.map { |post_id| @workers.get_real_post_id(post_id) }
      end
    end

    def get_real_post_id_or_force options, post_id
      if options[:force]
        Settings.global.force = true
        post_id
      else
        @workers.get_real_post_id(post_id)
      end
    end

    def post_and_show writer, text, options
      writer.post_size_error(text) if !writer.post_size_ok?(text)
      @view.clear_screen
      @status.posting
      resp = writer.post({options: options, text: text})
      save_and_view(resp)
    end

  end
end
