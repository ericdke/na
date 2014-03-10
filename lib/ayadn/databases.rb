module Ayadn

  class Databases

    class << self
      attr_accessor :users, :index
    end

    def self.open_databases
      @users = Daybreak::DB.new "#{MyConfig.config[:paths][:db]}/users.db"
      @index = Daybreak::DB.new "#{MyConfig.config[:paths][:pagination]}/index.db"
      @aliases = Daybreak::DB.new "#{MyConfig.config[:paths][:db]}/aliases.db"
    end

    def self.close_all
      [@users, @index, @aliases].each do |db|
        db.flush
        db.close
      end
    end

    def self.create_alias(channel_id, channel_alias)
      @aliases[channel_alias] = channel_id
    end

    def self.delete_alias(channel_alias)
      @aliases.delete(channel_alias)
    end

    def self.get_channel_id(channel_alias)
      @aliases[channel_alias]
    end

    def self.get_aliases
      @aliases
    end

    def self.save_indexed_posts(posts)
      begin
        @index.clear
        posts.each do |id, hash|
          @index[id] = hash
        end
      rescue => e
        Errors.global_error("fileops/save_indexed_posts", nil, e)
      end
    end

    def self.get_index_length
      @index.length
    end

    def self.get_post_from_index(number)
      begin
        unless number > @index.length || number <= 0
          @index.to_h.each do |id, values|
            return values if values[:count] == number
          end
        else
          puts "\nNumber must be in the range of the indexed posts.\n".color(:red)
          Errors.global_error("fileops/get_post_from_index", number, "out of range")
        end
      rescue => e
        Errors.global_error("fileops/get_post_from_index", number, e)
      end
    end

    def self.add_to_users_db_from_list(list)
      list.each do |id, content_array|
        @users[id] = {content_array[0] => content_array[1]}
      end
    end

    def self.add_to_users_db(id, username, name)
      @users[id] = {username => name}
    end

    def self.get_from_users_db(id)
      @users[id]
    end

    def self.load_users_db
      @users
    end

  end

end
