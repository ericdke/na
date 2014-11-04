# encoding: utf-8
module Ayadn
  class Migration

    require 'daybreak'

    def initialize
      @bookmarks = Daybreak::DB.new "#{Settings.config[:paths][:db]}/bookmarks.db" if File.exist?("#{Settings.config[:paths][:db]}/bookmarks.db")
      @aliases = Daybreak::DB.new "#{Settings.config[:paths][:db]}/aliases.db" if File.exist?("#{Settings.config[:paths][:db]}/aliases.db")
      @blacklist = Daybreak::DB.new "#{Settings.config[:paths][:db]}/blacklist.db" if File.exist?("#{Settings.config[:paths][:db]}/blacklist.db")
      @users = Daybreak::DB.new "#{Settings.config[:paths][:db]}/users.db" if File.exist?("#{Settings.config[:paths][:db]}/users.db")
      @pagination = Daybreak::DB.new "#{Settings.config[:paths][:home]}/pagination/pagination.db" if File.exist?("#{Settings.config[:paths][:home]}/pagination/pagination.db")
      @index = Daybreak::DB.new "#{Settings.config[:paths][:home]}/pagination/index.db" if File.exist?("#{Settings.config[:paths][:home]}/pagination/index.db")
      @accounts = Daybreak::DB.new(Dir.home + "/ayadn/accounts.db") if File.exist?(Dir.home + "/ayadn/accounts.db")
      @shell = Thor::Shell::Color.new
      @sqlfile = "#{Settings.config[:paths][:db]}/ayadn.sqlite"
      @shell.say_status :create, "#{Settings.config[:paths][:db]}/ayadn.sqlite", :blue
      @sql = Amalgalite::Database.new(@sqlfile)
    end

    def all
      if File.exist?("#{Settings.config[:paths][:db]}/channels.db")
        @shell.say_status :delete, "#{Settings.config[:paths][:db]}/channels.db", :green
        FileUtils.rm("#{Settings.config[:paths][:db]}/channels.db")
      end
      bookmarks
      aliases
      blacklist
      niceranks
      users
      pagination
      index
      accounts
    end

    def bookmarks
      unless File.exist?("#{Settings.config[:paths][:db]}/bookmarks.db")
        @shell.say_status :skip, "old bookmarks database doesn't exist", :red
      else
        @shell.say_status :import, "Bookmarks database", :cyan
        @sql.execute_batch <<-SQL
          CREATE TABLE Bookmarks (
            post_id INTEGER,
            bookmark TEXT
          );
        SQL
        @sql.reload_schema!
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
        @shell.say_status :done, "#{@bookmarks.size} objects", :green
        @bookmarks.close
        FileUtils.rm("#{Settings.config[:paths][:db]}/bookmarks.db")
        @shell.say_status :delete, "#{Settings.config[:paths][:db]}/bookmarks.db", :green
      end
    end

    def aliases
      unless File.exist?("#{Settings.config[:paths][:db]}/aliases.db")
        @shell.say_status :skip, "old aliases database doesn't exist", :red
      else
        @shell.say_status :import, "Aliases database", :cyan
        @sql.execute_batch <<-SQL
          CREATE TABLE Aliases (
            channel_id INTEGER,
            alias VARCHAR(255)
          );
        SQL
        @sql.reload_schema!
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
        @shell.say_status :done, "#{@aliases.size} objects", :green
        @aliases.close
        FileUtils.rm("#{Settings.config[:paths][:db]}/aliases.db")
        @shell.say_status :delete, "#{Settings.config[:paths][:db]}/aliases.db", :green
      end
    end

    def blacklist
      @shell.say_status :import, "Blacklist database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Blacklist (
          type VARCHAR(255),
          content TEXT
        );
      SQL
      @sql.reload_schema!
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
      @shell.say_status :done, "#{@blacklist.size} objects", :green
      @blacklist.close
      # FileUtils.rm("#{Settings.config[:paths][:db]}/blacklist.db")
      # @shell.say_status :delete, "#{Settings.config[:paths][:db]}/blacklist.db", :green
    end

    def niceranks
      FileUtils.rm("#{Settings.config[:paths][:db]}/nicerank.db")
      @shell.say_status :delete, "#{Settings.config[:paths][:db]}/nicerank.db", :green
    end

    def users
      @shell.say_status :import, "Users database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Users (
          user_id INTEGER,
          username VARCHAR(20),
          name TEXT
        );
      SQL
      @sql.reload_schema!
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
      @shell.say_status :done, "#{@users.size} objects", :green
      @users.close
      # FileUtils.rm("#{Settings.config[:paths][:db]}/users.db")
      # @shell.say_status :delete, "#{Settings.config[:paths][:db]}/users.db", :green
    end

    def pagination
      @shell.say_status :import, "Pagination database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Pagination (
          name TEXT,
          post_id INTEGER
        );
      SQL
      @sql.reload_schema!
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
      @shell.say_status :done, "#{@pagination.size} objects", :green
      @pagination.close
      FileUtils.rm("#{Settings.config[:paths][:home]}/pagination/pagination.db")
      @shell.say_status :delete, "#{Settings.config[:paths][:home]}/pagination/pagination.db", :green
    end

    def index
      @shell.say_status :import, "Index database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE TLIndex (
          count INTEGER,
          post_id INTEGER,
          content TEXT
        );
      SQL
      @sql.reload_schema!
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
      @shell.say_status :done, "#{@index.size} objects", :green
      @index.close
      FileUtils.rm("#{Settings.config[:paths][:home]}/pagination/index.db")
      @shell.say_status :delete, "#{Settings.config[:paths][:home]}/pagination/index.db", :green
      FileUtils.rmdir("#{Settings.config[:paths][:home]}/pagination")
      @shell.say_status :delete, "#{Settings.config[:paths][:home]}/pagination", :green
    end

    def accounts
      @shell.say_status :create, Dir.home + "/ayadn/accounts.sqlite", :blue
      sql = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      @shell.say_status :import, "Accounts database", :cyan
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
      @shell.say_status :done, "#{@accounts.size - 1} objects", :green
      @accounts.close
      # FileUtils.rm(Dir.home + "/ayadn/accounts.db")
      # @shell.say_status :delete, Dir.home + "/ayadn/accounts.db", :green
    end

  end
end
