# encoding: utf-8
module Ayadn

  class Databases

    def self.open_databases
      @sqlfile = "#{Settings.config[:paths][:db]}/ayadn.sqlite"
      @sql = Amalgalite::Database.new(@sqlfile)
      @accounts = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
    end

    def self.create_tables(user)
      # config is not loaded here, have to specify absolute path
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
    end

    # def self.add_niceranks niceranks
    #   niceranks.each {|k,v| @sql.execute("DELETE FROM Niceranks WHERE user_id=#{k.to_i}")}
    #   @sql.transaction do |db_in_transaction|
    #     niceranks.each do |k,v|
    #       insert_data = {}
    #       insert_data[":k"] = k.to_i
    #       insert_data[":username"] = v[:username]
    #       insert_data[":rank"] = v[:rank]
    #       human = v[:is_human]
    #       human == true ? insert_data[":is_human"] = 1 : insert_data[":is_human"] = 0
    #       real_person = v[:real_person]
    #       real_person == true ? insert_data[":real_person"] = 1 : insert_data[":real_person"] = 0
    #       insert_data[":cached"] = v[:cached]
    #       db_in_transaction.prepare("INSERT INTO Niceranks(user_id, username, rank, is_human, real_person, cached) VALUES(:k, :username, :rank, :is_human, :real_person, :cached);") do |insert|
    #         insert.execute(insert_data)
    #       end
    #     end
    #   end
    # end

    # def self.get_niceranks user_ids
    #   ids = {}
    #   user_ids.each do |id|
    #     u = @sql.execute("SELECT * FROM Niceranks WHERE user_id=#{id.to_i}").flatten
    #     next if u.empty?
    #     obj = {
    #         username: u[1],
    #         rank: u[2],
    #         is_human: u[3],
    #         real_person: u[4],
    #         cached: Time.now.to_i
    #       }
    #     ids[id.to_s] = obj
    #   end
    #   ids
    # end

    # def self.niceranks_size
    #   @sql.execute("SELECT Count(*) FROM Niceranks").flatten[0]
    # end


    def self.add_to_blacklist(type, target)
      remove_from_blacklist(target)
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
    end

    def self.is_in_blacklist?(type, target)
      res = @sql.execute("SELECT * FROM Blacklist WHERE type=\"#{type}\" AND content=\"#{target.downcase}\"").flatten
      if res.empty?
        return false
      else
        return true
      end
    end

    def self.remove_from_blacklist(target)
      target.each do |el|
        @sql.execute("DELETE FROM Blacklist WHERE content=\"#{el.downcase}\"")
      end
    end

    def self.all_blacklist
      @sql.execute("SELECT * FROM Blacklist")
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
      acc.execute("SELECT * FROM Accounts WHERE active=1")[0]
    end

    def self.all_accounts(acc)
      acc.execute("SELECT * FROM Accounts")
    end

    def self.set_active_account(acc_db, new_user)
      acc_db.execute("UPDATE Accounts SET active=0")
      acc_db.execute("UPDATE Accounts SET active=1 WHERE username=\"#{new_user}\"")
    end

    def self.create_account_table(acc_db)
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
    end

    def self.create_account(acc_db, user)
      acc_db.execute("DELETE FROM Accounts WHERE username=\"#{user.username}\"")
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
    end

    def self.create_alias(channel_id, channel_alias)
      delete_alias(channel_alias)
      @sql.transaction do |db_in_transaction|
        insert_data = {}
        insert_data[":k"] = channel_id.to_i
        insert_data[":v"] = channel_alias
        db_in_transaction.prepare("INSERT INTO Aliases(channel_id, alias) VALUES(:k, :v);") do |insert|
          insert.execute(insert_data)
        end
      end
    end

    def self.delete_alias(channel_alias)
      @sql.execute("DELETE FROM Aliases WHERE alias=\"#{channel_alias}\"")
    end

    def self.clear_aliases
      @sql.execute("DELETE FROM Aliases")
    end

    def self.get_alias_from_id(channel_id)
      res = @sql.execute("SELECT alias FROM Aliases WHERE channel_id=#{channel_id.to_i}")
      if res.empty?
        return nil
      else
        return res[0][0]
      end
    end

    def self.get_channel_id(channel_alias)
      res = @sql.execute("SELECT channel_id FROM Aliases WHERE alias=\"#{channel_alias}\"")
      if res.empty?
        return nil
      else
        return res[0][0]
      end
    end

    def self.all_aliases
      @sql.execute("SELECT * FROM Aliases")
    end


    def self.clear_bookmarks
      @sql.execute("DELETE FROM Bookmarks")
    end

    def self.clear_pagination
      @sql.execute("DELETE FROM Pagination")
    end

    def self.clear_index
      @sql.execute("DELETE FROM TLIndex")
    end

    def self.clear_users
      @sql.execute("DELETE FROM Users")
    end

    def self.clear_blacklist
      @sql.execute("DELETE FROM Blacklist")
    end

    def self.add_bookmark bookmark
      delete_bookmark(bookmark['id'])
      @sql.transaction do |db_in_transaction|
        insert_data = {}
        insert_data[":k"] = bookmark['id'].to_i
        insert_data[":v"] = bookmark.to_json.to_s
        db_in_transaction.prepare("INSERT INTO Bookmarks(post_id, bookmark) VALUES(:k, :v);") do |insert|
          insert.execute(insert_data)
        end
      end
    end

    def self.delete_bookmark post_id
      @sql.execute("DELETE FROM Bookmarks WHERE post_id=#{post_id.to_i}")
    end

    def self.all_bookmarks
      @sql.execute("SELECT * FROM Bookmarks")
    end

    def self.rename_bookmark post_id, new_title
      req = @sql.execute("SELECT bookmark FROM Bookmarks WHERE post_id=#{post_id.to_i}")
      if req.empty?
        Errors.global_error({error: "Post doesn't exist", caller: caller, data: [post_id, new_title]})
      else
        bm = JSON.parse(req[0][0])
        bm['title'] = new_title
        @sql.execute("UPDATE Bookmarks SET bookmark=\"#{bm.to_json}\" WHERE post_id=#{post_id.to_i}")
      end
    end

    def self.save_indexed_posts(posts)
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
    end

    def self.get_index_length
      @sql.execute("SELECT Count(*) FROM TLIndex").flatten[0]
    end

    def self.get_post_from_index(arg)
      number = arg.to_i
      unless number > 200
        res = @sql.execute("SELECT content FROM TLIndex WHERE count=#{number}").flatten[0]
        JSON.parse(res)
      else
        puts Status.must_be_in_index
        Errors.global_error({error: "Out of range", caller: caller, data: [number]})
      end
    end

    def self.add_to_users_db_from_list(list)
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
    end

    def self.delete_users_from_list(list)
      list.each {|id, _| @sql.execute("DELETE FROM Users WHERE user_id=#{id.to_i}")}
    end

    def self.add_to_users_db(id, username, name)
      @sql.execute("DELETE FROM Users WHERE user_id=#{id.to_i}")
      @sql.execute("INSERT INTO Users VALUES(#{id.to_i}, \"#{username}\", \"#{name}\")")
    end

    def self.find_user_by_id(user_id)
      res = @sql.execute("SELECT username FROM Users WHERE user_id=#{user_id}").flatten
      if res.empty?
        return nil
      else
        return res[0]
      end
    end

    def self.find_user_object_by_id(user_id)
      @sql.execute("SELECT * FROM Users WHERE user_id=#{user_id}").flatten
    end

    def self.all_users
      @sql.execute("SELECT * FROM Users").flatten
    end

    def self.all_users_ids
      @sql.execute("SELECT user_id FROM Users").flatten
    end

    def self.all_pagination
      @sql.execute("SELECT * FROM Pagination").flatten
    end

    def self.has_new?(stream, title)
      res = @sql.execute("SELECT post_id FROM Pagination WHERE name=\"#{title}\"").flatten[0]
      stream['meta']['max_id'].to_i > res.to_i
    end

    def self.save_max_id(stream, name = 'unknown')
      if stream['meta']['marker'].nil?
        key = name
      else
        key = stream['meta']['marker']['name']
      end
      @sql.execute("DELETE FROM Pagination WHERE name=\"#{key}\"")
      @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(\"#{key}\", #{stream['meta']['max_id'].to_i});")
    end

    def self.find_last_id_from(name)
      @sql.execute("SELECT post_id FROM Pagination WHERE name=\"#{name}\"").flatten[0]
    end

    def self.pagination_delete(name)
      @sql.execute("DELETE FROM Pagination WHERE name=\"#{name}\"")
    end

    def self.pagination_insert(name, val)
      @sql.execute("DELETE FROM Pagination WHERE name=\"#{name}\"")
      @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(\"#{name}\", #{val.to_i});")
    end

  end

end
