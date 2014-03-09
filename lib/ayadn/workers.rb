module Ayadn
  class Workers

    def build_aliases_list(list)
      table = init_table
      table.title = "List of your channel aliases".color(:cyan) + "".color(:white)
      list.each do |k,v|
        table << ["#{k}".color(:green), "#{v}".color(:red)]
      end
      table
    end

    def build_reposted_list(list, target) #not the same format as wollowings/etc: taks an array of hashes
      table = init_table
      table.title = "List of users who reposted post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      users_list = []
      list.each do |obj|
        obj['name'].nil? ? name = "" : name = obj['name']
        users_list << {:username => obj['username'], :name => name, :you_follow => obj['you_follow'], :follows_you => obj['follows_you']}
      end
      return users_list, table
    end

    def build_starred_list(list, target)
      table = init_table
      table.title = "List of users who starred post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      users_list = []
      list.each do |obj|
        obj['name'].nil? ? name = "" : name = obj['name']
        users_list << {:username => obj['username'], :name => name, :you_follow => obj['you_follow'], :follows_you => obj['follows_you']}
      end
      return users_list, table
    end

    def build_followings_list(list, target) #takes a hash of users with ayadn format
      table = init_table
      if target == "me"
        table.title = "List of users you're following".color(:cyan) + "".color(:white)
      else
        table.title = "List of users ".color(:cyan) + "#{target}".color(:red) + " is following ".color(:cyan) + "".color(:white)
      end
      users_list = build_users_array(list)
      build_users_list(users_list, table)
    end

    def build_followers_list(list, target)
      table = init_table
      if target == "me"
        table.title = "List of your followers".color(:cyan) + "".color(:white)
      else
        table.title = "List of users following ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      end
      users_list = build_users_array(list)
      build_users_list(users_list, table)
    end

    def build_muted_list(list)
      table = init_table
      table.title = "List of users you muted".color(:cyan) + "".color(:white)
      users_list = build_users_array(list)
      build_users_list(users_list, table)
    end

    def build_blocked_list(list)
      table = init_table
      table.title = "List of users you blocked".color(:cyan) + "".color(:white)
      users_list = build_users_array(list)
      build_users_list(users_list, table)
    end

    def init_table
      Terminal::Table.new do |t|
        t.style = { :width => MyConfig.options[:formats][:table][:width] }
      end
    end

    def build_users_array(list)
      users_list = []
      list.each do |key, value|
        users_list << {:username => value[0], :name => value[1], :you_follow => value[2], :follows_you => value[3]}
      end
      users_list
    end



    def build_users_list(list, table)
      list.each_with_index do |obj, index|
        unless obj[:name].nil?
          table << [ "@#{obj[:username]} ".color(MyConfig.options[:colors][:username]), "#{obj[:name]}" ]
        else
          table << [ "@#{obj[:username]} ".color(MyConfig.options[:colors][:username]), "" ]
        end
        table << :separator unless index + 1 == list.length
      end
      table
    end

    def build_posts(data)
      # builds a hash of hashes, each hash is a normalized post with post id as a key
      posts = {}

      data.each.with_index(1) do |post, index|

        values = {
          count: index,
          id: post['id'].to_i,
          name: post['user']['name'] || "(no name)",
          thread_id: post['thread_id'],
          username: post['user']['username'],
          handle: "@" + post['user']['username'],
          type: post['user']['type'],
          date: parsed_time(post['created_at']),
          you_starred: post['you_starred'],
          source_name: post['source']['name'],
          source_link: post['source']['link'],
          canonical_url: post['canonical_url']
        }

        unless post['text'].nil?
          values[:raw_text] = post['text']
          values[:text] = colorize_text(post['text'])
        else
          values[:raw_text] = ""
          values[:text] = "(no text)"
        end

        unless post['num_stars'].nil? || post['num_stars'] == 0
          values[:is_starred] = true
          values[:num_stars] = post['num_stars']
        else
          values[:is_starred] = false
          values[:num_stars] = 0
        end
        if post['repost_of']
          values[:is_repost] = true
          values[:repost_of] = post['repost_of']['id']
        else
          values[:is_repost] = false
          values[:repost_of] = nil
        end
        if post['reply_to']
          values[:is_reply] = true
          values[:reply_to] = post['reply_to']
          values[:num_replies] = post['num_replies']
        else
          values[:is_reply] = false
          values[:reply_to] = nil
          values[:num_replies] = 0
        end
        if post['num_reposts']
          values[:num_reposts] = post['num_reposts']
        else
          values[:num_reposts] = 0
        end

        mentions= []

        post['entities']['mentions'].each { |m| mentions << m['name'] }
        values[:mentions] = mentions
        values[:directed_to] = mentions.first || false

        values[:tags] = extract_hashtags(post)

        values[:links] = extract_links(post)

        values[:checkins], values[:has_checkins] = extract_checkins(post)

        posts[post['id'].to_i] = values

      end
      posts
    end

    def extract_links(post)
      links = []
      post['entities']['links'].each { |l| links << l['url'] }
      links
    end

    def extract_hashtags(post)
      tags = []
      post['entities']['hashtags'].each { |h| tags << h['name'] }
      tags
    end

    def extract_checkins(post)
      has_checkins = false
      checkins = {}
      unless post['annotations'].nil?
        post['annotations'].each do |obj|
          case obj['type']
          when "net.app.core.checkin", "net.app.ohai.location"
            has_checkins = true
            checkins = {
              name: obj['value']['name'],
              address: obj['value']['address'],
              address_extended: obj['value']['address_extended'],
              locality: obj['value']['locality'],
              postcode: obj['value']['postcode'],
              country_code: obj['value']['country_code'],
              website: obj['value']['website'],
              telephone: obj['value']['telephone']
            }
            unless obj['value']['categories'].nil?
              unless obj['value']['categories'][0].nil?
                checkins[:categories] = obj['value']['categories'][0]['labels'].join(", ")
              end
            end
            unless obj['value']['factual_id'].nil?
                checkins[:factual_id] = obj['value']['factual_id']
            end
            unless obj['value']['longitude'].nil?
                checkins[:longitude] = obj['value']['longitude']
                checkins[:latitude] = obj['value']['latitude']
            end
          when "net.app.core.oembed"
            has_checkins = true
                checkins[:embeddable_url] = obj['value']['embeddable_url']
          end
        end
      end
      return checkins, has_checkins
    end

    def build_channels(data)
      channels = []
      data.each { |ch| channels << ch }
      bucket = []
      #puts "Downloading new channels and unknown users ids, please wait...\n\n"
      chan = Struct.new(:id, :num_messages, :subscribers, :type, :owner, :annotations, :readers, :editors, :writers, :you_subscribed, :unread, :recent_message_id, :recent_message)
      channels.each do |ch|
        unless ch['writers']['user_ids'].empty?
          usernames = []
          ch['writers']['user_ids'].each do |id|
            db = Databases.get_from_users_db(id)
            unless db.nil?
              usernames << "@" + db.keys.first
            else
              resp = API.new.get_user(id)
              usernames << "@" + resp['data']['username']
              Databases.add_to_users_db(id, resp['data']['username'], resp['data']['name'])
            end
          end
          usernames << MyConfig.config[:handle] unless usernames.length == 1 && usernames.first == MyConfig.config[:handle]
          writers = usernames.join(", ")
        else
          writers = MyConfig.config[:handle]
        end
        if ch['has_unread']
          unread = "This channel has unread message(s)"
        else
          unread = "No unread messages"
        end
        bucket << chan.new(ch['id'], ch['counts']['messages'], ch['counts']['subscribers'], ch['type'], ch['owner'], ch['annotations'], ch['readers'], ch['editors'], writers, ch['you_subscribed'], unread, ch['recent_message_id'], ch['recent_message'])
      end
      bucket
    end


    def parsed_time(string)
      "#{string[0...10]} #{string[11...19]}"
    end

    def colorize_text(text)
      content = Array.new
      hashtag_color = MyConfig.options[:colors][:hashtags]
      mention_color = MyConfig.options[:colors][:mentions]
      text.scan(/^.+[\r\n]*/) do |word|
        if word =~ /#\w+/
          content << word.gsub(/#([A-Za-z0-9_]{1,255})(?![\w+])/, '#\1'.color(hashtag_color))
        elsif word =~ /@\w+/
          content << word.gsub(/@([A-Za-z0-9_]{1,20})(?![\w+])/, '@\1'.color(mention_color))
        else
          content << word
        end
      end
      content.join()
    end

    def self.add_arobase_if_absent(username) # expects an array of username(s), works on the first one and outputs a string
      unless username.first == "me"
        username = username.first.chars.to_a
        username.unshift("@") unless username.first == "@"
      else
        username = "me".chars.to_a
      end
      username.join
    end

  end
end
