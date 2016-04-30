# encoding: utf-8
module Ayadn
  class View

    def initialize
      @workers = Workers.new
      @status = Status.new
    end

    def show_cursor
      puts "\e[?25h"
    end

    def hide_cursor
      puts "\e[?25l"
    end

    def show_posts_with_index(data, options = {}, niceranks = {})
      posts, view = build_stream_with_index(data.posts, options, niceranks)
      puts view unless view == ""
      Databases.save_indexed_posts(posts)
    end

    def show_posts(data, options = {}, niceranks = {})
      resp = build_stream_without_index(data.posts, options, niceranks)
      puts resp unless resp == ""
    end

    def show_messages messages
      resp = build_stream_without_index(messages, {}, {})
      puts resp unless resp == ""
    end

    def if_raw what, options
      if options[:raw]
        show_raw(what, options)
        exit
      end
    end

    def show_raw(stream, options = {})
      if stream.is_a? Hash
        show_direct_raw stream
      else
        jj stream.input
      end
    end

    def show_direct_raw(stream, options = {})
      jj stream
    end

    def show_simple_post(post, options = {})
      puts build_stream_without_index(post, options, {})
    end

    def show_posted(resp)
      show_simple_post([PostObject.new(resp['data'])], {})
      puts "\n" if timeline_is_compact
    end

    def show_list_reposted(list, target)
      users_list, table = @workers.build_reposted_list(list, target)
      puts @workers.build_users_list(users_list, table)
      puts "\n"
    end

    def show_list_starred(list, target)
      users_list, table = @workers.build_starred_list(list, target)
      puts @workers.build_users_list(users_list, table)
      puts "\n"
    end

    def show_list_followings(list, target, options = {})
      if options["lastpost"]
        show_list_with_lastpost(list, target, options)
      else
        puts @workers.build_followings_list(list, target, options)
        puts "\n"
      end
    end

    def show_list_followers(list, target, options = {})
      puts @workers.build_followers_list(list, target, options)
      puts "\n"
    end

    def show_list_muted(list, options = {})
      puts @workers.build_muted_list(list, options)
      puts "\n"
    end

    def show_list_blocked(list, options = {})
      puts @workers.build_blocked_list(list, options)
      puts "\n"
    end

    def show_interactions(stream)
      #puts "\n"
      puts build_interactions_stream(stream)
    end

    def show_files_list(list)
      puts build_files_list(list)
    end

    def show_settings
      clear_screen()
      puts Settings.options.to_table
      puts "\n"
    end

    def show_userinfos(user, token, show_ranks = false)
      if timeline_is_compact
        padding = "\n"
        view = "\n"
      else
        padding = "\n\n"
        view = ""
      end

      if !user.name.blank?
        view << "Name\t\t\t".color(:cyan) + user.name.color(color_name)
      else
        view << "Name\t\t\t".color(:cyan) + "(no name)".color(:red)
      end

      view << "#{padding}Username\t\t".color(:cyan) + "@#{user.username}".color(color_username)

      view << "#{padding}ID\t\t\t".color(:cyan) + user.id.color(color_id)

      view << "#{padding}URL\t\t\t".color(:cyan) + user.canonical_url.color(color_link)

      unless user.verified_domain.nil?
        if user.verified_domain =~ (/http/ || /https/)
           domain = user.verified_domain
        else
          domain = "http://#{user.verified_domain}"
        end
        view << "\nVerified domain\t\t".color(:cyan) + domain.color(color_link)
      end


      view << "#{padding}Account creation\t".color(:cyan) + @workers.parsed_time(user.created_at).color(color_excerpt)
      view << "#{padding}TimeZone\t\t".color(:cyan) + user.timezone.color(color_excerpt)
      view << "\nLocale\t\t\t".color(:cyan) + user.locale.color(color_excerpt)

      view << "#{padding}Posts\t\t\t".color(:cyan) + user.counts.posts.to_s.color(color_excerpt)

      view << "#{padding}Following\t\t".color(:cyan) + user.counts.following.to_s.color(color_excerpt)
      view << "\nFollowers\t\t".color(:cyan) + user.counts.followers.to_s.color(color_excerpt)

      if user.username == Settings.config.identity.username && !token.nil?
        view << "#{padding}Storage used\t\t".color(:cyan) + "#{token['storage']['used'].to_filesize}".color(color_excerpt)
        view << "\nStorage available\t".color(:cyan) + "#{token['storage']['available'].to_filesize}".color(color_excerpt)
      end

      unless user.username == Settings.config.identity.username
        if user.you_follow
          view << "#{padding}You follow ".color(:cyan) + "@#{user.username}".color(color_username)
        else
          view << "#{padding}You don't follow ".color(:cyan) + "@#{user.username}".color(color_username)
        end
        if user.follows_you
          view << "\n" + "@#{user.username}".color(color_username) + " follows you".color(:cyan)
        else
          view << "\n" + "@#{user.username}".color(color_username) + " doesn't follow you".color(:cyan)
        end
        if user.you_muted
          view << "\nYou muted " + "@#{user.username}".color(color_username)
        end
        if user.you_blocked
          view << "\nYou blocked " + "@#{user.username}".color(color_username)
        end
      end

      unless user.annotations.empty?
        view << "\n" unless timeline_is_compact
      end
      user.annotations.each do |anno|
        case anno.type
        when "net.app.core.directory.blog"
          view << "\nBlog\t\t\t".color(:cyan) + "#{anno.value['url']}".color(color_link)
        when "net.app.core.directory.twitter"
          view << "\nTwitter\t\t\t".color(:cyan) + "#{anno.value['username']}".color(:green)
        when "com.appnetizens.userinput.birthday"
          view << "\nBirthday\t\t".color(:cyan) + "#{anno.value['birthday']}".color(:green)
        end
      end

      if !user.description.blank?
        mentions = user.description.entities.mentions.map {|m| "@#{m.name}"}
        hashtags = user.description.entities.hashtags.map {|m| m.name}
        view << "#{padding}#{@workers.colorize_text(user.description.text, mentions, hashtags)}\n"
        view << "\n" unless timeline_is_compact
      end

      view << "\n" if timeline_is_compact

      puts view

    end

    def show_channels(stream, options = {})
      view = ""
      bucket = @workers.build_channels(stream, options)

      bucket.reverse.each do |ch|
        if options[:broadcasts]
          next if ch.type != "net.app.core.broadcast"
        end
        if options[:"no-broadcasts"]
          next if ch.type == "net.app.core.broadcast"
        end
        if options[:messages]
          next if ch.type != "net.app.core.pm"
        end
        if options[:"no-messages"]
          next if ch.type == "net.app.core.pm"
        end
        if options[:patter]
          next if ch.type != "net.patter-app.room"
        end
        if options[:"no-patter"]
          next if ch.type == "net.patter-app.room"
        end
        if options[:other]
          case ch.type
          when "net.app.core.pm", "net.app.core.broadcast", "net.patter-app.room"
            next
          end
        end
        if options[:"no-other"]
          next if ch.type != "net.app.core.pm" || ch.type != "net.app.core.broadcast" || ch.type != "net.patter-app.room"
        end
        view << "\n"
        view << "ID: ".color(:cyan)
        view << "#{ch.id}".color(color_id)
        view << "\n"
        ch_alias = Databases.get_alias_from_id(ch.id)
        unless ch_alias.nil?
          view << "Alias: ".color(:cyan)
          view << "#{ch_alias}".color(color_username)
          view << "\n"
        end
        view << "Messages: ".color(:cyan)
        view << "#{ch.num_messages}".color(color_symbols)
        view << "\n"
        if ch.owner
          view << "Owner: ".color(:cyan)
          view << "@#{ch.owner.username}".color(color_username)
          view << "\n"
        end
        unless options[:channels] # unless the request comes from Search
          view << "Writers: ".color(:cyan)
          view << "#{ch.writers}".color(color_name)
          view << "\n"
        end
        view << "Type: ".color(:cyan)
        view << "#{ch.type}".color(color_index)
        view << "\n"
        if ch.type == "net.patter-app.room"
          ann = ch.annotations.select {|a| a.type == "net.patter-app.settings"}
          view << "Name: ".color(:cyan)
          view << "#{ann[0].value['name']}".color(color_link)
          view << "\n"
          view << "Description: ".color(:cyan)
          view << "#{ann[0].value['blurb']}".color(color_username)
          view << "\n"
          ann = ch.annotations.select {|a| a.type == "net.app.core.fallback_url"}
          view << "URL: ".color(:cyan)
          view << "#{ann[0].value['url']}".color(color_link)
          view << "\n"
        end
        if ch.type == "net.app.core.broadcast"
          ann = ch.annotations.select {|a| a.type == "net.app.core.broadcast.metadata"}
          view << "Title: ".color(:cyan)
          view << "#{ann[0].value['title']}".color(color_link)
          view << "\n"
          view << "Description: ".color(:cyan)
          view << "#{ann[0].value['description']}".color(color_username)
          view << "\n"
          ann = ch.annotations.select {|a| a.type == "net.app.core.fallback_url"}
          view << "URL: ".color(:cyan)
          view << "#{ann[0].value['url']}".color(color_link)
          view << "\n"
        end
        unless ch.recent_message.nil?
          unless ch.recent_message.text.nil?
            view << "Most recent message (#{@workers.parsed_time(ch.recent_message.created_at)}): ".color(:cyan)
            view << "\n"
            view << "---\n#{ch.recent_message.text}\n---"
          end
        end
        if ch.type == "net.paste-app.clips"
          ann = ch.recent_message.annotations.select {|a| a.type == "net.paste-app.clip"}
          view << "\n\n"
          view << ann[0].value['content']
          view << "\n"
        end
        view << "\n\n"
      end
      puts view
      unless options[:channels] || options[:id]
        @status.info("info", "your account is currently linked to #{bucket.length} channels", "cyan")
        puts "\n"
      end
    end

    def render(stream, options = {}, niceranks = {})
      unless options[:raw]
        get(stream, options, niceranks)
      else
        show_raw(stream)
      end
    end

    def get(data, options = {}, niceranks = {})
      clear_screen()
      if options[:index]
        show_posts_with_index(data, options, niceranks)
      else
        show_posts(data, options, niceranks)
      end
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    def page msg
      # clear_screen
      puts "\n"
      puts msg
      puts "\n"
    end

    def winsize
      IO.console.winsize
    end

    def show_links(links)
      links.each {|l| puts "#{l}".color(color_link)}
    end

    def all_hashtag_links(stream, hashtag)
      clear_screen()
      @status.info("info", "links from posts containing hashtag '##{hashtag}':", "cyan")
      links = @workers.links_from_posts(stream)
      links.uniq!
      show_links(links)
      @workers.save_links(links, "hashtag", hashtag)
    end

    def all_search_links(stream, words)
      clear_screen()
      @status.info("info", "links from posts containing word(s) '#{words}':", "cyan")
      links = @workers.links_from_posts(stream)
      links.uniq!
      show_links(links)
      @workers.save_links(links, "search", words)
    end

    def all_stars_links(stream)
      clear_screen()
      @status.info("info", "links from your starred posts:", "cyan")
      links = @workers.links_from_posts(stream)
      links.uniq!
      show_links(links)
      @workers.save_links(links, 'starred')
    end

    def infos(stream, token)
      show_userinfos(stream, token, true)
    end

    def downloading(options = {})
      unless options[:raw]
        clear_screen()
        @status.downloading
      end
    end

    def list(what, list, target, options = {})
      clear_screen()
      case what
      when :whoreposted
        show_list_reposted(list, target)
      when :whostarred
        show_list_starred(list, target)
      when :followings
        show_list_followings(list, target, options)
      when :followers
        show_list_followers(list, target, options)
      when :muted
        show_list_muted(list, options)
      when :blocked
        show_list_blocked(list, options)
      end
    end

    def big_separator
      "----------\n\n\n"
    end

    private

    ### list = id => [username, name, bool, bool, int, message]
    def show_list_with_lastpost(list, target, options)
      clear_screen()
      bucket = []
      list.each do |k,v|
        if !v[5].nil?
          bucket << [k, v[0], v[1], v[2], v[3], v[4], PostObject.new(v[5])]
        else
          bucket << [k, v[0], v[1], v[2], v[3], v[4], nil]
        end
      end
      count = bucket.size
      if options[:username]
        bucket.sort_by! { |obj| obj[1] }
      elsif options[:name]
        bucket.sort_by! { |obj| obj[2] }
      elsif options[:posts]
        bucket.sort_by! { |obj| [obj[5], obj[1]] }.reverse!
      elsif options[:date]
        bucket.keep_if { |obj| !obj[6].nil? }
        bucket.sort_by! { |obj| obj[6].created_at }.reverse!
      end
      title = if target == "me"
          "Last post of users you're following".color(:cyan)
        else
          "Last post of users ".color(:cyan) + "#{target}".color(:red) + " is following ".color(:cyan)
        end
      puts "\t#{title}\n\n"
      bucket.each.with_index(1) do |obj,index|
        username = "@#{obj[1]}"
        colored_username = username.color(color_username)
        if obj[6].nil?
          @status.thor.say_status :warning, "user #{colored_username} has no posts, ignored", :red
          newline() 
          next
        end
        date = @workers.parsed_time(obj[6].created_at)
        mentions = @workers.extract_mentions(obj[6])
        hashtags = @workers.extract_hashtags(obj[6])
        text = @workers.colorize_text(obj[6].text, mentions, hashtags)
        total = "(#{obj[5]} posts)"
        name = obj[2].blank? ? "(no name)" : obj[2]
        colored_total = total.color(color_link)
        colored_name = name.color(color_name)
        colored_date = date.color(color_date)
        puts "#{colored_username} #{colored_name} #{colored_date} #{colored_total}\n"
        newline()
        puts text
        unless index == count
          newline()
          puts "----------\n"
          newline()
        else
          puts "\n"
          newline()
        end
      end
    end

    def newline
      puts "\n" unless timeline_is_compact 
    end

    def get_broadcast_alias_from_id(event_id)
      al = Databases.get_alias_from_id(event_id)
      if al.nil? || al.empty?
        return event_id
      else
        return al
      end
    end

    def filter_nicerank posts, options
      if options[:filter] # if this option is true in Action (it's only for global, actually)
        if Settings.options.nicerank.filter
          bucket = []
          posts.each do |post|
            if Settings.options.nicerank.unranked
              next if !post.nicerank # .nicerank is False or Fixnum (yeah...)
            end
            unless !post.nicerank
              next if post.nicerank < Settings.options.nicerank.threshold
              next if post.is_human == 0
            end
            bucket << post
          end
          return bucket
        end
      end
      return posts
    end

    def build_stream_with_index(posts, options, niceranks)
      @view = ""
      posts = filter_nicerank(@workers.build_posts(posts.reverse, niceranks), options)
      posts.each do |post|
        format = "%03d" % post.count
        arrow = arrow_count(options, post)
        count = "#{arrow}#{format}"
        if post.username == Settings.config.identity.username
          @view << count.color(color_index).inverse
        elsif post.mentions.include?(Settings.config.identity.username) && options[:in_mentions].nil?
          @view << count.color(color_mention).inverse
        else
          @view << count.color(color_index)
        end
        @view << ": ".color(color_index)
        @view << build_content(post)
      end
      return posts, @view
    end

    def build_stream_without_index(posts, options, niceranks)
      @view = ""
      posts = filter_nicerank(@workers.build_posts(posts.reverse, niceranks), options)
      posts.each do |post|
        post.id = arrow_id(options, post)
        if post.username == Settings.config.identity.username
          @view << post.id.color(Settings.options.colors.id).inverse + " "
        elsif post.mentions.include?(Settings.config.identity.username) && options[:in_mentions].nil?
          @view << post.id.color(color_mention).inverse + " "
        else
          @view << post.id.color(Settings.options.colors.id) + " "
        end
        @view << build_content(post)
      end
      @view
    end

    def arrow_count options, post
      if options[:reply_to]
        return '⬇︎ ' if options[:reply_to] == post.id
        return '⬆︎ ' if options[:post_id] == post.id
        return ''
      end
      ''
    end

    def arrow_id options, post
      if options[:reply_to]
        return post.id.to_s.prepend('⬇︎ ') if options[:reply_to] == post.id
        return post.id.to_s.prepend('⬆︎ ') if options[:post_id] == post.id
        return post.id.to_s
      end
      post.id.to_s
    end

    def build_interactions_stream(data)
      inter = ""
      data.reverse.each do |event|
        users_array = []
        inter << "#{@workers.parsed_time(event['event_date'])}".color(color_date)
        inter << " => "
        event['users'].each do |u|
          users_array << "@" + u['username']
        end
        case event['action']
          when "broadcast_subscribe"
            broadcast = get_broadcast_alias_from_id(event['objects'][0]['id'])
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "subscribed to your broadcast ".color(:green)
            inter << "#{broadcast}".color(:red)
          when "broadcast_unsubscribe"
            broadcast = get_broadcast_alias_from_id(event['objects'][0]['id'])
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "unsubscribed from your broadcast ".color(:green)
            inter << "#{broadcast}".color(:red)
          when "follow", "unfollow"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}ed you".color(:green)
          when "mute", "unmute"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}d you".color(:green)
          when "star", "unstar"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}red post ".color(:green)
            inter << "#{event['objects'][0]['id']}".color(:red)
          when "repost", "unrepost"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}ed post ".color(:green)
            inter << "#{event['objects'][0]['id']}".color(:red)
          when "reply"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "replied to post ".color(:green)
            inter << "#{event['objects'][0]['id']}".color(:red)
          when "welcome"
            inter << "App.net ".color(:cyan)
            inter << "welcomed ".color(:green)
            inter << "you!".color(:yellow)
        end
        if timeline_is_compact
          inter << "\n"
        else  
          inter << "\n\n"
        end
      end
      inter
    end

    def build_files_list(list)
      data = list.reverse
      view = "\n"
      data.each do |file|
        view << "ID\t\t".color(:cyan)
        view << file['id'].color(color_id)
        view << "\n"
        view << "Name\t\t".color(:cyan)
        view << file['name'].color(color_name)
        view << "\n"
        view << "Kind\t\t".color(:cyan)
        view << file['kind'].color(color_username)
        view << " (#{file['mime_type']})".color(color_username) if file['mime_type']
        if file['image_info']
          view << "\n"
          view << "Dimensions\t".color(:cyan)
          view << "#{file['image_info']['width']} x #{file['image_info']['height']}".color(color_username)
        end
        view << "\n"
        view << "Size\t\t".color(:cyan)
        view << file['size'].to_filesize.color(:yellow)
        view << "\n"
        view << "Date\t\t".color(:cyan)
        view << @workers.parsed_time(file['created_at']).color(:green)
        view << "\n"
        view << "Source\t\t".color(:cyan)
        view << file['source']['name'].color(color_source)
        view << "\n"
        view << "State\t\t".color(:cyan)
        if file['public']
          view << "Public".color(color_id)
          view << "\n"
          view << "Link\t\t".color(:cyan)
          view << file['url_short'].color(color_link)
        else
          view << "Private".color(color_id)
        end

        view << "\n\n"
      end
      view
    end

    def build_content(post)
      view = ""
      view << build_header(post)
      view << "\n" unless timeline_is_compact
      view << post.text
      view << "\n" unless timeline_is_compact
      if post.has_checkins
        view << build_checkins(post)
        view << "\n" unless timeline_is_compact
      end
      unless post.links.empty?
        view << "\n"
        post.links.each do |link|
          view << link.color(color_link)
          view << "\n"
        end
      end
      if timeline_is_compact
        if post.links.empty?
          view << "\n"
        else
          view
        end
      else
        view << "\n\n"
      end
    end

    def build_header(post)
      header = ""
      header << post.handle.color(color_username)
      if Settings.options.timeline.name
        header << " "
        header << post.name.color(color_name)
      end
      if Settings.options.timeline.date
        header << " "
        if !Settings.global.scrolling
          header << post.date.color(color_date)
        else
          if !Settings.options.scroll.date
            header << post.date_short.color(color_date)
          else
            header << post.date.color(color_date)
          end
        end
      end
      if Settings.options.timeline.source
        header << " "
        header << "[#{post.source_name}]".color(color_source)
      end
      if Settings.options.timeline.symbols
        header << " <".color(color_symbols) if post.is_reply
        header << " #{post.num_stars}*".color(color_symbols) if post.is_starred
        header << " #{post.num_reposts}x".color(color_symbols) if post.num_reposts > 0
        header << " >".color(color_symbols) if post.num_replies > 0
      end
      header << "\n"
    end

    def build_checkins(post)
      unless post.checkins['name'].nil?
        num_dots = post.checkins['name'].length
      else
        num_dots = 10
      end
      if timeline_is_compact
        hd = "\n"
      else
        hd = (".".color(color_dots)) * num_dots
        hd << "\n"
      end
      formatted = { header: hd }
      post.checkins.each do |key, val|
          formatted[key] = val
      end

      formatted[:name] = "" if formatted[:name].nil?
      chk = formatted[:header]

      unless formatted[:name] == ""
        chk << formatted[:name].color(color_dots)
        chk << "\n"
      end
      unless formatted[:title].blank? || formatted[:title] == formatted[:name]
        chk << formatted[:title]
        chk << "\n"
      end
      unless formatted[:address].blank?
        chk << formatted[:address]
        chk << "\n"
      end

      unless formatted[:address_extended].nil?
        chk << formatted[:address_extended]
        chk << "\n"
      end
      unless formatted[:postcode].blank?
        unless formatted[:locality].nil?
          chk << "#{formatted[:postcode]}, #{formatted[:locality]}"
        else
          chk << "#{formatted[:postcode]}"
        end
        chk << "\n"
      else
        unless formatted[:locality].nil?
          chk << "#{formatted[:locality]}"
          chk << "\n"
        end
      end

      formatted[:country_code].nil? ? cc = "" : cc = formatted[:country_code]

      if formatted[:region].nil?
        unless cc == ""
          chk << "(#{cc})".upcase
          chk << "\n"
        end
      else
        unless cc == ""
          chk << "#{formatted[:region]} (#{cc.upcase})"
        else
          chk << "#{formatted[:region]}"
        end
        chk << "\n"
      end

      unless formatted[:website].nil?
        chk << formatted[:website]
        chk << "\n"
      end
      unless formatted[:telephone].nil?
        chk << formatted[:telephone]
        chk << "\n"
      end
      unless formatted[:categories].nil?
        chk << formatted[:categories]
        chk << "\n"
      end

      chk.chomp
    end

    private

    def color_username
      Settings.options.colors.username
    end

    def color_name
      Settings.options.colors.name
    end

    def color_link
      Settings.options.colors.link
    end

    def color_date
      Settings.options.colors.date
    end

    def color_id
      Settings.options.colors.id
    end

    def color_excerpt
      Settings.options.colors.excerpt
    end

    def color_symbols
      Settings.options.colors.symbols
    end

    def color_index
      Settings.options.colors.index
    end

    def color_mention
      Settings.options.colors.mentions
    end

    def color_source
      Settings.options.colors.source
    end

    def color_dots
      Settings.options.colors.dots
    end

    def timeline_is_compact
      Settings.options.timeline.compact
    end

  end
end
