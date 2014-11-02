# encoding: utf-8
module Ayadn
  class Migration

    def initialize
      @bookmarks = Daybreak::DB.new "#{Settings.config[:paths][:db]}/bookmarks.db" if File.exist?("#{Settings.config[:paths][:db]}/bookmarks.db")
      @aliases = Databases.aliases
      @blacklist = Databases.blacklist
      @niceranks = Databases.nicerank
      @users = Databases.users
      @pagination = Databases.pagination
      @index = Databases.index
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
    end

    def bookmarks
      unless File.exist?("#{Settings.config[:paths][:db]}/bookmarks.db")
        @shell.say_status :skip, "old Bookmarks database doesn't exist", :red
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
    end

    def blacklist
      @shell.say_status :import, "Blacklist database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Blacklist (
          type VARCHAR(255),
          content VARCHAR(256)
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
    end

    def niceranks
      @shell.say_status :import, "Niceranks database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Niceranks (
          user_id INTEGER,
          username VARCHAR(20),
          rank REAL,
          is_human INTEGER,
          real_person INTEGER,
          cached VARCHAR(255)
        );
      SQL
      @sql.reload_schema!
      @sql.transaction do |db_in_transaction|
        @niceranks.each do |k,v|
          insert_data = {}
          insert_data[":k"] = k.to_i
          insert_data[":username"] = v[:username]
          insert_data[":rank"] = v[:rank]
          human = v[:is_human]
          human == true ? insert_data[":is_human"] = 1 : insert_data[":is_human"] = 0
          real_person = v[:real_person]
          real_person == true ? insert_data[":real_person"] = 1 : insert_data[":real_person"] = 0
          insert_data[":cached"] = v[:cached]
          db_in_transaction.prepare("INSERT INTO Niceranks(user_id, username, rank, is_human, real_person, cached) VALUES(:k, :username, :rank, :is_human, :real_person, :cached);") do |insert|
            insert.execute(insert_data)
          end
        end
      end
      @shell.say_status :done, "#{@niceranks.size} objects", :green
    end

    def users
      @shell.say_status :import, "Users database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Users (
          user_id INTEGER,
          username VARCHAR(20),
          name VARCHAR(256)
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
    end

    def pagination
      @shell.say_status :import, "Pagination database", :cyan
      @sql.execute_batch <<-SQL
        CREATE TABLE Pagination (
          name VARCHAR(256),
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
          insert_data[":content"] = v
          db_in_transaction.prepare("INSERT INTO TLIndex(count, post_id, content) VALUES(:count, :post_id, :content);") do |insert|
            insert.execute(insert_data)
          end
        end
      end
      @shell.say_status :done, "#{@index.size} objects", :green
    end

  end
end
