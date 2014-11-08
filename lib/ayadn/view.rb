# encoding: utf-8
module Ayadn
  class View

    def initialize
      @workers = Workers.new
      @thor = Thor::Shell::Basic.new
      @status = Status.new
    end

    def show_cursor
      puts "\e[?25h"
    end

    def hide_cursor
      puts "\e[?25l"
    end

    def show_posts_with_index(data, options = {}, niceranks = {})
      posts, view = build_stream_with_index(data, options, niceranks)
      puts view unless view == ""
      Databases.save_indexed_posts(posts)
    end

    def show_posts(data, options = {}, niceranks = {})
      resp = build_stream_without_index(data, options, niceranks)
      puts resp unless resp == ""
    end

    def if_raw what, options
      if options[:raw]
        show_raw(what, options)
        exit
      end
    end

    def show_raw(stream, options = {})
      #puts stream.to_json
      jj stream
    end

    def show_simple_post(post, options = {})
      puts build_stream_without_index(post, options, {})
    end

    def show_posted(resp)
      show_simple_post([resp['data']], {})
      puts "\n" if Settings.options[:timeline][:compact]
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

    def show_list_followings(list, target)
      puts @workers.build_followings_list(list, target)
      puts "\n"
    end

    def show_list_followers(list, target)
      puts @workers.build_followers_list(list, target)
      puts "\n"
    end

    def show_list_muted(list)
      puts @workers.build_muted_list(list)
      puts "\n"
    end

    def show_list_blocked(list)
      puts @workers.build_blocked_list(list)
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
      table = Terminal::Table.new do |t|
        t.style = { :width => Settings.options[:formats][:table][:width], border_x: ' ', border_i: ' ', border_y: ' ' }
        t.title = "Current Ayadn settings".color(:cyan)
        t.headings = [ "Category".color(:red), "Parameter".color(:red), "Value(s)".color(:red) ]
        @iter = 0
        opts = Settings.options.dup
        opts.each do |k,v|
          v.each do |x,y|
            t << :separator if @iter >= 1 && Settings.options[:timeline][:compact] == false
            unless y.is_a?(Hash)
              t << [ k.to_s.color(:cyan), x.to_s.color(:yellow), y.to_s.color(:green) ]
            else
              y.each do |c|
                t << [ k.to_s.color(:cyan), x.to_s.color(:yellow), "#{c[0]} = #{c[1]}".color(:green) ]
              end
            end
            @iter += 1
          end
        end
      end
      clear_screen()
      puts table
    end

    def show_userinfos(content, token, show_ranks = false)
      Settings.options[:timeline][:compact] == true ? padding = "\n" : padding = "\n\n"

      if content['name']
        view = "Name\t\t\t".color(:cyan) + content['name'].color(Settings.options[:colors][:name])
      else
        view = "Name\t\t\t".color(:cyan) + "(no name)".color(:red)
      end

      view << "#{padding}Username\t\t".color(:cyan) + "@#{content['username']}".color(Settings.options[:colors][:id])

      view << "#{padding}ID\t\t\t".color(:cyan) + content['id'].color(Settings.options[:colors][:username])

      view << "#{padding}URL\t\t\t".color(:cyan) + content['canonical_url'].color(Settings.options[:colors][:link])

      unless content['verified_domain'].nil?
        if content['verified_domain'] =~ (/http/ || /https/)
           domain = content['verified_domain']
        else
          domain = "http://#{content['verified_domain']}"
        end
        view << "\nVerified domain\t\t".color(:cyan) + domain.color(Settings.options[:colors][:link])
      end


      view << "#{padding}Account creation\t".color(:cyan) + @workers.parsed_time(content['created_at']).color(:green)
      view << "#{padding}TimeZone\t\t".color(:cyan) + content['timezone'].color(:green)
      view << "\nLocale\t\t\t".color(:cyan) + content['locale'].color(:green)

      view << "#{padding}Posts\t\t\t".color(:cyan) + content['counts']['posts'].to_s.color(:green)


      unless show_ranks == false
        # this is ok for one user, but do not call this in a loop
        # do call them all at once instead if many
        ranks = NiceRank.new.get_posts_day([content['id'].to_i])
        unless ranks.empty?
          view << "#{padding}Posts/day\t\t".color(:cyan) + ranks[0][:posts_day].to_s.color(:green)
        end
      end

      view << "#{padding}Following\t\t".color(:cyan) + content['counts']['following'].to_s.color(:green)
      view << "\nFollowers\t\t".color(:cyan) + content['counts']['followers'].to_s.color(:green)

      if content['username'] == Settings.config[:identity][:username] && !token.nil?
        view << "#{padding}Storage used\t\t".color(:cyan) + "#{token['storage']['used'].to_filesize}".color(:red)
        view << "\nStorage available\t".color(:cyan) + "#{token['storage']['available'].to_filesize}".color(:green)
      end

      #view << "\nStars\t\t\t".color(:cyan) + content['counts']['stars'].to_s.color(:yellow)

      unless content['username'] == Settings.config[:identity][:username]
        if content['you_follow']
          view << "#{padding}You follow ".color(:cyan) + "@#{content['username']}".color(Settings.options[:colors][:username])
        else
          view << "#{padding}You don't follow ".color(:cyan) + "@#{content['username']}".color(Settings.options[:colors][:username])
        end
        if content['follows_you']
          view << "\n" + "@#{content['username']}".color(Settings.options[:colors][:username]) + " follows you".color(:cyan)
        else
          view << "\n" + "@#{content['username']}".color(Settings.options[:colors][:username]) + " doesn't follow you".color(:cyan)
        end
        if content['you_muted']
          view << "\nYou muted " + "@#{content['username']}".color(Settings.options[:colors][:username])
        end
        if content['you_blocked']
          view << "\nYou blocked " + "@#{content['username']}".color(Settings.options[:colors][:username])
        end
      end

      unless content['annotations'].empty?
        view << "\n" unless Settings.options[:timeline][:compact] == true
      end
      content['annotations'].each do |anno|
        case anno['type']
        when "net.app.core.directory.blog"
          view << "\nBlog\t\t\t".color(:cyan) + "#{anno['value']['url']}".color(Settings.options[:colors][:link])
        when "net.app.core.directory.twitter"
          view << "\nTwitter\t\t\t".color(:cyan) + "#{anno['value']['username']}".color(:green)
        when "com.appnetizens.userinput.birthday"
          view << "\nBirthday\t\t".color(:cyan) + "#{anno['value']['birthday']}".color(:green)
        end
      end


      #view << "#{padding}Avatar URL\t\t".color(:cyan) + content['avatar_image']['url']

      if content['description']
        view << "#{padding}#{content['description']['text']}\n".color(:magenta) + "\n\n"
      end

      puts view

    end

    def show_channels(resp, options = {})
      view = ""
      bucket = @workers.build_channels(resp['data'], options)
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
        if options[:other]
          next if ch.type == "net.app.core.pm" || ch.type == "net.app.core.broadcast"
        end
        if options[:"no-other"]
          next if ch.type != "net.app.core.pm" || ch.type != "net.app.core.broadcast"
        end
        view << "\n"
        view << "ID: ".color(:cyan)
        view << "#{ch.id}".color(Settings.options[:colors][:id])
        view << "\n"
        ch_alias = Databases.get_alias_from_id(ch.id)
        unless ch_alias.nil?
          view << "Alias: ".color(:cyan)
          view << "#{ch_alias}".color(Settings.options[:colors][:username])
          view << "\n"
        end
        view << "Messages: ".color(:cyan)
        view << "#{ch.num_messages}".color(Settings.options[:colors][:symbols])
        view << "\n"
        if ch.owner
          view << "Owner: ".color(:cyan)
          view << "@#{ch.owner['username']}".color(Settings.options[:colors][:username])
          # + (#{ch.owner['name']}) if ch.owner['name']
          view << "\n"
        end
        unless options[:channels] # unless the request comes from Search
          view << "Writers: ".color(:cyan)
          view << "#{ch.writers}".color(Settings.options[:colors][:name])
          view << "\n"
        end
        view << "Type: ".color(:cyan)
        view << "#{ch.type}".color(Settings.options[:colors][:index])
        view << "\n"
        if ch.type == "net.patter-app.room"
          ann = ch.annotations.select {|a| a['type'] == "net.patter-app.settings"}
          view << "Name: ".color(:cyan)
          view << "#{ann[0]['value']['name']}".color(Settings.options[:colors][:link])
          view << "\n"
          view << "Description: ".color(:cyan)
          view << "#{ann[0]['value']['blurb']}".color(Settings.options[:colors][:username])
          view << "\n"
          ann = ch.annotations.select {|a| a['type'] == "net.app.core.fallback_url"}
          view << "URL: ".color(:cyan)
          view << "#{ann[0]['value']['url']}".color(Settings.options[:colors][:link])
          view << "\n"
        end
        if ch.type == "net.app.core.broadcast"
          ann = ch.annotations.select {|a| a['type'] == "net.app.core.broadcast.metadata"}
          view << "Title: ".color(:cyan)
          view << "#{ann[0]['value']['title']}".color(Settings.options[:colors][:link])
          view << "\n"
          view << "Description: ".color(:cyan)
          view << "#{ann[0]['value']['description']}".color(Settings.options[:colors][:username])
          view << "\n"
          ann = ch.annotations.select {|a| a['type'] == "net.app.core.fallback_url"}
          view << "URL: ".color(:cyan)
          view << "#{ann[0]['value']['url']}".color(Settings.options[:colors][:link])
          view << "\n"
        end
        unless ch.recent_message.nil?
          unless ch.recent_message['text'].nil?
            view << "Most recent message (#{@workers.parsed_time(ch.recent_message['created_at'])}): ".color(:cyan)
            view << "\n"
            view << "---\n#{ch.recent_message['text']}\n---"
          end
        end
        if ch.type == "net.paste-app.clips"
          ann = ch.recent_message['annotations'].select {|a| a['type'] == "net.paste-app.clip"}
          view << "\n\n"
          view << ann[0]['value']['content']
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
        get(stream['data'], options, niceranks)
      else
        show_raw(stream)
      end
    end

    def get(stream, options = {}, niceranks = {})
      clear_screen()
      if options[:index]
        show_posts_with_index(stream, options, niceranks)
      else
        show_posts(stream, options, niceranks)
      end
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

    def page msg
      clear_screen
      puts msg
      puts "\n"
    end

    def winsize
      IO.console.winsize
    end

    def show_links(links)
      links.each {|l| puts "#{l}".color(Settings.options[:colors][:link])}
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
      clear_screen()
      show_userinfos(stream, token, true)
    end

    def downloading(options = {})
      unless options[:raw]
        clear_screen()
        @status.downloading
      end
    end

    def list(what, list, target)
      clear_screen()
      case what
      when :whoreposted
        show_list_reposted(list, target)
      when :whostarred
        show_list_starred(list, target)
      when :followings
        show_list_followings(list, target)
      when :followers
        show_list_followers(list, target)
      when :muted
        show_list_muted(list)
      when :blocked
        show_list_blocked(list)
      end
    end

    def big_separator
      "----------\n\n\n"
    end

    private

    def get_broadcast_alias_from_id(event_id)
      al = Databases.get_alias_from_id(event_id)
      if al.nil? || al.empty?
        return event_id
      else
        return al
      end
    end

    def filter_nicerank posts, options
      if options[:filter] == true # if this option is true in Action (it's only for global, actually)
        if Settings.options[:nicerank][:filter] == true
          filtered = {}
          posts.each do |id,content|
            if Settings.options[:nicerank][:filter_unranked] == true
              next if content[:nicerank] == false
            end
            unless content[:nicerank] == false
              next if content[:nicerank] < Settings.options[:nicerank][:threshold]
              next if content[:is_human] == 0
              next if content[:real_person] == 0
            end
            filtered[id] = content
          end
          return filtered
        end
      end
      return posts
    end

    def build_stream_with_index(data, options, niceranks) #expects an array
      @view = ""
      posts = filter_nicerank(@workers.build_posts(data.reverse, niceranks), options)
      posts.each do |id,content|
        format = "%03d" % content[:count]
        arrow = arrow_count(options, content)
        count = "#{arrow}#{format}"
        if content[:username] == Settings.config[:identity][:username]
          @view << count.color(Settings.options[:colors][:index]).inverse
        elsif content[:mentions].include?(Settings.config[:identity][:username]) && options[:in_mentions].nil?
          @view << count.color(Settings.options[:colors][:mentions]).inverse
        else
          @view << count.color(Settings.options[:colors][:index])
        end
        @view << ": ".color(Settings.options[:colors][:index])
        @view << build_content(content)
      end
      return posts, @view
    end

    def build_stream_without_index(data, options, niceranks) #expects an array
      @view = ""
      posts = filter_nicerank(@workers.build_posts(data.reverse, niceranks), options)
      posts.each do |id,content|
        content[:id] = arrow_id(options, content)
        if content[:username] == Settings.config[:identity][:username]
          @view << content[:id].color(Settings.options[:colors][:id]).inverse + " "
        elsif content[:mentions].include?(Settings.config[:identity][:username]) && options[:in_mentions].nil?
          @view << content[:id].color(Settings.options[:colors][:mentions]).inverse + " "
        else
          @view << content[:id].color(Settings.options[:colors][:id]) + " "
        end
        @view << build_content(content)
      end
      @view
    end

    def arrow_count options, content
      if options[:reply_to]
        return '⬇︎ ' if options[:reply_to] == content[:id]
        return '⬆︎ ' if options[:post_id] == content[:id]
        return ''
      end
      ''
    end

    def arrow_id options, content
      if options[:reply_to]
        return content[:id].to_s.prepend('⬇︎ ') if options[:reply_to] == content[:id]
        return content[:id].to_s.prepend('⬆︎ ') if options[:post_id] == content[:id]
        return content[:id].to_s
      end
      content[:id].to_s
    end

    def build_interactions_stream(data)
      inter = ""
      data.reverse.each do |event|
        users_array = []
        inter << "#{@workers.parsed_time(event['event_date'])}".color(Settings.options[:colors][:date])
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
        inter << "\n\n"
      end
      inter
    end

    def build_files_list(list)
      data = list.reverse
      view = "\n"
      data.each do |file|
        view << "ID\t\t".color(:cyan)
        view << file['id'].color(Settings.options[:colors][:id])
        view << "\n"
        view << "Name\t\t".color(:cyan)
        view << file['name'].color(Settings.options[:colors][:name])
        view << "\n"
        view << "Kind\t\t".color(:cyan)
        view << file['kind'].color(Settings.options[:colors][:username])
        view << " (#{file['mime_type']})".color(Settings.options[:colors][:username]) if file['mime_type']
        if file['image_info']
          view << "\n"
          view << "Dimensions\t".color(:cyan)
          view << "#{file['image_info']['width']} x #{file['image_info']['height']}".color(Settings.options[:colors][:username])
        end
        view << "\n"
        view << "Size\t\t".color(:cyan)
        view << file['size'].to_filesize.color(:yellow)
        view << "\n"
        view << "Date\t\t".color(:cyan)
        view << @workers.parsed_time(file['created_at']).color(:green)
        view << "\n"
        view << "Source\t\t".color(:cyan)
        view << file['source']['name'].color(Settings.options[:colors][:source])
        view << "\n"
        view << "State\t\t".color(:cyan)
        if file['public']
          view << "Public".color(Settings.options[:colors][:id])
          view << "\n"
          view << "Link\t\t".color(:cyan)
          view << file['url_short'].color(Settings.options[:colors][:link])
        else
          view << "Private".color(Settings.options[:colors][:id])
        end

        view << "\n\n"
      end
      view
    end

    def build_content(content)
      view = ""
      view << build_header(content)
      view << "\n" unless Settings.options[:timeline][:compact] == true
      view << content[:text]
      view << "\n" unless Settings.options[:timeline][:compact] == true
      if content[:has_checkins]
        view << build_checkins(content)
        view << "\n" unless Settings.options[:timeline][:compact] == true
      end
      unless content[:links].empty?
        view << "\n"
        content[:links].each do |link|
          view << link.color(Settings.options[:colors][:link])
          view << "\n"
        end
      end
      if Settings.options[:timeline][:compact] == true
        if content[:links].empty?
          view << "\n"
        else
          view
        end
      else
        view << "\n\n"
      end
    end

    def build_header(content)
      header = ""
      header << content[:handle].color(Settings.options[:colors][:username])
      if Settings.options[:timeline][:real_name]
        header << " "
        header << content[:name].color(Settings.options[:colors][:name])
      end
      if Settings.options[:timeline][:date]
        header << " "
        header << content[:date].color(Settings.options[:colors][:date])
      end
      if Settings.options[:timeline][:source]
        header << " "
        header << "[#{content[:source_name]}]".color(Settings.options[:colors][:source])
      end
      if Settings.options[:timeline][:symbols]
        header << " <".color(Settings.options[:colors][:symbols]) if content[:is_reply]
        header << " #{content[:num_stars]}*".color(Settings.options[:colors][:symbols]) if content[:is_starred]
        header << " #{content[:num_reposts]}x".color(Settings.options[:colors][:symbols]) if content[:num_reposts] > 0
        header << " >".color(Settings.options[:colors][:symbols]) if content[:num_replies] > 0
      end
      header << "\n"
    end

    def build_checkins(content)
      unless content[:checkins][:name].nil?
        num_dots = content[:checkins][:name].length
      else
        num_dots = 10
      end
      if Settings.options[:timeline][:compact] == true
        hd = "\n"
      else
        hd = (".".color(Settings.options[:colors][:dots])) * num_dots
        hd << "\n"
      end
      formatted = { header: hd }
      content[:checkins].each do |key, val|
          formatted[key] = val
      end

      formatted[:name] = "" if formatted[:name].nil?
      chk = formatted[:header]
      unless formatted[:name] == ""
        chk << formatted[:name].color(Settings.options[:colors][:dots])
        chk << "\n"
      end
      unless formatted[:title].nil? || formatted[:title] == formatted[:name]
        chk << formatted[:title]
        chk << "\n"
      end
      unless formatted[:address].nil?
        chk << formatted[:address]
        chk << "\n"
      end
      unless formatted[:address_extended].nil?
        chk << formatted[:address_extended]
        chk << "\n"
      end

      unless formatted[:postcode].nil?
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

  end
end
