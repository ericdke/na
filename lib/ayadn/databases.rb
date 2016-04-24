# encoding: utf-8
module Ayadn

  class Databases

    def self.open_databases
      @sqlfile = "#{Settings.config.paths.db}/ayadn.sqlite"
      @sql = Amalgalite::Database.new(@sqlfile)
      @accounts = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
    end

    def self.create_tables(user)
      # config is not loaded here, have to specify absolute path
      begin
        sql = Amalgalite::Database.new("#{user.user_path}/db/ayadn.sqlite")
        sql.execute_batch <<-SQL
          CREATE TABLE Bookmarks (
            post_id INTEGER,
            bookmark TEXT
          );
        SQL
        sql.reload_schema!
        sql.execute_batch <<-SQL
          CREATE TABLE Aliases (
            channel_id INTEGER,
            alias VARCHAR(255)
          );
        SQL
        sql.reload_schema!
        sql.execute_batch <<-SQL
          CREATE TABLE Blacklist (
            type VARCHAR(255),
            content TEXT
          );
        SQL
        sql.reload_schema!
        sql.execute_batch <<-SQL
          CREATE TABLE Users (
            user_id INTEGER,
            username VARCHAR(20),
            name TEXT
          );
        SQL
        sql.reload_schema!
        sql.execute_batch <<-SQL
          CREATE TABLE Pagination (
            name TEXT,
            post_id INTEGER
          );
        SQL
        sql.reload_schema!
        sql.execute_batch <<-SQL
          CREATE TABLE TLIndex (
            count INTEGER,
            post_id INTEGER,
            content TEXT
          );
        SQL
        sql.reload_schema!
      rescue Amalgalite::SQLite3::Error => e
        puts "ERROR in Databases"
        puts caller
        puts e
        puts ['create_tables', user].inspect
        exit
      end
    end

    def self.add_to_blacklist(type, target)
      crashes = 0
      begin
        remove_from_blacklist(type, target)
        @sql.transaction do |db_in_transaction|
          target.each do |element|
            insert_data = {}
            insert_data[":type"] = type
            insert_data[":content"] = element.downcase
            db_in_transaction.prepare("INSERT INTO Blacklist(type, content) VALUES(:type, :content);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['add_to_blacklist', type, target].inspect
          exit
        end
      end
    end

    def self.is_in_blacklist?(type, target)
      crashes = 0
      begin
        res = @sql.execute("SELECT * FROM Blacklist WHERE type=(?) AND content=(?)", [type, target.downcase]).flatten
        if res.empty?
          return false
        else
          return true
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['is_in_blacklist?', type, target].inspect
          exit
        end
      end
    end

    def self.remove_from_blacklist(type, target)
      crashes = 0
      begin
        target.each do |el|
          @sql.execute("DELETE FROM Blacklist WHERE type=(?) AND content=(?)", [type, el.downcase])
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['remove_from_blacklist', target].inspect
          exit
        end
      end
    end

    def self.all_blacklist
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Blacklist")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_blacklist'].inspect
          exit
        end
      end
    end

    def self.remove_from_accounts(db, username)
      crashes = 0
      begin
        db.execute("DELETE FROM Accounts WHERE username=(?)", [username.downcase])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['remove_from_accounts', db, username].inspect
          exit
        end
      end
    end

    # def self.import_blacklist(blacklist)
    #   new_list = self.init blacklist
    #   new_list.each {|name,type| @blacklist[name] = type}
    #   new_list.close
    # end
    # def self.convert_blacklist
    #   dummy = {}
    #   @blacklist.each {|v,k| dummy[v.downcase] = k}
    #   @blacklist.clear
    #   dummy.each {|v,k| @blacklist[v] = k}
    # end



    def self.active_account(acc)
      crashes = 0
      begin
        acc.execute("SELECT * FROM Accounts WHERE active=1")[0]
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['active_account', acc].inspect
          exit
        end
      end
    end

    def self.all_accounts(acc)
      crashes = 0
      begin
        acc.execute("SELECT * FROM Accounts")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_accounts', acc].inspect
          exit
        end
      end
    end

    def self.set_active_account(acc_db, new_user)
      crashes = 0
      begin
        acc_db.execute("UPDATE Accounts SET active=0")
        acc_db.execute("UPDATE Accounts SET active=1 WHERE username=(?)", [new_user])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['set_active_account', acc_db, new_user].inspect
          exit
        end
      end
    end

    def self.create_account_table(acc_db)
      begin
        acc_db.execute_batch <<-SQL
          CREATE TABLE Accounts (
            username VARCHAR(20),
            user_id INTEGER,
            handle VARCHAR(21),
            account_path TEXT,
            active INTEGER,
            token TEXT
          );
        SQL
        acc_db.reload_schema!
      rescue Amalgalite::SQLite3::Error => e
        puts "ERROR in Databases"
        puts caller
        puts e
        puts ['create_account_table', acc_db].inspect
        exit
      end
    end

    def self.create_account(acc_db, user)
      crashes = 0
      begin
        acc_db.execute("DELETE FROM Accounts WHERE username=(?)", [user.username])
        acc_db.transaction do |db|
          insert_data = {}
            insert_data[":username"] = user.username
            insert_data[":user_id"] = user.id
            insert_data[":handle"] = user.handle
            insert_data[":account_path"] = user.user_path
            insert_data[":active"] = 0
            insert_data[":token"] = user.token
            db.prepare("INSERT INTO Accounts(username, user_id, handle, account_path, active, token) VALUES(:username, :user_id, :handle, :account_path, :active, :token);") do |insert|
              insert.execute(insert_data)
            end
        end
        set_active_account(acc_db, user.username)
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['create_account', acc_db, user].inspect
          exit
        end
      end
    end

    def self.create_alias(channel_id, channel_alias)
      crashes = 0
      begin
        delete_alias(channel_alias)
        @sql.transaction do |db_in_transaction|
          insert_data = {}
          insert_data[":k"] = channel_id.to_i
          insert_data[":v"] = channel_alias
          db_in_transaction.prepare("INSERT INTO Aliases(channel_id, alias) VALUES(:k, :v);") do |insert|
            insert.execute(insert_data)
          end
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['create_alias', channel_id, channel_alias].inspect
          exit
        end
      end
    end

    def self.delete_alias(channel_alias)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Aliases WHERE alias=(?)", [channel_alias])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['delete_alias', channel_alias].inspect
          exit
        end
      end
    end

    def self.clear_aliases
      crashes = 0
      begin
        @sql.execute("DELETE FROM Aliases")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_aliases'].inspect
          exit
        end
      end
    end

    def self.get_alias_from_id(channel_id)
      crashes = 0
      begin
        res = @sql.execute("SELECT alias FROM Aliases WHERE channel_id=#{channel_id.to_i}")
        if res.empty?
          return nil
        else
          return res[0][0]
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['get_alias_from_id', channel_id].inspect
          exit
        end
      end
    end

    def self.get_channel_id(channel_alias)
      crashes = 0
      begin
        res = @sql.execute("SELECT channel_id FROM Aliases WHERE alias=(?)", [channel_alias])
        if res.empty?
          return nil
        else
          return res[0][0]
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['get_channel_id', channel_alias].inspect
          exit
        end
      end
    end

    def self.all_aliases
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Aliases")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_aliases'].inspect
          exit
        end
      end
    end

    def self.clear_bookmarks
      crashes = 0
      begin
        @sql.execute("DELETE FROM Bookmarks")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_bookmarks'].inspect
          exit
        end
      end
    end

    def self.clear_pagination
      crashes = 0
      begin
        @sql.execute("DELETE FROM Pagination")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_pagination'].inspect
          exit
        end
      end
    end

    def self.clear_index
      crashes = 0
      begin
        @sql.execute("DELETE FROM TLIndex")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_index'].inspect
          exit
        end
      end
    end

    def self.clear_users
      crashes = 0
      begin
        @sql.execute("DELETE FROM Users")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_users'].inspect
          exit
        end
      end
    end

    def self.clear_blacklist
      crashes = 0
      begin
        @sql.execute("DELETE FROM Blacklist")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['clear_blacklist'].inspect
          exit
        end
      end
    end

    def self.add_bookmark bookmark
      crashes = 0
      begin
        delete_bookmark(bookmark['id'])
        @sql.transaction do |db_in_transaction|
          insert_data = {}
          insert_data[":k"] = bookmark['id'].to_i
          insert_data[":v"] = bookmark.to_json.to_s
          db_in_transaction.prepare("INSERT INTO Bookmarks(post_id, bookmark) VALUES(:k, :v);") do |insert|
            insert.execute(insert_data)
          end
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['add_bookmark', bookmark].inspect
          exit
        end
      end
    end

    def self.delete_bookmark post_id
      crashes = 0
      begin
        @sql.execute("DELETE FROM Bookmarks WHERE post_id=#{post_id.to_i}")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['delete_bookmark', post_id].inspect
          exit
        end
      end
    end

    def self.all_bookmarks
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Bookmarks")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_bookmarks'].inspect
          exit
        end
      end
    end

    def self.rename_bookmark post_id, new_title
      crashes = 0
      begin
        req = @sql.execute("SELECT bookmark FROM Bookmarks WHERE post_id=#{post_id.to_i}")
        if req.empty?
          Errors.global_error({error: "Post doesn't exist", caller: caller, data: [post_id, new_title]})
        else
          bm = JSON.parse(req[0][0])
          bm['title'] = new_title
          @sql.execute("UPDATE Bookmarks SET bookmark=(?) WHERE post_id=#{post_id.to_i}", bm.to_json)
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['rename_bookmark', post_id, new_title].inspect
          exit
        end
      end
    end

    def self.save_indexed_posts(posts)
      crashes = 0
      begin
        @sql.execute("DELETE FROM TLIndex")
        @sql.transaction do |db_in_transaction|
          posts.each do |k, v|
            insert_data = {}
            insert_data[":post_id"] = v[:id]
            insert_data[":count"] = v[:count]
            insert_data[":content"] = v.to_json.to_s
            db_in_transaction.prepare("INSERT INTO TLIndex(count, post_id, content) VALUES(:count, :post_id, :content);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['save_indexed_posts', posts].inspect
          exit
        end
      end
    end

    def self.get_index_length
      crashes = 0
      begin
        @sql.execute("SELECT Count(*) FROM TLIndex").flatten[0]
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['get_index_length'].inspect
          exit
        end
      end
    end

    def self.get_post_from_index(arg)
      crashes = 0
      begin
        number = arg.to_i
        unless number > 200
          res = @sql.execute("SELECT content FROM TLIndex WHERE count=#{number}").flatten[0]
          JSON.parse(res)
        else
          {'id' => number}
          # Status.new.must_be_in_index
          # Errors.global_error({error: "Out of range", caller: caller, data: [number]})
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['get_post_from_index', arg].inspect
          exit
        end
      end
    end

    def self.add_to_users_db_from_list(list)
      crashes = 0
      begin
        delete_users_from_list(list)
        @sql.transaction do |db_in_transaction|
          list.each do |id, content_array|
            insert_data = {}
            insert_data[":id"] = id.to_i
            insert_data[":username"] = content_array[0]
            insert_data[":name"] = content_array[1]
            db_in_transaction.prepare("INSERT INTO Users(user_id, username, name) VALUES(:id, :username, :name);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['add_to_users_db_from_list', list].inspect
          exit
        end
      end
    end

    def self.delete_users_from_list(list)
      crashes = 0
      begin
        list.each {|id, _| @sql.execute("DELETE FROM Users WHERE user_id=#{id.to_i}")}
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['delete_users_from_list', list].inspect
          exit
        end
      end
    end

    def self.add_to_users_db(id, username, name)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Users WHERE user_id=#{id.to_i}")
        @sql.execute("INSERT INTO Users VALUES(?, ?, ?)", [id.to_i, username, name])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['add_to_users_db', id, username, name].inspect
          exit
        end
      end
    end

    def self.find_user_by_id(user_id)
      crashes = 0
      begin
        res = @sql.execute("SELECT username FROM Users WHERE user_id=#{user_id}").flatten
        if res.empty?
          return nil
        else
          return res[0]
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['find_user_by_id', user_id].inspect
          exit
        end
      end
    end

    def self.find_user_object_by_id(user_id)
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Users WHERE user_id=#{user_id}").flatten
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['find_user_object_by_id', user_id].inspect
          exit
        end
      end
    end

    def self.all_users
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Users").flatten
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_users'].inspect
          exit
        end
      end
    end

    def self.all_users_ids
      crashes = 0
      begin
        @sql.execute("SELECT user_id FROM Users").flatten
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_users_ids'].inspect
          exit
        end
      end
    end

    def self.all_pagination
      crashes = 0
      begin
        @sql.execute("SELECT * FROM Pagination").flatten
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['all_pagination'].inspect
          exit
        end
      end
    end

    def self.has_new?(stream, title)
      crashes = 0
      begin
        res = @sql.execute("SELECT post_id FROM Pagination WHERE name=(?)", [title]).flatten[0]
        stream.meta.max_id.to_i > res.to_i
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['has_new?', stream.inspect, title].inspect
          exit
        end
      end
    end

    def self.save_max_id(stream, name = 'unknown')
      crashes = 0
      begin
        if stream.meta.marker.nil?
          key = name
        else
          key = stream.meta.marker.name
        end
        @sql.execute("DELETE FROM Pagination WHERE name=(?)", [key])
        @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(?, ?);", [key, stream.meta.max_id.to_i])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['save_max_id', stream.inspect, name].inspect
          exit
        end
      end
    end

    def self.find_last_id_from(name)
      crashes = 0
      begin
        @sql.execute("SELECT post_id FROM Pagination WHERE name=(?)", [name]).flatten[0]
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['find_last_id_from', name].inspect
          exit
        end
      end
    end

    def self.pagination_delete(name)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Pagination WHERE name=(?)", [name])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['pagination_delete', name].inspect
          exit
        end
      end
    end

    def self.pagination_insert(name, val)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Pagination WHERE name=(?)", [name])
        @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(?, ?);", [name, val.to_i])
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          sleep(0.01)
          retry
        else
          puts "ERROR in Databases"
          puts caller
          puts e
          puts ['pagination_insert', name, val].inspect
          exit
        end
      end
    end

  end

end
