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
      at_exit { Databases.close_all }
    end

    def unified(options)
      begin
        doing(options)
        stream = @api.get_unified(options)
        stop_if_no_new_posts(stream, options, 'unified')
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).unified(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def checkins(options)
      begin
        doing(options)
        stream = @api.get_checkins(options)
        stop_if_no_new_posts(stream, options, 'explore:checkins')
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).checkins(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def global(settings)
      begin
        options = settings.dup
        options[:filter] = nicerank_true()
        doing(options)
        stream = @api.get_global(options)
        niceranks = NiceRank.new.get_ranks(stream)
        stop_if_no_new_posts(stream, options, 'global')
        Databases.save_max_id(stream)
        render_view(stream, options, niceranks)
        Scroll.new(@api, @view).global(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def trending(options)
      begin
        doing(options)
        stream = @api.get_trending(options)
        stop_if_no_new_posts(stream, options, 'explore:trending')
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).trending(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def photos(options)
      begin
        doing(options)
        stream = @api.get_photos(options)
        stop_if_no_new_posts(stream, options, 'explore:photos')
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).photos(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def conversations(options)
      begin
        doing(options)
        stream = @api.get_conversations(options)
        stop_if_no_new_posts(stream, options, 'explore:replies')
        Databases.save_max_id(stream)
        render_view(stream, options)
        Scroll.new(@api, @view).replies(options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def mentions(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        stream = @api.get_mentions(username, options)
        stop_if_no_user(stream, username)
        Databases.save_max_id(stream)
        options = options.dup
        options[:in_mentions] = true
        stop_if_no_data(stream, 'mentions')
        render_view(stream, options)
        Scroll.new(@api, @view).mentions(username, options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def posts(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        stream = @api.get_posts(username, options)
        stop_if_no_user(stream, username)
        Databases.save_max_id(stream)
        stop_if_no_data(stream, 'mentions')
        render_view(stream, options)
        Scroll.new(@api, @view).posts(username, options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def interactions(options)
      begin
        doing(options)
        stream = @api.get_interactions
        if_raw_show(stream, options)
        @view.clear_screen
        @view.show_interactions(stream['data'])
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def whatstarred(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        stream = @api.get_whatstarred(username, options)
        stop_if_no_user(stream, username)
        stop_if_no_data(stream, 'whatstarred')
        options[:extract] ? view_all_stars_links(stream) : render_view(stream, options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def whoreposted(post_id, options)
      begin
        stop_if_bad_post_id(post_id)
        doing(options)
        details = @api.get_details(post_id, options)
        stop_if_404(details, post_id)
        id = get_original_id(post_id, details)
        list = @api.get_whoreposted(id)
        if_raw_show(list, options)
        unless list['data'].empty?
          get_list(:whoreposted, list['data'], post_id)
        else
          puts Status.nobody_reposted
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def whostarred(post_id, options)
      begin
        stop_if_bad_post_id(post_id)
        doing(options)
        details = @api.get_details(post_id, options)
        stop_if_404(details, post_id)
        id = get_original_id(post_id, details)
        list = @api.get_whostarred(id)
        if_raw_show(list, options)
        unless list['data'].empty?
          get_list(:whostarred, list['data'], id)
        else
          puts Status.nobody_starred
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, id, options]})
      end
    end

    def convo(post_id, options)
      begin
        stop_if_bad_post_id(post_id)
        doing(options)
        details = @api.get_details(post_id, options)
        stop_if_404(details, post_id)
        id = get_original_id(post_id, details)
        stream = get_convo id, options
        Databases.pagination["replies:#{id}"] = stream['meta']['max_id']
        options = options.dup
        unless details['data']['reply_to'].nil?
          options[:reply_to] = details['data']['reply_to'].to_i
        end
        options[:post_id] = post_id.to_i
        render_view(stream, options)
        Scroll.new(@api, @view).convo(id, options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, id, options]})
      end
    end

    def get_convo id, options
      stream = @api.get_convo(id, options)
      stop_if_no_post(stream, id)
      stream
    end

    def delete(post_id)
      begin
        stop_if_bad_post_id(post_id)
        print Status.deleting_post(post_id)
        check_has_been_deleted(post_id, @api.delete_post(post_id))
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def delete_m(args)
      begin
        missing_message_id unless args.length == 2
        message_id = args[1]
        missing_message_id unless message_id.is_integer?
        channel_id = get_channel_id_from_alias(args[0])
        print Status.deleting_message(message_id)
        resp = @api.delete_message(channel_id, message_id)
        check_message_has_been_deleted(message_id, resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [message_id]})
      end
    end

    def unfollow(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.unfollowing(users.join(','))
        users.each do |user|
          resp = @api.unfollow(user)
          check_has_been_unfollowed(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def follow(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.following(users.join(','))
        users.each do |user|
          resp = @api.follow(user)
          check_has_been_followed(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def unmute(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.unmuting(users.join(','))
        users.each do |user|
          resp = @api.unmute(user)
          check_has_been_unmuted(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def mute(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.muting(users.join(','))
        users.each do |user|
          resp = @api.mute(user)
          check_has_been_muted(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def unblock(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.unblocking(users.join(','))
        users.each do |user|
          resp = @api.unblock(user)
          check_has_been_unblocked(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def block(usernames)
      begin
        stop_if_no_username(usernames)
        users = all_but_me(usernames)
        puts Status.blocking(users.join(','))
        users.each do |user|
          resp = @api.block(user)
          check_has_been_blocked(user, resp)
          sleep 1 unless users.length == 1
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [usernames]})
      end
    end

    def repost(post_id)
      begin
        stop_if_bad_post_id(post_id)
        puts Status.reposting(post_id)
        resp = @api.get_details(post_id)
        check_if_already_reposted(resp)
        id = get_original_id(post_id, resp)
        check_has_been_reposted(id, @api.repost(id))
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, id]})
      end
    end

    def unrepost(post_id)
      begin
        stop_if_bad_post_id(post_id)
        puts Status.unreposting(post_id)
        if @api.get_details(post_id)['data']['you_reposted']
          check_has_been_unreposted(post_id, @api.unrepost(post_id))
        else
          puts Status.not_your_repost
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def unstar(post_id)
      begin
        stop_if_bad_post_id(post_id)
        puts Status.unstarring(post_id)
        resp = @api.get_details(post_id)
        id = get_original_id(post_id, resp)
        resp = @api.get_details(id)
        if resp['data']['you_starred']
          check_has_been_unstarred(id, @api.unstar(id))
        else
          puts Status.not_your_starred
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def star(post_id)
      begin
        stop_if_bad_post_id(post_id)
        puts Status.starring(post_id)
        resp = @api.get_details(post_id)
        check_if_already_starred(resp)
        id = get_original_id(post_id, resp)
        check_has_been_starred(id, @api.star(id))
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id]})
      end
    end

    def hashtag(hashtag, options)
      begin
        doing(options)
        stream = @api.get_hashtag(hashtag)
        stop_if_no_data(stream, 'hashtag')
        if options[:extract]
          view_all_hashtag_links(stream, hashtag)
        else
          render_view(stream, options)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [hashtag, options]})
      end
    end

    def search(words, options)
      begin
        doing(options)
        stream = if options[:users]
          @api.search_users words, options
        elsif options[:annotations]
          @api.search_annotations words, options
        elsif options[:channels]
          splitted = splitter_all words
          @api.search_channels splitted.join(','), options
        elsif options[:messages]
          words = words.split(',')
          channel_id = get_channel_id_from_alias(words[0])
          words.shift
          splitted = splitter_all words.join(' ')
          @api.search_messages channel_id, splitted.join(','), options
        else
          splitted = splitter_all words
          @api.get_search splitted.join(','), options
        end
        stop_if_no_data(stream, 'search')
        if options[:users]
          stream['data'].sort_by! {|obj| obj['counts']['followers']}
          stream['data'].each do |obj|
            puts @view.big_separator
            @view.show_userinfos(obj, nil, false)
          end
        elsif options[:channels]
          @view.show_channels stream, options
        else
          if options[:extract]
            view_all_search_links(stream, words)
          else
            render_view(stream, options)
          end
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [words, options]})
      end
    end

    def followings(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        if_raw_list(username, :followings, options)
        list = @api.get_followings(username)
        auto_save_followings(list)
        no_data('followings') if list.empty?
        get_list(:followings, list, username)
        Databases.add_to_users_db_from_list(list)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def followers(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        if_raw_list(username, :followers, options)
        list = @api.get_followers(username)
        auto_save_followers(list)
        no_data('followers') if list.empty?
        get_list(:followers, list, username)
        Databases.add_to_users_db_from_list(list)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def muted(options)
      begin
        doing(options)
        if_raw_list(nil, :muted, options)
        list = @api.get_muted
        auto_save_muted(list)
        no_data('muted') if list.empty?
        get_list(:muted, list, nil)
        Databases.add_to_users_db_from_list(list)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def blocked(options)
      begin
        doing(options)
        if_raw_list(nil, :blocked, options)
        list = @api.get_blocked
        no_data('blocked') if list.empty?
        get_list(:blocked, list, nil)
        Databases.add_to_users_db_from_list(list)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def view_settings(options)
      begin
        options[:raw] ? (puts Settings.options.to_json) : @view.show_settings
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def userinfo(username, options)
      begin
        stop_if_no_username(username)
        username = add_arobase(username)
        doing(options)
        if options[:raw]
          resp = @api.get_user(username)
          @view.show_raw(resp, options)
          exit
        end
        stream = @api.get_user(username)
        stop_if_no_user(stream, username)
        same_username?(stream) ? token = @api.get_token_info['data'] : token = nil
        get_infos(stream['data'], token)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
      end
    end

    def postinfo(post_id, options)
      begin
        stop_if_bad_post_id(post_id)
        doing(options)
        if options[:raw]
          details = @api.get_details(post_id, options)
          @view.show_raw(details, options)
          exit
        end
        @view.clear_screen
        response = @api.get_details(post_id, options)
        stop_if_no_post(response, post_id)
        resp = response['data']
        response = @api.get_user("@#{resp['user']['username']}")
        stop_if_no_user(response, response['data']['username'])
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
        doing(options)
        if options[:raw]
          @view.show_raw(@api.get_files_list(options), options)
          exit
        end
        list = @api.get_files_list(options)
        @view.clear_screen
        list.empty? ? no_data('files') : @view.show_files_list(list)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def download(file_id)
      begin
        file = @api.get_file(file_id)['data']
        FileOps.download_url(file['name'], file['url'])
        puts Status.downloaded(file['name'])
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [file_id, file['url']]})
      end
    end

    def channels
      begin
        doing()
        resp = @api.get_channels
        @view.clear_screen
        @view.show_channels(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [resp['meta']]})
      end
    end

    def messages(channel_id, options)
      begin
        channel_id = get_channel_id_from_alias(channel_id)
        doing(options)
        resp = @api.get_messages(channel_id, options)
        stop_if_no_new_posts(resp, options, "channel:#{channel_id}")
        Databases.save_max_id(resp)
        if_raw_show(resp, options)
        stop_if_no_data(resp, 'messages')
        render_view(resp, options)
        Scroll.new(@api, @view).messages(channel_id, options) if options[:scroll]
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [channel_id, options]})
      end
    end

    def pin(post_id, usertags)
      require 'pinboard'
      require 'base64'
      begin
        stop_if_bad_post_id(post_id)
        doing()
        resp = get_data_from_response(@api.get_details(post_id))
        @view.clear_screen
        links = Workers.new.extract_links(resp)
        resp['text'].nil? ? text = "" : text = resp['text']
        usertags << "ADN"
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
        bookmark = maker.new(credentials[0], credentials[1], resp['canonical_url'], usertags.join(","), post_text, links[0])
        puts Status.saving_pin
        pinner.pin(bookmark)
        puts Status.done
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, usertags]})
      end
    end

    def auto(options)
      begin
        @view.clear_screen
        puts Status.auto
        Post.new.auto_readline
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      end
    end

    def post(args, options)
      begin
        writer = Post.new
        @view.clear_screen
        if options['embed']
          embed = options['embed']
          text = args.join(" ")
          puts Status.uploading(embed)
          resp = writer.send_embedded(text, FileOps.make_paths(embed))
        else
          puts Status.posting
          resp = writer.post(args)
        end
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args, options]})
      end
    end

    def write(options)
      begin
        files = FileOps.make_paths(options['embed']) if options['embed']
        writer = Post.new
        puts Status.writing
        puts Status.post
        lines_array = writer.compose
        writer.check_post_length(lines_array)
        text = lines_array.join("\n")
        if options['embed']
          @view.clear_screen
          puts Status.uploading(options['embed'])
          resp = writer.send_embedded(text, files)
        else
          resp = writer.send_post(text)
        end
        @view.clear_screen
        puts Status.posting
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.yourpost
        @view.show_posted(resp)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [text, options]})
      end
    end

    def pmess(username, options = {})
    	begin
        files = FileOps.make_paths(options['embed']) if options['embed']
        stop_if_no_username(username)
        username = [add_arobase(username)]
    		messenger = Post.new
        puts Status.message_from(username)
    		puts Status.message
    		lines_array = messenger.compose
    		messenger.check_message_length(lines_array)
        text = lines_array.join("\n")
    		@view.clear_screen
        if options['embed']
          puts Status.uploading(options['embed'])
          resp = messenger.send_pm_embedded(username, text, files)
        else
          puts Status.posting
          resp = messenger.send_pm(username, text)
        end
        FileOps.save_message(resp) if Settings.options[:backup][:auto_save_sent_messages]
    		@view.clear_screen
    		puts Status.yourmessage
    		@view.show_posted(resp)
    	rescue => e
        Errors.global_error({error: e, caller: caller, data: [username, options]})
    	end
    end

    def send_to_channel(channel_id)
    	begin
        channel_id = get_channel_id_from_alias(channel_id)
  			messenger = Post.new
        puts Status.writing
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
        Errors.global_error({error: e, caller: caller, data: [channel_id]})
    	end
    end

    def reply(post_id, options = {})
      begin
        files = FileOps.make_paths(options['embed']) if options['embed']
        post_id = get_real_post_id(post_id)
      	puts Status.replying_to(post_id)
      	replied_to = @api.get_details(post_id)
        stop_if_no_post(replied_to, post_id)
        post_id = get_original_id(post_id, replied_to)
        if replied_to['data']['repost_of']
          if post_id == replied_to['data']['repost_of']['id']
            replied_to = @api.get_details(post_id)
            stop_if_no_post(replied_to, post_id)
          end
        end
        poster = Post.new
        puts Status.writing
        puts Status.reply
        lines_array = poster.compose
        poster.check_post_length(lines_array)
        @view.clear_screen
        reply = poster.reply(lines_array.join("\n"), Workers.new.build_posts([replied_to['data']]))
        if options['embed']
          puts Status.uploading(options['embed'])
          resp = poster.send_reply_embedded(reply, post_id, files)
        else
          puts Status.posting
          resp = poster.send_reply(reply, post_id)
        end
        FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
        @view.clear_screen
        puts Status.done

        options = options.dup
        unless resp['data']['reply_to'].nil?
          options[:reply_to] = resp['data']['reply_to'].to_i
        end
        options[:post_id] = resp['data']['id'].to_i

        render_view(@api.get_convo(post_id), options)
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [post_id, options]})
      end
    end

    def nowplaying(options = {})
      options['lastfm'] ? np_lastfm(options) : np_itunes(options)
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
        Errors.global_error({error: e, caller: caller, data: [@max_id, @random_post_id, @resp, options]})
      end
    end

    def version
      begin
        puts "\nAYADN\n".color(:red)
        puts "Version:\t".color(:cyan) + "#{VERSION}\n".color(:green)
        puts "Changelog:\t".color(:cyan) + "https://github.com/ericdke/na/blob/master/CHANGELOG.md\n".color(Settings.options[:colors][:link])
        puts "Docs:\t\t".color(:cyan) + "http://ayadn-app.net/doc/".color(Settings.options[:colors][:link])
        puts "\n"
      rescue => e
        Errors.global_error({error: e, caller: caller, data: []})
      end
    end

    private

    def if_raw_list username, what, options
      if options[:raw]
        @view.show_raw(@api.get_raw_list(username, what), options)
        exit
      end
    end

    def if_raw_show what, options
      if options[:raw]
        @view.show_raw(what, options)
        exit
      end
    end

    def all_but_me usernames
      all_but_me = usernames.select {|user| user != 'me'}
      Workers.at(all_but_me)
    end

    def np_lastfm options
      require 'rss'
      begin
        user = Settings.options[:nowplaying][:lastfm] || create_lastfm_user()
        puts Status.fetching_from('Last.fm')
        artist, track = get_lastfm_track_infos(user)
        puts Status.itunes_store
        store = lastfm_istore_request(artist, track) unless options['no_url']
        text_to_post = "#nowplaying\n \nTitle: ‘#{track}’\nArtist: #{artist}"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [store, options]})
      end
    end

    def get_lastfm_track_infos user
      begin
        url = "http://ws.audioscrobbler.com/2.0/user/#{user}/recenttracks.rss"
        feed = RSS::Parser.parse(CNX.download(url))
        lfm = feed.items[0].title.split(' – ')
        return lfm[0], lfm[1]
      rescue Interrupt
        abort(Status.canceled)
      end
    end

    def np_itunes options
      begin
        abort(Status.error_only_osx) unless Settings.config[:platform] =~ /darwin/
        puts Status.fetching_from('iTunes')
        itunes = get_itunes_track_infos()
        itunes.each {|el| abort(Status.empty_fields) if el.length == 0}
        puts Status.itunes_store
        store = itunes_istore_request(itunes) unless options['no_url']
        text_to_post = "#nowplaying\n \nTitle: ‘#{itunes.track}’\nArtist: #{itunes.artist}\nfrom ‘#{itunes.album}’"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [itunes, store, options]})
      end
    end

    def post_nowplaying text_to_post, store, options
      begin
        @view.clear_screen
        puts Status.writing
        show_nowplaying("\n#{text_to_post}", options, store)
        unless options['no_url'] || store.nil?
          text_to_post += "\n \n[iTunes Store](#{store['link']})"
        end
        abort(Status.canceled) unless STDIN.getch == ("y" || "Y")
        puts "\n#{Status.yourpost}"
        unless store.nil? || options['no_url']
          visible, track, artwork, artwork_thumb, link, artist = true, store['track'], store['artwork'], store['artwork_thumb'], store['link'], store['artist']
        else
          visible, track, artwork, artwork_thumb, link, artist = false
        end
        if options['lastfm']
          source = 'Last.fm'
        else
          source = 'iTunes'
        end
        dic = {
          'text' => text_to_post,
          'title' => track,
          'artist' => artist,
          'artwork' => artwork,
          'artwork_thumb' => artwork_thumb,
          'width' => 1200,
          'height' => 1200,
          'width_thumb' => 200,
          'height_thumb' => 200,
          'link' => link,
          'source' => source,
          'visible' => visible
        }
        @view.show_posted(Post.new.send_nowplaying(dic))
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [dic, store, options]})
      end
    end

    def ask_lastfm_user
      puts "\nPlease enter your Last.fm username:\n".color(:cyan)
      begin
        STDIN.gets.chomp!
      rescue Interrupt
        abort(Status.canceled)
      end
    end

    def create_lastfm_user
      Settings.options[:nowplaying][:lastfm] = ask_lastfm_user()
      Settings.save_config
      return Settings.options[:nowplaying][:lastfm]
    end

    def itunes_istore_request itunes
      infos = itunes_reg([itunes.artist, itunes.track, itunes.album])
      itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&term=#{infos[2]}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, itunes.artist, itunes.track)
    end

    def lastfm_istore_request artist, track
      infos = itunes_reg([artist, track])
      itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, artist, track)
    end

    def get_itunes_store url, artist, track
      results = JSON.load(CNX.download(URI.escape(url)))['results']
      unless results.empty? || results.nil?

        resp = results.select {|obj| obj['artistName'] == artist && obj['trackName'] == track}
        candidate = resp[0] || results[0]

        return {
          'code' => 200,
          'artist' => candidate['artistName'],
          'track' => candidate['trackName'],
          'preview' => candidate['previewUrl'],
          'link' => candidate['collectionViewUrl'],
          'artwork' => candidate['artworkUrl100'].gsub('100x100', '1200x1200'),
          'artwork_thumb' => candidate['artworkUrl100'].gsub('100x100', '600x600'),
          'request' => url,
          'results' => results
        }
      else
        return {
          'code' => 404,
          'request' => url
        }
      end
    end

    def itunes_reg arr_of_itunes
      regex_exotics = /[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/
      arr_of_itunes.map do |itune|
        itune.gsub(regex_exotics, ' ').split(' ').join('+')
      end
    end

    def get_itunes_track_infos
      track = `osascript -e 'tell application "iTunes"' -e 'set trackName to name of current track' -e 'return trackName' -e 'end tell'`
      if track.empty?
        puts Status.no_itunes
        Errors.warn "Nowplaying canceled: unable to get info from iTunes."
        exit
      end
      album = `osascript -e 'tell application "iTunes"' -e 'set trackAlbum to album of current track' -e 'return trackAlbum' -e 'end tell'`
      artist = `osascript -e 'tell application "iTunes"' -e 'set trackArtist to artist of current track' -e 'return trackArtist' -e 'end tell'`
      maker = Struct.new(:artist, :album, :track)
      maker.new(artist.chomp!, album.chomp!, track.chomp!)
    end

    def show_nowplaying(text, options, store)
      puts "\nYour post:\n".color(:cyan)
      if options['no_url'] || store['code'] != 200
        puts text + "\n\n\n"
      else
        puts text + "\n\n\nThe iTunes Store thinks this track is: ".color(:green) + "'#{store['track']}'".color(:magenta) + " by ".color(:green) + "'#{store['artist']}'".color(:magenta) + ".\n\nAyadn will use these elements to insert album artwork and a link to the track.\n\n".color(:green)
      end
      puts "Is it ok? (y/N) ".color(:yellow)
    end

    def nicerank_true
      return true if Settings.options[:nicerank][:filter] == true
    end

    def stop_if_bad_post_id post_id
      missing_post_id() unless post_id.is_integer?
    end

    def stop_if_no_data stream, target
      if stream['data'].empty?
        Errors.warn "In action/#{target}: no data"
        abort(Status.empty_list)
      end
    end

    def stop_if_404 stream, post_id
      if stream['meta']['code'] == 404
        abort(Status.post_404(post_id))
      end
    end

    def add_arobase username
      Workers.add_arobase_if_missing(username)
    end

    def stop_if_no_new_posts stream, options, title
      if options[:new]
        unless Databases.has_new?(stream, title)
          no_new_posts()
        end
      end
    end

    def splitter_all words
      [words].collect {|w| w.split(' ')}
    end

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

    def check_message_has_been_deleted(message_id, resp)
      if resp['meta']['code'] == 200
        puts Status.deleted_m(message_id)
        Logs.rec.info "Deleted message #{message_id}."
      else
        whine(Status.not_deleted(message_id), resp)
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

    def stop_if_no_user stream, username
      if stream['meta']['code'] == 404
        puts Status.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end

    def stop_if_no_post stream, post_id
      if stream['meta']['code'] == 404
        puts Status.post_404(post_id)
        Errors.info("Impossible to find #{post_id}")
        exit
      end
    end

    def length_of_index
      Databases.get_index_length
    end

    def get_post_from_index id
      Databases.get_post_from_index id
    end

    def get_real_post_id post_id
      id = post_id.to_i
      if id > 0 && id <= length_of_index
        resp = get_post_from_index(id)
        post_id = resp[:id]
      end
      post_id
    end

    def render_view(stream, options = {}, niceranks = {})
      unless options[:raw]
        get_view(stream['data'], options, niceranks)
      else
        @view.show_raw(stream)
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

    def get_view(stream, options = {}, niceranks = {})
      @view.clear_screen
      if options[:index]
        @view.show_posts_with_index(stream, options, niceranks)
      else
        @view.show_posts(stream, options, niceranks)
      end
    end

    def get_simple_view(stream)
      @view.clear_screen
      @view.show_simple_stream(stream)
    end

    def get_infos(stream, token)
      @view.clear_screen
      @view.show_userinfos(stream, token, true)
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
          puts Status.no_alias
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

    def stop_if_no_username username
      if username.empty?
        puts Status.error_missing_username
        exit
      end
    end

    def missing_post_id
      puts Status.error_missing_post_id
      exit
    end

    def missing_message_id
      puts Status.error_missing_message_id
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

    def countdown(wait)
      wait.downto(1) do |i|
        print "\r#{sprintf("%02d", i)} sec... QUIT WITH [CTRL+C]".color(:cyan)
        sleep 1
      end
    end

    def links_from_posts(stream)
      links = []
      worker = Workers.new
      stream['data'].each do |post|
        from = worker.extract_links(post)
        from.each {|l| links << l}
      end
      links.uniq!
      links
    end

    def show_links(links)
      links.each {|l| puts "#{l}\n".color(Settings.options[:colors][:link])}
    end

    def view_all_hashtag_links(stream, hashtag)
      @view.clear_screen
      puts "Links from posts containing hashtag '##{hashtag}': \n".color(:cyan)
      show_links(links_from_posts(stream))
    end

    def view_all_search_links(stream, words)
      @view.clear_screen
      puts "Links from posts containing word(s) '#{words}': \n".color(:cyan)
      show_links(links_from_posts(stream))
    end

    def view_all_stars_links(stream)
      @view.clear_screen
      puts "Links from your starred posts: \n".color(:cyan)
      show_links(links_from_posts(stream))
    end

    def self.quit msg
      puts msg
      exit
    end

  end
end
