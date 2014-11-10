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
        Errors.global_error({error: e, caller: caller, data: ['create_tables', user]})
      end
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
      crashes = 0
      begin
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
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['add_to_blacklist', type, target]})
        end
      end
    end

    def self.is_in_blacklist?(type, target)
      crashes = 0
      begin
        res = @sql.execute("SELECT * FROM Blacklist WHERE type=\"#{type}\" AND content=\"#{target.downcase}\"").flatten
        if res.empty?
          return false
        else
          return true
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['is_in_blacklist?', type, target]})
        end
      end
    end

    def self.remove_from_blacklist(target)
      crashes = 0
      begin
        target.each do |el|
          @sql.execute("DELETE FROM Blacklist WHERE content=\"#{el.downcase}\"")
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['remove_from_blacklist', target]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_blacklist']})
        end
      end
    end

    def self.remove_from_accounts(db, username)
      crashes = 0
      begin
        db.execute("DELETE FROM Accounts WHERE username=\"#{username.downcase}\"")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['remove_from_accounts', db, username]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['active_account', acc]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_accounts', acc]})
        end
      end
    end

    def self.set_active_account(acc_db, new_user)
      crashes = 0
      begin
        acc_db.execute("UPDATE Accounts SET active=0")
        acc_db.execute("UPDATE Accounts SET active=1 WHERE username=\"#{new_user}\"")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['set_active_account', acc_db, new_user]})
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
        Errors.global_error({error: e, caller: caller, data: ['create_account_table', acc_db]})
      end
    end

    def self.create_account(acc_db, user)
      crashes = 0
      begin
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
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['create_account', acc_db, user]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['create_alias', channel_id, channel_alias]})
        end
      end
    end

    def self.delete_alias(channel_alias)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Aliases WHERE alias=\"#{channel_alias}\"")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['delete_alias', channel_alias]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_aliases']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['get_alias_from_id', channel_id]})
        end
      end
    end

    def self.get_channel_id(channel_alias)
      crashes = 0
      begin
        res = @sql.execute("SELECT channel_id FROM Aliases WHERE alias=\"#{channel_alias}\"")
        if res.empty?
          return nil
        else
          return res[0][0]
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['get_channel_id', channel_alias]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_aliases']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_bookmarks']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_pagination']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_index']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_users']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['clear_blacklist']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['add_bookmark', bookmark]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['delete_bookmark', post_id]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_bookmarks']})
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
          @sql.execute("UPDATE Bookmarks SET bookmark=\"#{bm.to_json}\" WHERE post_id=#{post_id.to_i}")
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['rename_bookmark', post_id, new_title]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['save_indexed_posts', posts]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['get_index_length']})
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
          Status.new.must_be_in_index
          Errors.global_error({error: "Out of range", caller: caller, data: [number]})
        end
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['get_post_from_index', arg]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['add_to_users_db_from_list', list]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['delete_users_from_list', list]})
        end
      end
    end

    def self.add_to_users_db(id, username, name)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Users WHERE user_id=#{id.to_i}")
        @sql.execute("INSERT INTO Users VALUES(#{id.to_i}, \"#{username}\", \"#{name}\")")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['add_to_users_db', id, username, name]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['find_user_by_id', user_id]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['find_user_object_by_id', user_id]})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_users']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_users_ids']})
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
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['all_pagination']})
        end
      end
    end

    def self.has_new?(stream, title)
      crashes = 0
      begin
        res = @sql.execute("SELECT post_id FROM Pagination WHERE name=\"#{title}\"").flatten[0]
        stream['meta']['max_id'].to_i > res.to_i
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['has_new?', stream, title]})
        end
      end
    end

    def self.save_max_id(stream, name = 'unknown')
      crashes = 0
      begin
        if stream['meta']['marker'].nil?
          key = name
        else
          key = stream['meta']['marker']['name']
        end
        @sql.execute("DELETE FROM Pagination WHERE name=\"#{key}\"")
        @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(\"#{key}\", #{stream['meta']['max_id'].to_i});")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['save_max_id', stream, name]})
        end
      end
    end

    def self.find_last_id_from(name)
      crashes = 0
      begin
        @sql.execute("SELECT post_id FROM Pagination WHERE name=\"#{name}\"").flatten[0]
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['find_last_id_from', name]})
        end
      end
    end

    def self.pagination_delete(name)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Pagination WHERE name=\"#{name}\"")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['pagination_delete', name]})
        end
      end
    end

    def self.pagination_insert(name, val)
      crashes = 0
      begin
        @sql.execute("DELETE FROM Pagination WHERE name=\"#{name}\"")
        @sql.execute("INSERT INTO Pagination(name, post_id) VALUES(\"#{name}\", #{val.to_i});")
      rescue Amalgalite::SQLite3::Error => e
        if crashes < 2
          crashes += 1
          Errors.warn "SQLite ERROR: #{e}"
          sleep(0.01)
          retry
        else
          Errors.global_error({error: e, caller: caller, data: ['pagination_insert', name, val]})
        end
      end
    end

  end

end
