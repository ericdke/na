# encoding: utf-8
module Ayadn
  class Action

    ##
    # This class is the main initializer + dispatcher

    def initialize
      @api = API.new
      @view = View.new
      @workers = Workers.new
      @stream = Stream.new(@api, @view, @workers)
      @search = Search.new(@api, @view, @workers)
      @thor = Thor::Shell::Color.new # will be replaced by @status eventually
      @status = Status.new
      @check = Check.new
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

    def method_missing(meth, options)
      case meth.to_s
      when 'unified', 'checkins', 'global', 'trending', 'photos', 'conversations', 'interactions'
        begin
          @stream.send(meth.to_sym, options)
        rescue => e
          Errors.global_error({error: e, caller: caller, data: [meth, options]})
        end
      else
        super
      end
    end

    def mentions(username, options)
      begin
        @stream.mentions(username, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def posts(username, options)
      begin
        @stream.posts(username, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def whatstarred(username, options)
      begin
        @stream.whatstarred(username, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def whoreposted(post_id, options)
      begin
        @stream.whoreposted(post_id, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def whostarred(post_id, options)
      begin
        @stream.whostarred(post_id, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def convo(post_id, options)
      begin
        @stream.convo(post_id, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def delete(post_ids)
      begin
        ids = post_ids.select { |post_id| post_id.is_integer? }
        if ids.empty?
          @status.error_missing_post_id
          exit
        end
        puts "\n"
        ids.each do |post_id|
          @status.deleting_post(post_id)
          resp = @api.delete_post(post_id)
          @check.has_been_deleted(post_id, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
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
        ids = args.select {|message_id| message_id.is_integer?}
        if ids.empty?
          @status.error_missing_message_id
          exit
        end
        channel_id = @workers.get_channel_id_from_alias(channel)
        puts "\n"
        ids.each do |message_id|
          @status.deleting_message(message_id)
          resp = @api.delete_message(channel_id, message_id)
          @check.message_has_been_deleted(message_id, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [message_id]})
      end
    end

    def unfollow(usernames)
      begin
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
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
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
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
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
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
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
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
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
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
        @check.no_username(usernames)
        users = @workers.all_but_me(usernames)
        @status.blocking(users.join(','))
        users.each do |user|
          resp = @api.block(user)
          @check.has_been_blocked(user, resp)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def repost(post_id)
      begin
        @check.bad_post_id(post_id)
        @status.reposting(post_id)
        resp = @api.get_details(post_id)
        @check.already_reposted(resp)
        id = @workers.get_original_id(post_id, resp)
        @check.has_been_reposted(id, @api.repost(id))
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, id]})
      end
    end

    def unrepost(post_id)
      begin
        @check.bad_post_id(post_id)
        @status.unreposting(post_id)
        if @api.get_details(post_id)['data']['you_reposted']
          @check.has_been_unreposted(post_id, @api.unrepost(post_id))
        else
          @status.not_your_repost
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def unstar(post_id)
      begin
        @check.bad_post_id(post_id)
        @status.unstarring(post_id)
        resp = @api.get_details(post_id)
        id = @workers.get_original_id(post_id, resp)
        resp = @api.get_details(id)
        if resp['data']['you_starred']
          @check.has_been_unstarred(id, @api.unstar(id))
        else
          @status.not_your_starred
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def star(post_id)
      begin
        @check.bad_post_id(post_id)
        @status.starring(post_id)
        resp = @api.get_details(post_id)
        @check.already_starred(resp)
        id = @workers.get_original_id(post_id, resp)
        @check.has_been_starred(id, @api.star(id))
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def hashtag(hashtag, options)
      begin
        @search.hashtag(hashtag, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [hashtag, options]})
      end
    end

    def search(words, options)
      begin
        @search.find(words, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [words, options]})
      end
    end

    def followings(username, options)
      begin
        @stream.followings(username, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def followers(username, options)
      begin
        @stream.followers(username, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def muted(options)
      begin
        @stream.muted(options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def blocked(options)
      begin
        @stream.blocked(options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def view_settings(options)
      begin
        if options[:raw]
          jj JSON.parse(Settings.config.to_json)
          jj JSON.parse(Settings.options.to_json)
        else
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
        userinfo('me')
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def userinfo(username, options = {})
      begin
        username = [username] unless username.is_a?(Array)
        @check.no_username(username)
        username = @workers.add_arobase(username)
        if options[:raw]
          @view.show_raw(@api.get_user(username), options)
        else
          @view.downloading
          stream = @api.get_user(username)
          @check.no_user(stream, username)
          @check.same_username(stream) ? token = @api.get_token_info['data'] : token = nil
          @view.clear_screen
          @view.infos(stream['data'], token)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def postinfo(post_id, options)
      begin
        Settings.options[:force] = true if options[:force]
        @check.bad_post_id(post_id)
        details = lambda { @api.get_details(post_id, options) }
        if options[:raw]
          @view.show_raw(details.call, options)
          exit
        end
        @view.clear_screen
        response = details.call
        @check.no_post(response, post_id)
        resp = response['data']
        response = @api.get_user("@#{resp['user']['username']}")
        @check.no_user(response, response['data']['username'])
        stream = response['data']
        @status.post_info
        @view.show_simple_post([resp], options)
        if resp['repost_of']
          @status.repost_info
          Errors.repost(post_id, resp['repost_of']['id'])
          @view.show_simple_post([resp['repost_of']], options)
        end
        if Settings.options[:timeline][:compact] == false
          @status.say { @thor.say_status "info", "author", "cyan" }
        else
          @thor.say_status "info", "author", "cyan"
        end
        if response['data']['username'] == Settings.config[:identity][:username]
          @view.show_userinfos(stream, @api.get_token_info['data'], true)
        else
          @view.show_userinfos(stream, nil, true)
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
        channels = if options[:id]
          channel_id = options[:id].map {|id| @workers.get_channel_id_from_alias(id)}
          lambda { @api.get_channel(channel_id, options) }
        else
          lambda { @api.get_channels }
        end
        if options[:raw]
          @view.show_raw(channels.call)
          exit
        else
          @view.downloading
          resp = channels.call
          @view.clear_screen
          @view.show_channels(resp, options)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def messages(channel_id, options)
      begin
        @stream.messages(channel_id, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [channel_id, options]})
      end
    end

    def messages_unread(options)
      begin
        if options[:silent]
          Settings.options[:marker][:update_messages] = false
        end
        puts "\n"
        @thor.say_status :searching, "channels with unread PMs"
        response = @api.get_channels
        unread_channels = []
        response['data'].map do |ch|
          if ch['type'] == "net.app.core.pm" && ch['has_unread'] == true
            unread_channels << ch['id']
          end
        end
        if unread_channels.empty?
          @status.no_new_messages
          exit
        end
        unread_messages = {}
        unread_channels.each do |id|
          @thor.say_status :downloading, "messages from channel #{id}"
          since = Databases.find_last_id_from("channel:#{id}")
          unless since.nil?
            api_options = {count: 20, since_id: since}
          else
            api_options = {count: 20}
          end
          ch = @api.get_messages(id, api_options)
          last_read_id = ch['meta']['marker']['last_read_id'].to_i
          last_message_id = ch['meta']['max_id']
          messages = []
          ch['data'].each do |msg|
            messages << msg if msg['id'].to_i > last_read_id
          end
          unread_messages[id] = [messages, last_message_id]
        end
        if Settings.options[:marker][:update_messages] == true
          unread_messages.each do |k,v|
            name = "channel:#{k}"
            Databases.pagination_insert(name, v[1])
            resp = @api.update_marker(name, v[1])
            res = JSON.parse(resp)
            if res['meta']['code'] != 200
              @thor.say_status :error, "couldn't update channel #{k} as read", :red
            else
              @thor.say_status :updated, "channel #{k} as read", :green
            end
          end
        end
        @view.clear_screen
        unread_messages.each do |k,v|
          @status.unread_from_channel(k)
          @view.show_posts(v[0])
        end
        puts "\n" if Settings.options[:timeline][:compact]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def pin(post_id, usertags)
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
        @view.downloading
        resp = @api.get_details(post_id)['data']
        @view.clear_screen
        links = @workers.extract_links(resp)
        resp['text'].nil? ? text = "" : text = resp['text']
        usertags << "ADN"
        handle = "@" + resp['user']['username']
        post_text = "From: #{handle} -- Text: #{text} -- Links: #{links.join(" ")}"
        pinner = Ayadn::PinBoard.new
        unless pinner.has_credentials_file?
          @status.no_pin_creds
          pinner.ask_credentials
          @status.pin_creds_saved
        end
        credentials = pinner.load_credentials
        maker = Struct.new(:username, :password, :url, :tags, :text, :description)
        bookmark = maker.new(credentials[0], credentials[1], resp['canonical_url'], usertags.join(","), post_text, links[0])
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
        Post.new.auto_readline
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def post(args, options)
      begin
        writer = Post.new
        @view.clear_screen
        @status.posting
        if options[:poster] # Returns the same options hash + poster embed
          settings = options.dup
          options = NowWatching.new.get_poster(settings[:poster], settings)
        end
        resp = writer.post({options: options, text: args.join(" ")})
        save_and_view(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    def write(options)
      begin
        writer = Post.new
        @status.writing
        @status.post
        lines_array = writer.compose
        writer.check_post_length(lines_array)
        text = lines_array.join("\n")
        @view.clear_screen
        @status.posting
        if options[:poster]
          settings = options.dup
          options = NowWatching.new.get_poster(settings[:poster], settings)
        end
        resp = writer.post({options: options, text: text})
        save_and_view(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [text, options]})
      end
    end

    def pmess(username, options = {})
    	begin
        if options[:silent]
          Settings.options[:marker][:update_messages] = false
        end
        @check.no_username(username)
        username = [@workers.add_arobase(username)]
    		writer = Post.new
        @status.message_from(username)
    		@status.message
    		lines_array = writer.compose
    		writer.check_message_length(lines_array)
        text = lines_array.join("\n")
    		@view.clear_screen
        @status.posting
        if options[:poster]
          settings = options.dup
          options = NowWatching.new.get_poster(settings[:poster], settings)
        end
        resp = writer.pm({options: options, text: text, username: username})
        if Settings.options[:marker][:update_messages] == true
          if resp['meta']['code'] == 200
            data = resp['data']
            name = "channel:#{data['channel_id']}"
            Databases.pagination_insert(name, data['id'])
            marked = @api.update_marker(name, data['id'])
            updated = JSON.parse(marked)
            if updated['meta']['code'] != 200
              raise "couldn't update channel #{data['channel_id']} as read"
            end
          end
        end
        FileOps.save_message(resp) if Settings.options[:backup][:sent_messages]
    		@view.clear_screen
    		@status.yourmessage(username[0])
    		@view.show_posted(resp)
    	rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
    	end
    end

    def reply(post_id, options = {})
      begin
        post_id = @workers.get_real_post_id(post_id)
      	@status.replying_to(post_id)
      	replied_to = @api.get_details(post_id)
        @check.no_post(replied_to, post_id)
        unless options[:noredirect]
          post_id = @workers.get_original_id(post_id, replied_to)
        end
        if replied_to['data']['repost_of']
          if post_id == replied_to['data']['repost_of']['id']
            replied_to = @api.get_details(post_id)
            @check.no_post(replied_to, post_id)
          end
        end
        # ----
        writer = Post.new
        @status.writing
        @status.reply
        lines_array = writer.compose
        writer.check_post_length(lines_array)
        @view.clear_screen
        text = lines_array.join("\n")
        replied_to = @workers.build_posts([replied_to['data']])
        if options[:poster]
          settings = options.dup
          options = NowWatching.new.get_poster(settings[:poster], settings)
        end
        resp = writer.reply({options: options, text: text, id: post_id, reply_to: replied_to})
        FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
        # ----
        options = options.dup
        unless resp['data']['reply_to'].nil?
          options[:reply_to] = resp['data']['reply_to'].to_i
        end
        options[:post_id] = resp['data']['id'].to_i
        @view.render(@api.get_convo(post_id), options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def send_to_channel(channel_id, options = {})
      begin
        if options[:silent]
          Settings.options[:marker][:update_messages] = false
        end
        channel_id = @workers.get_channel_id_from_alias(channel_id)
        writer = Post.new
        @status.writing
        @status.message
        lines_array = writer.compose
        writer.check_message_length(lines_array)
        @view.clear_screen
        @status.posting
        if options[:poster]
          settings = options.dup
          options = NowWatching.new.get_poster(settings[:poster], settings)
        end
        resp = writer.message({options: options, id: channel_id, text: lines_array.join("\n")})
        if Settings.options[:marker][:update_messages] == true
          if resp['meta']['code'] == 200
            data = resp['data']
            name = "channel:#{data['channel_id']}"
            Databases.pagination_insert(name, data['id'])
            marked = @api.update_marker(name, data['id'])
            updated = JSON.parse(marked)
            if updated['meta']['code'] != 200
              raise "couldn't update channel #{data['channel_id']} as read"
            end
          end
        end
        FileOps.save_message(resp) if Settings.options[:backup][:sent_messages]
        @view.clear_screen
        @status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [channel_id, options]})
      end
    end

    def nowplaying(options = {})
      np = NowPlaying.new(@api, @view, @workers)
      options[:lastfm] ? np.lastfm(options) : np.itunes(options)
    end

    def nowwatching(args, options = {})
      begin
        if args.empty?
          @status.error_missing_title
          exit
        end
        nw = NowWatching.new(@view)
        nw.post(args, options)
      rescue ArgumentError => e
        @status.no_movie
      rescue => e
        @status.wtf
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    def tvshow(args, options = {})
      begin
        if args.empty?
          @status.error_missing_title
          exit
        end
        client = TvShow.new
        show_obj = if options[:alt]
          client.find_alt(args.join(' '))
        else
          client.find(args.join(' '))
        end
        candidate = client.create_details(show_obj)
        candidate.ok ? candidate.post(options) : candidate.cancel
      rescue => e
        @status.wtf
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    def random_posts(options)
      begin
        @stream.random_posts(options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [@max_id, @random_post_id, @resp, options]})
      end
    end

    def version
      begin
        @status.version
      rescue => e
        Errors.global_error({error: e, caller: caller, data: []})
      end
    end

    private

    def save_and_view(resp)
      FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
      @view.clear_screen
      @status.yourpost
      puts "\n\n"
      @view.show_posted(resp)
    end

  end
end
