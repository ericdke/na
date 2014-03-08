module Ayadn

  class Databases

    class << self
      attr_accessor :users, :index
    end

    def self.open_databases
      @users = Daybreak::DB.new "#{MyConfig.config[:paths][:db]}/users.db"
      @index = Daybreak::DB.new "#{MyConfig.config[:paths][:pagination]}/index.db"
    end

    def self.close_all
      @users.flush
      @users.close
      @index.flush
      @index.close
    end

    def self.save_indexed_posts(posts)
      begin
        @index.clear
        posts.each do |id, hash|
          @index[id] = hash
        end
      rescue => e
        Logs.rec.error "From fileops/save_indexed_posts"
        Logs.rec.error "#{e}"
        raise e
      end
    end

    def self.get_post_from_index(number)
      begin
        unless number > @index.length || number <= 0
          @index.to_h.each do |id, values|
            return values if values[:count] == number
          end
        else
          raise #temp
        end
      rescue => e
        Logs.rec.error "From fileops/get_post_from_index"
        Logs.rec.error "#{e}"
        raise e
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
