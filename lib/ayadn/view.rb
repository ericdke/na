module Ayadn
  class View

    def initialize
      @workers = Workers.new
    end

    def show_posts_with_index(data, options)
      posts, view = build_stream_with_index(data, options)
      #puts "\n"
      puts view
      begin
        Databases.save_indexed_posts(posts)
      rescue => e
        Logs.rec.error "In view/show_posts_with_index/save_indexed_posts"
        Logs.rec.error "#{e}"
      end
    end

    def show_posts(data, options)
      view = build_stream_without_index(data, options)
      #puts "\n"
      puts view
    end

    def build_stream_with_index(data, options) #expects an array
      @view = ""
      posts = @workers.build_posts(data.reverse)
      posts.each do |id,content|
        count = "%03d" % content[:count]
        @view << count.color(MyConfig.options[:colors][:index])
        @view << ": ".color(MyConfig.options[:colors][:index])
        @view << build_content(content)
      end
      return posts, @view
    end

    def build_stream_without_index(data, options) #expects an array
      @view = ""
      posts = @workers.build_posts(data.reverse)
      posts.each do |id,content|
        @view << content[:id].to_s.color(MyConfig.options[:colors][:id]) + " "
        @view << build_content(content)
      end
      @view
    end

    def show_raw(stream)
      puts stream.to_json
    end

    def show_simple_post(post, options)
      view = build_stream_without_index(post, options)
      puts view
    end

    def show_posted(resp)
      puts show_simple_post([resp['data']], {})
    end

    def show_simple_stream(stream)
      puts stream
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

    def build_interactions_stream(data)
      inter = ""
      data.reverse.each do |event|
        users_array = []
        inter << "#{@workers.parsed_time(event['event_date'])}".color(MyConfig.options[:colors][:date])
        inter << " => "
        event['users'].each do |u|
          users_array << "@" + u['username']
        end
        case event['action']
          when "follow", "unfollow"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}ed you".color(:green)
          when "mute", "unmute"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}d you".color(:green)
          when "star", "unstar"
            inter << "#{users_array.join(", ")} ".color(:magenta)
            inter << "#{event['action']}red post #{event['objects'][0]['id']}".color(:green)
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

    def show_files_list(list)
      puts build_files_list(list)
    end

    def build_files_list(list) #meta+data
      data = list['data'].reverse
      view = "\n"
      data.each do |file|
        view << "ID\t\t".color(:cyan)
        view << file['id'].color(MyConfig.options[:colors][:id])
        view << "\n"
        view << "Name\t\t".color(:cyan)
        view << file['name'].color(MyConfig.options[:colors][:name])
        view << "\n"
        view << "Kind\t\t".color(:cyan)
        view << file['kind'].color(MyConfig.options[:colors][:username])
        view << " (#{file['mime_type']})".color(MyConfig.options[:colors][:username]) if file['mime_type']
        if file['image_info']
          view << "\n"
          view << "Dimensions\t".color(:cyan)
          view << "#{file['image_info']['width']} x #{file['image_info']['height']}".color(MyConfig.options[:colors][:username])
        end
        view << "\n"
        view << "Size\t\t".color(:cyan)
        view << file['size'].to_filesize.color(:yellow)
        view << "\n"
        view << "Date\t\t".color(:cyan)
        view << @workers.parsed_time(file['created_at']).color(:green)
        view << "\n"
        view << "Source\t\t".color(:cyan)
        view << file['source']['name'].color(MyConfig.options[:colors][:source])
        view << "\n"
        view << "State\t\t".color(:cyan)
        if file['public']
          view << "Public".color(MyConfig.options[:colors][:id])
          view << "\n"
          view << "Link\t\t".color(:cyan)
          view << file['url_short'].color(MyConfig.options[:colors][:link])
        else
          view << "Private".color(MyConfig.options[:colors][:id])
        end

        view << "\n\n"
      end
      view
    end

    def settings
      table = Terminal::Table.new do |t|
        t.style = { :width => MyConfig.options[:formats][:table][:width] }
        t.title = "Current Ayadn settings".color(:cyan)
        t.headings = [ "Category".color(:red), "Parameter".color(:red), "Value(s)".color(:red) ]
        @iter = 0
        MyConfig.options.each do |k,v|
          v.each do |x,y|
            t << :separator if @iter >= 1
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
      puts table
    end

    def show_userinfos(content)
      view = "Real name\t\t".color(:cyan) + content['name'].color(MyConfig.options[:colors][:name])

      view << "\n\nUsername\t\t".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])

      view << "\n\nID\t\t\t".color(:cyan) + content['id'].color(:yellow)
      view << "\nURL\t\t\t".color(:cyan) + content['canonical_url'].color(:yellow)

      unless content['verified_domain'].nil?
        if content['verified_domain'] =~ (/http/ || /https/)
           domain = content['verified_domain']
        else
          domain = "http://#{content['verified_domain']}"
        end
        view << "\nVerified domain\t\t".color(:cyan) + domain.color(:yellow)
      end


      view << "\nAccount creation\t".color(:cyan) + @workers.parsed_time(content['created_at']).color(:yellow)
      view << "\nTimeZone\t\t".color(:cyan) + content['timezone'].color(:yellow)
      view << "\nLocale\t\t\t".color(:cyan) + content['locale'].color(:yellow)

      view << "\n\nPosts\t\t\t".color(:cyan) + content['counts']['posts'].to_s.color(:yellow)

      view << "\n\nFollowing\t\t".color(:cyan) + content['counts']['following'].to_s.color(:yellow)
      view << "\nFollowers\t\t".color(:cyan) + content['counts']['followers'].to_s.color(:yellow)

      #view << "\nStars\t\t\t".color(:cyan) + content['counts']['stars'].to_s.color(:yellow)

      if content['you_follow']
        view << "\n\nYou follow ".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])
      else
        view << "\n\nYou don't follow ".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])
      end
      if content['follows_you']
        view << "\n" + "@#{content['username']}".color(MyConfig.options[:colors][:username]) + " follows you".color(:cyan)
      else
        view << "\n" + "@#{content['username']}".color(MyConfig.options[:colors][:username]) + " doesn't follow you".color(:cyan)
      end
      if content['you_muted']
        view << "\nYou muted " + "@#{content['username']}".color(MyConfig.options[:colors][:username])
      end
      if content['you_blocked']
        view << "\nYou blocked " + "@#{content['username']}".color(MyConfig.options[:colors][:username])
      end

      #view << "\n\nAvatar URL\t\t".color(:cyan) + content['avatar_image']['url']

      if content['description']
        view << "\n\n#{content['description']['text']}\n".color(:magenta) + "\n\n"
      end

      puts view
    end

    def build_content(content)
      view = ""
      view << build_header(content)
      view << "\n"
      view << content[:text]
      view << "\n"
      if content[:has_checkins]
        view << build_checkins(content)
        view << "\n"
      end
      unless content[:links].empty?
        view << "\n"
        content[:links].each do |link|
          view << link.color(MyConfig.options[:colors][:link])
          view << "\n"
        end
      end
      view << "\n\n"
    end

    def build_header(content)
      header = ""
      header << content[:handle].color(MyConfig.options[:colors][:username])
      if MyConfig.options[:timeline][:show_real_name]
        header << " "
        header << content[:name].color(MyConfig.options[:colors][:name])
      end
      if MyConfig.options[:timeline][:show_date]
        header << " "
        header << content[:date].color(MyConfig.options[:colors][:date])
      end
      if MyConfig.options[:timeline][:show_source]
        header << " "
        header << "[#{content[:source_name]}]".color(MyConfig.options[:colors][:source])
      end
      if MyConfig.options[:timeline][:show_symbols]
        header << " <".color(MyConfig.options[:colors][:symbols]) if content[:is_reply]
        header << " #{content[:num_stars]}*".color(MyConfig.options[:colors][:symbols]) if content[:is_starred]
        header << " >".color(MyConfig.options[:colors][:symbols]) if content[:num_replies] > 0
        header << " #{content[:num_reposts]}x".color(MyConfig.options[:colors][:symbols]) if content[:is_repost]
      end
      header << "\n"
    end

    def build_checkins(content)
      unless content[:checkins][:name].nil?
        num_dots = content[:checkins][:name].length
      else
        num_dots = 10
      end
      hd = (".".color(MyConfig.options[:colors][:dots])) * num_dots
      hd << "\n"
      formatted = { header: hd }
      content[:checkins].each do |key, val|
          formatted[key] = val unless (val.nil? || !val)
      end

      chk = formatted[:header]
      unless formatted[:name].nil?
        chk << formatted[:name].color(MyConfig.options[:colors][:dots])
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
      unless formatted[:country_code].nil?
        cc = "(#{formatted[:country_code]})".upcase
      else
        cc = ""
      end
      unless formatted[:postcode].nil?
        unless formatted[:locality].nil?
          chk << "#{formatted[:postcode]}, #{formatted[:locality]} #{cc}"
          chk << "\n"
        end
      else
        unless formatted[:locality].nil?
          chk << "#{formatted[:locality]} #{cc}"
          chk << "\n"
        end
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

    def show_channels(resp)
      view = ""
      bucket = @workers.build_channels(resp['data'])
      bucket.each do |ch|
        view << "\n"
        view << "ID: ".color(:cyan)
        view << "#{ch.id}".color(MyConfig.options[:colors][:id])
        view << "\n"
        view << "Messages: ".color(:cyan)
        view << "#{ch.num_messages}".color(MyConfig.options[:colors][:symbols])
        view << "\n"
        view << "Owner: ".color(:cyan)
        view << "@#{ch.owner['username']}".color(MyConfig.options[:colors][:username])
        # + (#{ch.owner['name']}) if ch.owner['name']
        view << "\n"
        view << "Writers: ".color(:cyan)
        view << "#{ch.writers}".color(MyConfig.options[:colors][:name])
        view << "\n"
        view << "Type: ".color(:cyan)
        view << "#{ch.type}".color(MyConfig.options[:colors][:source])
        view << "\n"
        #view << "You follow this channel" if ch.you_subscribed
        #view << "\n"
        #view << ch.unread
        #view << "\n"
        unless ch.recent_message.nil?
          view << "Most recent messsage: ".color(:cyan)
          view << "\n"
          view << "---\n#{ch.recent_message['text']}\n---"
        end
        view << "\n\n"
      end
      puts view
    end




    def clear_line
      print "\r                                            \n"
    end

    def clear_screen
      puts "\e[H\e[2J"
    end

  end
end
