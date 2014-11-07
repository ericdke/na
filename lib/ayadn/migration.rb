# encoding: utf-8
module Ayadn
  class Migration

    require 'daybreak'

    def initialize
      @accounts = Daybreak::DB.new(Dir.home + "/ayadn/accounts.db")
      @active_old = @accounts['ACTIVE']
      @home = @accounts[@active_old][:path]
      bookmarks_old = "#{@home}/db/bookmarks.db"
      aliases_old = "#{@home}/db/aliases.db"
      blacklist_old = "#{@home}/db/blacklist.db"
      users_old = "#{@home}/db/users.db"
      @pagination_old = "#{@home}/pagination/pagination.db"
      @index_old = "#{@home}/pagination/index.db"

      @thor = Thor::Shell::Color.new

      @bookmarks = Daybreak::DB.new(bookmarks_old) if File.exist?(bookmarks_old)
      @aliases = Daybreak::DB.new(aliases_old) if File.exist?(aliases_old)
      @blacklist = Daybreak::DB.new(blacklist_old) if File.exist?(blacklist_old)
      @users = Daybreak::DB.new(users_old) if File.exist?(users_old)
      @pagination = Daybreak::DB.new(@pagination_old) if File.exist?(@pagination_old)
      @index = Daybreak::DB.new(@index_old) if File.exist?(@index_old)

      @sqlfile = "#{@home}/db/ayadn.sqlite"
      @sql = Amalgalite::Database.new(@sqlfile)
    end

    def all
      # DON'T MODIFY THE ORDER!
      @thor.say_status :start, "migration", :yellow
      old_backup = "#{@home}/backup"
      if Dir.exist?(old_backup)
        if Dir.entries(old_backup).size > 2
          FileUtils.mv(Dir.glob("#{old_backup}/*"), "#{@home}/downloads")
          @thor.say_status :move, "files from 'backup' to 'downloads'", :green
        end
        Dir.rmdir(old_backup)
        @thor.say_status :delete, old_backup, :green
      end
      old_channels = "#{@home}/db/channels.db"
      if File.exist?(old_channels)
        @thor.say_status :delete, old_channels, :green
        File.delete(old_channels)
      end
      if File.exist?("#{@home}/db/ayadn_pinboard.db")
        @thor.say_status :move, "pinboard credentials", :green
        FileUtils.mv("#{@home}/db/ayadn_pinboard.db", "#{@home}/auth/pinboard.data")
      end
      bookmarks
      aliases
      blacklist
      niceranks
      users
      pagination
      index
      accounts
      @thor.say_status :done, "Ready to go!", :green
      @thor.say_status :thanks, "Please launch Ayadn again.", :cyan
    end

    def bookmarks
      @sql.execute_batch <<-SQL
        CREATE TABLE Bookmarks (
          post_id INTEGER,
          bookmark TEXT
        );
      SQL
      @sql.reload_schema!
      if File.exist?("#{@home}/db/bookmarks.db")
        @thor.say_status :import, "Bookmarks database", :cyan
        @sql.transaction do |db_in_transaction|
          @bookmarks.each do |k,v|
            insert_data = {}
            insert_data[":k"] = k.to_i
            insert_data[":v"] = v.to_json.to_s
            db_in_transaction.prepare("INSERT INTO Bookmarks(post_id, bookmark) VALUES(:k, :v);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@bookmarks.size} objects", :green
        @bookmarks.close
        File.delete("#{@home}/db/bookmarks.db")
        @thor.say_status :delete, "#{@home}/db/bookmarks.db", :green
      end
    end

    def aliases
      @sql.execute_batch <<-SQL
        CREATE TABLE Aliases (
          channel_id INTEGER,
          alias VARCHAR(255)
        );
      SQL
      @sql.reload_schema!
      if File.exist?("#{@home}/db/aliases.db")
        @thor.say_status :import, "Aliases database", :cyan
        @sql.transaction do |db_in_transaction|
          @aliases.each do |k,v|
            insert_data = {}
            insert_data[":k"] = v.to_i
            insert_data[":v"] = k
            db_in_transaction.prepare("INSERT INTO Aliases(channel_id, alias) VALUES(:k, :v);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@aliases.size} objects", :green
        @aliases.close
        File.delete("#{@home}/db/aliases.db")
        @thor.say_status :delete, "#{@home}/db/aliases.db", :green
      end
    end

    def blacklist
      @sql.execute_batch <<-SQL
        CREATE TABLE Blacklist (
          type VARCHAR(255),
          content TEXT
        );
      SQL
      @sql.reload_schema!
      if File.exist?("#{@home}/db/blacklist.db")
        @thor.say_status :import, "Blacklist database", :cyan
        @sql.transaction do |db_in_transaction|
          @blacklist.each do |k,v|
            insert_data = {}
            ks = k.dup.to_s
            ks[0] = "" if ks[0] == "-"
            ks[0] = "" if ks[0] == "@"
            insert_data[":k"] = v.to_s
            insert_data[":v"] = ks
            db_in_transaction.prepare("INSERT INTO Blacklist(type, content) VALUES(:k, :v);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@blacklist.size} objects", :green
        @blacklist.close
        File.delete("#{@home}/db/blacklist.db")
        @thor.say_status :delete, "#{@home}/db/blacklist.db", :green
      end
    end

    def niceranks
      if File.exist?("#{@home}/db/nicerank.db")
        File.delete("#{@home}/db/nicerank.db")
        @thor.say_status :delete, "#{@home}/db/nicerank.db", :green
      end
    end

    def users
      @sql.execute_batch <<-SQL
        CREATE TABLE Users (
          user_id INTEGER,
          username VARCHAR(20),
          name TEXT
        );
      SQL
      @sql.reload_schema!
      if File.exist?("#{@home}/db/users.db")
        @thor.say_status :import, "Users database", :cyan
        @sql.transaction do |db_in_transaction|
          @users.each do |k,v|
            insert_data = {}
            insert_data[":id"] = k.to_i
            insert_data[":username"] = v.keys[0]
            insert_data[":name"] = v.values[0]
            db_in_transaction.prepare("INSERT INTO Users(user_id, username, name) VALUES(:id, :username, :name);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@users.size} objects", :green
        @users.close
        File.delete("#{@home}/db/users.db")
        @thor.say_status :delete, "#{@home}/db/users.db", :green
      end
    end

    def pagination
      @sql.execute_batch <<-SQL
        CREATE TABLE Pagination (
          name TEXT,
          post_id INTEGER
        );
      SQL
      @sql.reload_schema!
      if File.exist?(@pagination_old)
        @thor.say_status :import, "Pagination database", :cyan
        @sql.transaction do |db_in_transaction|
          @pagination.each do |k,v|
            insert_data = {}
            insert_data[":post_id"] = v.to_i
            insert_data[":name"] = k.to_s
            db_in_transaction.prepare("INSERT INTO Pagination(name, post_id) VALUES(:name, :post_id);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@pagination.size} objects", :green
        @pagination.close
        File.delete(@pagination_old)
        @thor.say_status :delete, @pagination_old, :green
      end
    end

    def index
      @sql.execute_batch <<-SQL
        CREATE TABLE TLIndex (
          count INTEGER,
          post_id INTEGER,
          content TEXT
        );
      SQL
      @sql.reload_schema!
      if File.exist?(@index_old)
        @thor.say_status :import, "Index database", :cyan
        @sql.transaction do |db_in_transaction|
          @index.each do |k,v|
            insert_data = {}
            insert_data[":post_id"] = v[:id]
            insert_data[":count"] = v[:count]
            insert_data[":content"] = v.to_json.to_s
            db_in_transaction.prepare("INSERT INTO TLIndex(count, post_id, content) VALUES(:count, :post_id, :content);") do |insert|
              insert.execute(insert_data)
            end
          end
        end
        @thor.say_status :done, "#{@index.size} objects", :green
        @index.close
        File.delete(@index_old)
        @thor.say_status :delete, @index_old, :green
        Dir.rmdir("#{@home}/pagination")
        @thor.say_status :delete, "#{@home}/pagination", :green
      end
    end

    def accounts
      @thor.say_status :create, Dir.home + "/ayadn/accounts.sqlite", :blue
      sql = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      @thor.say_status :import, "Accounts database", :cyan
      sql.execute_batch <<-SQL
        CREATE TABLE Accounts (
          username VARCHAR(20),
          user_id INTEGER,
          handle VARCHAR(21),
          account_path TEXT,
          active INTEGER,
          token TEXT
        );
      SQL
      sql.reload_schema!
      active_account = ""
      sql.transaction do |db_in_transaction|
        @accounts.each do |k,v|
          if k == "ACTIVE"
            active_account = v
            next
          end
          insert_data = {}
          insert_data[":username"] = k
          insert_data[":user_id"] = v[:id].to_i
          insert_data[":handle"] = "@#{k}"
          insert_data[":account_path"] = v[:path]
          insert_data[":active"] = 0
          template = Dir.home + "/ayadn/#{k}/auth/token"
          insert_data[":token"] = File.read(template)
          db_in_transaction.prepare("INSERT INTO Accounts(username, user_id, handle, account_path, active, token) VALUES(:username, :user_id, :handle, :account_path, :active, :token);") do |insert|
            insert.execute(insert_data)
          end
        end
      end
      sql.execute("UPDATE Accounts SET active=1 WHERE username='#{active_account}'")
      @thor.say_status :done, "#{@accounts.size - 1} objects", :green
      @accounts.close
      File.delete(Dir.home + "/ayadn/accounts.db")
      @thor.say_status :delete, Dir.home + "/ayadn/accounts.db", :green
    end

  end
end
