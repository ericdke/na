# encoding: utf-8
module Ayadn
  class Workers

    attr_reader :thor

    def initialize
      @thor = Thor::Shell::Color.new
      @status = Status.new
    end

    def table_borders
      if Settings.options[:formats][:table][:borders] == true
        { :width => Settings.options[:formats][:table][:width], border_x: '—', border_i: '+', border_y: '|' }
      else
        { :width => Settings.options[:formats][:table][:width], border_x: ' ', border_i: ' ', border_y: ' ' }
      end
    end

    def build_aliases_list(list)
      table = init_table
      table.title = "List of your channel aliases".color(:cyan) + "".color(:white)
      table.style = table_borders()
      table.headings = [ 'Channel', 'Alias' ]
      list.each_with_index do |obj, index|
        table << [obj[0].to_s.color(:green), obj[1].color(:red)]
        if index + 1 != list.length && Settings.options[:timeline][:compact] == false
          table << :separator
        end
      end
      table
    end

    def build_blacklist_list(list)
      table = init_table
      table.title = "Your blacklist".color(:cyan) + "".color(:white)
      table.style = table_borders()
      table.headings = [ 'Name', 'Type' ]
      list.sort!
      list.each_with_index do |obj, index|
        table << ["#{obj[1].capitalize}".to_s.force_encoding("UTF-8").color(:green), "#{obj[0]}".to_s.force_encoding("UTF-8").color(:red)]
        if index + 1 != list.length && Settings.options[:timeline][:compact] == false
          table << :separator
        end
      end
      table
    end

    def build_reposted_list(list, target)
      table = init_table
      table.title = "List of users who reposted post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      users_list = []
      list.each do |obj|
        obj['name'].nil? ? name = "" : name = obj['name'].to_s.force_encoding("UTF-8")
        users_list << {:username => obj['username'], :name => name, :you_follow => obj['you_follow'], :follows_you => obj['follows_you'], :id => obj['id'], :posts => obj['counts']['posts']}
      end
      table.style = table_borders()
      return users_list, table
    end

    def build_starred_list(list, target)
      table = init_table
      table.title = "List of users who starred post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      users_list = []
      list.each do |obj|
        obj['name'].nil? ? name = "" : name = obj['name'].to_s.force_encoding("UTF-8")
        users_list << {:username => obj['username'], :name => name, :you_follow => obj['you_follow'], :follows_you => obj['follows_you'], :id => obj['id'], :posts => obj['counts']['posts']}
      end
      table.style = table_borders()
      return users_list, table
    end

    def build_followings_list(list, target, options = {}) #takes a hash of users with ayadn format
      table = init_table
      table.title = if target == "me"
        "List of users you're following".color(:cyan) + "".color(:white)
      else
        "List of users ".color(:cyan) + "#{target}".color(:red) + " is following ".color(:cyan) + "".color(:white)
      end
      table.style = table_borders()
      users_list = build_users_array(list)
      build_users_list(users_list, table, options)
    end

    def build_followers_list(list, target, options = {})
      table = init_table
      table.title = if target == "me"
        "List of your followers".color(:cyan) + "".color(:white)
      else
        "List of users following ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
      end
      table.style = table_borders()
      build_users_list(build_users_array(list), table, options)
    end

    def build_muted_list(list, options = {})
      table = init_table
      table.title = "List of users you muted".color(:cyan) + "".color(:white)
      table.style = table_borders()
      build_users_list(build_users_array(list), table, options)
    end

    def build_blocked_list(list, options = {})
      table = init_table
      table.title = "List of users you blocked".color(:cyan) + "".color(:white)
      table.style = table_borders()
      build_users_list(build_users_array(list), table, options)
    end

    def build_users_list(list, table, options = {})
      users = at(list.map {|obj| obj[:username]})
      ids = list.map {|obj| obj[:id].to_i}
      ranks = NiceRank.new.from_ids(ids)
      indexed_ranks = {}
      ranks.each do |r|
        if r.empty?
          indexed_ranks = false
          break
        else
          indexed_ranks[r['user_id']] = r
        end
      end
      table << ['USERNAME'.color(:red), 'NAME'.color(:red), 'POSTS'.color(:red)]
      table << :separator
      arr = []
      if options[:username]
        list.sort_by! { |obj| obj[:username] }
      elsif options[:name]
        list.sort_by! { |obj| obj[:name].nil? ? "(no name)" : obj[:name].downcase }
      elsif options[:posts]
        list.sort_by! { |obj| [obj[:posts], obj[:username]] }
      end
      list.each do |obj|
        obj[:name] = "" if obj[:name].nil?
        obj[:username].length > 23 ? username = "#{obj[:username][0..20]}..." : username = obj[:username]
        obj[:name].length > 23 ? name = "#{obj[:name][0..20]}..." : name = obj[:name]
        arr << [ "@#{username} ".color(Settings.options[:colors][:username]), "#{name.to_s.force_encoding('UTF-8')}", obj[:posts] ]
      end
      if options[:reverse]
        arr.reverse!
      end
      if Settings.options[:formats][:list][:reverse] == true
        arr.reverse!
      end
      arr.each_with_index do |obj, index|
        table << arr[index]
        if index + 1 != arr.length && Settings.options[:timeline][:compact] == false
          table << :separator
        end
      end
      table
    end

    # builds a hash of hashes, each hash is a normalized post with post id as a key
    def build_posts(data, niceranks = {})
      # skip objects in blacklist unless force
      posts = {}
      data.each.with_index(1) do |post, index|
        unless Settings.global[:force] == true
          if Settings.options[:blacklist][:active] == true
            if Databases.is_in_blacklist?('client', post['source']['name'].downcase)
              Debug.skipped({source: post['source']['name']})
              next
            end
          end
        end
        unless Settings.global[:force] == true
          if Settings.options[:blacklist][:active] == true
            if Databases.is_in_blacklist?('user', post['user']['username'].downcase)
              Debug.skipped({user: post['user']['username']})
              next
            end
          end
        end
        hashtags = extract_hashtags(post)
        @skip = false
        unless Settings.global[:force] == true
          if Settings.options[:blacklist][:active] == true
            hashtags.each do |h|
              if Databases.is_in_blacklist?('hashtag', h.downcase)
                @skip = true
                Debug.skipped({hashtag: h})
                break
              end
            end
          end
        end
        next if @skip
        mentions= []
        post['entities']['mentions'].each { |m| mentions << m['name'] }
        unless Settings.global[:force] == true
          if Settings.options[:blacklist][:active] == true
            mentions.each do |m|
              if Databases.is_in_blacklist?('mention', m.downcase)
                @skip = true
                Debug.skipped({mention: m})
                break
              end
            end
          end
        end
        next if @skip
        unless Settings.global[:force] == true
          if Settings.options[:blacklist][:active] == true
            post['text'].split(" ").each do |word|
              target_word = word.gsub(/[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/, "")
              if Databases.is_in_blacklist?('word', target_word.downcase)
                Debug.skipped({word: target_word})
                @skip = true
                break
              end
            end
          end
        end
        next if @skip
        
        # create custom objects from ADN response
        if niceranks[post['user']['id'].to_i]
          rank = niceranks[post['user']['id'].to_i][:rank]
          is_human = niceranks[post['user']['id'].to_i][:is_human]
        else
          rank = false
          is_human = 'unknown'
        end

        if post['user'].has_key?('name')
          name = post['user']['name'].to_s.force_encoding("UTF-8")
        else
          name = "(no name)"
        end

        source = post['source']['name'].to_s.force_encoding("UTF-8")

        values = {
          count: index,
          id: post['id'].to_i,
          name: name,
          thread_id: post['thread_id'],
          username: post['user']['username'],
          user_id: post['user']['id'].to_i,
          nicerank: rank,
          is_human: is_human,
          handle: "@#{post['user']['username']}",
          type: post['user']['type'],
          date: parsed_time(post['created_at']),
          date_short: parsed_time_short(post['created_at']),
          you_starred: post['you_starred'],
          source_name: source,
          source_link: post['source']['link'],
          canonical_url: post['canonical_url'],
          tags: hashtags,
          links: extract_links(post),
          mentions: mentions,
          directed_to: mentions.first || false
        }

        values[:checkins], values[:has_checkins] = extract_checkins(post)

        if post['repost_of']
          values[:is_repost] = true
          values[:repost_of] = post['repost_of']['id']
          values[:original_poster] = post['repost_of']['user']['username']
        else
          values[:is_repost] = false
          values[:repost_of] = nil
          values[:original_poster] = post['user']['username']
        end

        unless post['text'].nil?
          values[:raw_text] = post['text']
          values[:text] = colorize_text(post['text'], mentions, hashtags)
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

        if post['num_replies']
          values[:num_replies] = post['num_replies']
        else
          values[:num_replies] = 0
        end

        if post['reply_to']
          values[:is_reply] = true
          values[:reply_to] = post['reply_to']
        else
          values[:is_reply] = false
          values[:reply_to] = nil
        end
        if post['num_reposts']
          values[:num_reposts] = post['num_reposts']
        else
          values[:num_reposts] = 0
        end

        posts[post['id'].to_i] = values

      end

      posts
    end

    def extract_links(post)
      links = post['entities']['links'].map { |l| l['url'] }
      unless post['annotations'].nil? || post['annotations'].empty?
        post['annotations'].each do |ann|
          if ann['type'] == "net.app.core.oembed"
            if ann['value']['embeddable_url']
              links << ann['value']['embeddable_url']
            elsif ann['value']['url'] && Settings.options[:channels][:links] == true
              links << ann['value']['url']
            end
          end
        end
      end
      links.uniq
    end

    def save_links(links, origin, args = "")
      links.sort!
      obj = {
        'meta' => {
          'type' => 'links',
          'origin' => origin,
          'args' => args,
          'created_at' => Time.now,
          'username' => Settings.config[:identity][:handle]
        },
        'data' => links
      }
      filename = "#{Settings.config[:identity][:handle]}_#{origin}_links.json"
      FileOps.save_links(obj, filename)
      @status.links_saved(filename)
    end

    def extract_hashtags(post)
      post['entities']['hashtags'].map { |h| h['name'] }
    end

    def extract_mentions(post)
      post['entities']['mentions'].map { |m| m['name'] }
    end

    def build_channels(data, options = {})
      bucket = []
      data = [data] unless data.is_a?(Array)
      if options[:channels]
        @thor.say_status :downloading, "list of channels and their users credentials", :yellow
        @thor.say_status :info, "it could take a while if there are many results and users", :cyan
      else
        @thor.say_status :downloading, "the channels and their users attributes (owners, writers, editors and readers)", :yellow
        @thor.say_status :info, "users are recorded in a database for later filtering and analyzing", :cyan
        @thor.say_status :info, "it could take a while if there are many results", :cyan
      end
      chan = Struct.new(:id, :num_messages, :subscribers, :type, :owner, :annotations, :readers, :editors, :writers, :you_subscribed, :unread, :recent_message_id, :recent_message)
      no_user = {}
      @api = API.new
      data.each do |ch|
        unless ch['writers']['user_ids'].empty?
          @thor.say_status :parsing, "channel #{ch['id']}", :cyan
          usernames = []
          ch['writers']['user_ids'].each do |id|
            next if no_user[id]
            db = Databases.find_user_by_id(id)
            if db.nil?
              @thor.say_status :downloading, "user #{id}", :yellow
              resp = @api.get_user(id)

              if resp['meta']['code'] != 200
                @thor.say_status :error, "can't get user #{id}'s data, skipping", :red
                no_user[id] = true
                next
              end

              the_username = resp['data']['username']
              @thor.say_status :recording, "@#{the_username}", :yellow

              usernames << "@" + the_username
              Databases.add_to_users_db(id, the_username, resp['data']['name'])
            else
              the_username = "@#{db}"
              @thor.say_status :match, "#{the_username} is already in the database", :blue

              usernames << the_username
            end
          end
          usernames << Settings.config[:identity][:handle] unless usernames.length == 1 && usernames.first == Settings.config[:identity][:handle]
          writers = usernames.join(", ")
        else
          writers = Settings.config[:identity][:handle]
        end
        if ch['has_unread']
          unread = "This channel has unread message(s)"
        else
          unread = "No unread messages"
        end
        bucket << chan.new(ch['id'], ch['counts']['messages'], ch['counts']['subscribers'], ch['type'], ch['owner'], ch['annotations'], ch['readers'], ch['editors'], writers, ch['you_subscribed'], unread, ch['recent_message_id'], ch['recent_message'])
      end
      puts "\e[H\e[2J"
      bucket
    end

    def parsed_time(string)
      "#{string[0...10]} #{string[11...19]}"
    end

    def parsed_time_short(string)
      "#{string[11...19]}"
    end

    def get_original_id(post_id, resp)
      if resp['data']['repost_of']
        @status.redirecting
        id = resp['data']['repost_of']['id']
        Errors.repost(post_id, id)
        return id
      else
        return post_id
      end
    end

    def get_channel_id_from_alias(channel_id)
      unless channel_id.is_integer?
        orig = channel_id
        channel_id = Databases.get_channel_id(orig)
        if channel_id.nil?
          Errors.warn("Alias '#{orig}' doesn't exist.")
          @status.no_alias
          exit
        end
      end
      channel_id
    end

    def length_of_index
      Databases.get_index_length
    end

    def get_post_from_index id
      Databases.get_post_from_index id
    end

    def get_real_post_id post_id
      id = post_id.to_i
      if id <= 200
        resp = get_post_from_index(id)
        post_id = resp['id']
      end
      post_id
    end

    def add_arobase username
      add_arobase_if_missing(username)
    end

    def add_arobase_if_missing(username) # expects an array of username(s), works on the first one and outputs a string
      unless username.first == "me"
        username = username.first.chars
        username.unshift("@") unless username.first == "@"
      else
        username = "me".chars
      end
      username.join
    end

    def remove_arobase_if_present args
      args.map! do |username|
        temp = username.chars
        temp.shift if temp.first == "@"
        temp.join
      end
      args
    end

    def add_arobases_to_usernames args
      args.map do |username|
        if username == 'me'
          who_am_i
        else
          temp = username.chars
          temp.unshift("@") unless temp.first == "@"
          temp.join
        end
      end
    end

    def at usernames
      usernames.map do |user|
        if user == 'me'
          'me'
        elsif user[0] == '@'
          user
        else
          "@#{user}"
        end
      end
    end

    def who_am_i
      Databases.active_account(Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite"))[2]
    end

    def extract_users(resp)
      users_hash = {}
      resp['data'].each do |item|
        users_hash[item['id']] = [item['username'], item['name'], item['you_follow'], item['follows_you'], item['counts']['posts']]
      end
      users_hash
    end

    def colorize_text(text, mentions, hashtags)
      reg_split = '[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]'
      reg_tag = '#([[:alpha:]0-9_]{1,255})(?![\w+])'
      reg_mention = '@([A-Za-z0-9_]{1,20})(?![\w+])'
      reg_sentence = '^.+[\r\n]*'
      handles, words, sentences = [], [], []
      mentions.each {|username| handles << "@#{username}"}
      hashtag_color = Settings.options[:colors][:hashtags]
      mention_color = Settings.options[:colors][:mentions]
      text.scan(/#{reg_sentence}/) do |sentence|
        sentence.split(' ').each do |word|

          word_chars = word.chars
          sanitized, word = [], []
          word_chars.each do |ch|
            if UnicodeUtils.general_category(ch) == :Other_Symbol
              sanitized << "#{ch} "
            elsif UnicodeUtils.char_name(ch).nil?
              next
            else
              sanitized << ch
            end
          end
          word = sanitized.join

          if word =~ /#\w+/
            slices = word.split('#')
            has_h = false
            slices.each do |tag|
              has_h = true if hashtags.include?(tag.downcase.scan(/[[:alpha:]0-9_]/).join(''))
            end
            if has_h == true
              if slices.length > 1
                words << slices.join('#').gsub(/#{reg_tag}/, '#\1'.color(hashtag_color))
              else
                words << word.gsub(/#{reg_tag}/, '#\1'.color(hashtag_color))
              end
            else
              words << word
            end
          elsif word =~ /@\w+/
            enc = []
            warr = word.split(' ')
            warr.each do |w|
              @str = def_str(w, reg_split)
              if handles.include?(@str.downcase)
                if warr.length == 1
                  enc << w.gsub(/#{reg_mention}/, '@\1'.color(mention_color))
                else
                  enc << " #{w.gsub(/#{reg_mention}/, '@\1'.color(mention_color))}"
                end
              else
                enc << w
              end
            end
            words << enc.join
          else
            words << word
          end
        end
        sentences << words.join(' ')
        words = Array.new
      end
      if Settings.options[:timeline][:compact] == true
        without_linebreaks = sentences.keep_if { |s| s != "" }
        without_linebreaks.join("\n")
      else
        sentences.join("\n")
      end
    end

    def links_from_posts(stream)
      links = []
      stream['data'].each do |post|
        extract_links(post).each {|l| links << l}
      end
      links.uniq
    end

    def all_but_me usernames
      arr = usernames.select {|user| user != 'me'}
      at(arr)
    end

    def self.epoch_to_date(epoch)
      Time.at(epoch).to_time
    end

    private

    def def_str(word, reg_split)
      splitted = word.split(/#{reg_split}/) if word =~ /#{reg_split}/
      if splitted
        splitted.each {|d| @str = d if d =~ /@\w+/}
        return word if @str.nil?
        @str
      else
        word
      end
    end

    def init_table
      Terminal::Table.new do |t|
        t.style = { :width => Settings.options[:formats][:table][:width] }
      end
    end

    def build_users_array(list)
      users = list.map do |key, value|
        {:username => value[0], :name => value[1], :you_follow => value[2], :follows_you => value[3], :id => key, :posts => value[4]}
      end
      return users
    end

    def extract_checkins(post)
      has_checkins = false
      checkins = {}
      unless post['annotations'].nil? || post['annotations'].empty?
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
            unless obj['value']['title'].nil?
              checkins[:title] = obj['value']['title']
            end
            unless obj['value']['region'].nil?
              checkins[:region] = obj['value']['region']
            end
          end
        end
      end
      return checkins, has_checkins
    end

  end
end
