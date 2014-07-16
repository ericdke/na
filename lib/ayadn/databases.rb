# encoding: utf-8
module Ayadn

  class Databases

    class << self
      attr_accessor :users, :index, :pagination, :aliases, :blacklist, :bookmarks, :nicerank
    end

    def self.open_databases
      @users = self.init "#{Settings.config[:paths][:db]}/users.db"
      @index = self.init "#{Settings.config[:paths][:pagination]}/index.db"
      @pagination = self.init "#{Settings.config[:paths][:pagination]}/pagination.db"
      @aliases = self.init "#{Settings.config[:paths][:db]}/aliases.db"
      @blacklist = self.init "#{Settings.config[:paths][:db]}/blacklist.db"
      @bookmarks = self.init "#{Settings.config[:paths][:db]}/bookmarks.db"
      @nicerank = self.init "#{Settings.config[:paths][:db]}/nicerank.db"
    end

    def self.all_dbs
      [@users, @index, @pagination, @aliases, @blacklist, @bookmarks, @nicerank]
    end

    def self.close_all

      if @nicerank.size > 10000
        limit = Time.now - (3600 * 48)
        @nicerank.each {|k,v| @nicerank.delete(k) if v[:cached] < limit}
      end

      Debug.db all_dbs

      all_dbs.each do |db|
        db.flush
        db.compact
        db.close
      end
    end

    def self.init(path)
      # winPlatforms = ['mswin', 'mingw', 'mingw_18', 'mingw_19', 'mingw_20', 'mingw32']
      # case RbConfig::CONFIG['host_os']
      # when *winPlatforms
      #   abort("\nSorry, Ayadn doesn't work on Windows.\n\n".color(:red))
      # else
        Daybreak::DB.new "#{path}"
      # end
    end

    def self.add_niceranks niceranks
      niceranks.each {|id,infos| @nicerank[id] = infos}
    end

    def self.get_niceranks user_ids
      ids = {}
      user_ids.each {|id| ids[id] = @nicerank[id]}
      ids
    end

    def self.add_user_to_blacklist(target)
      target.each {|username| @blacklist["-#{username.downcase}"] = :user}
    end
    def self.add_mention_to_blacklist(target)
      target.each {|username| @blacklist[username.downcase] = :mention}
    end
    def self.add_client_to_blacklist(target)
      target.each {|source| @blacklist[source.downcase] = :client}
    end
    def self.add_hashtag_to_blacklist(target)
      target.each {|tag| @blacklist[tag.downcase] = :hashtag}
    end
    def self.remove_from_blacklist(target)
      target.each {|el| @blacklist.delete(el.downcase)}
    end
    def self.import_blacklist(blacklist)
      new_list = self.init blacklist
      new_list.each {|name,type| @blacklist[name] = type}
      new_list.close
    end
    def self.convert_blacklist
      dummy = {}
      @blacklist.each {|v,k| dummy[v.downcase] = k}
      @blacklist.clear
      dummy.each {|v,k| @blacklist[v] = k}
    end
    def self.save_max_id(stream)
      @pagination[stream['meta']['marker']['name']] = stream['meta']['max_id']
    end

    def self.create_alias(channel_id, channel_alias)
      @aliases[channel_alias] = channel_id
    end

    def self.delete_alias(channel_alias)
      @aliases.delete(channel_alias)
    end

    def self.clear_aliases
      @aliases.clear
    end

    def self.clear_blacklist
      @blacklist.clear
    end

    def self.clear_bookmarks
      @bookmarks.clear
    end

    def self.get_channel_id(channel_alias)
      @aliases[channel_alias]
    end

    def self.import_aliases(aliases)
      new_aliases = self.init aliases
      new_aliases.each {|al,id| @aliases[al] = id}
      new_aliases.close
    end

    def self.get_alias_from_id(channel_id)
      @aliases.each {|al, id| return al if id == channel_id}
      nil
    end

    def self.save_indexed_posts(posts)
      @index.clear
      posts.each {|id, hash| @index[id] = hash}
    end

    def self.get_index_length
      @index.length
    end

    def self.get_post_from_index(number)
      unless number > @index.length || number <= 0
        @index.each {|id, values| return values if values[:count] == number}
      else
        puts Status.must_be_in_index
        Errors.global_error({error: "Out of range", caller: caller, data: [number]})
      end
    end

    def self.add_to_users_db_from_list(list)
      list.each { |id, content_array| @users[id] = {content_array[0] => content_array[1]} }
    end

    def self.add_to_users_db(id, username, name)
      @users[id] = {username => name}
    end

    def self.has_new?(stream, title)
      stream['meta']['max_id'].to_i > @pagination[title].to_i
    end

    def self.add_bookmark bookmark
      @bookmarks[bookmark[:id]] = bookmark
    end

    def self.delete_bookmark post_id
      @bookmarks.delete post_id
    end

    def self.rename_bookmark post_id, new_title
      @bookmarks[post_id][:title] = new_title
    end

  end

end
