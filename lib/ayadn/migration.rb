# encoding: utf-8
module Ayadn
  class Migration

    def initialize
      @bookmarks = Databases.bookmarks
      @aliases = Databases.aliases
      @blacklist = Databases.blacklist
      @niceranks = Databases.nicerank
      @users = Databases.users
      @pagination = Databases.pagination
      @index = Databases.index
      @sqlfile = "#{Settings.config[:paths][:db]}/ayadn.sqlite"
      @sql = Amalgalite::Database.new(@sqlfile)
      @shell = Thor::Shell::Color.new
    end

    def all
      bookmarks
      aliases
      blacklist
      niceranks
      users
      pagination
      index
    end

    def bookmarks
      @shell.say_status :importing, "Bookmarks database", :cyan
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
          insert_data[":v"] = v.to_s
          db_in_transaction.prepare("INSERT INTO Bookmarks(post_id, bookmark) VALUES(:k, :v);") do |insert|
            insert.execute(insert_data)
          end
        end
      end
      @shell.say_status :imported, "#{@bookmarks.size} objects", :green
    end

    def aliases
      @shell.say_status :importing, "Aliases database", :cyan
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
      @shell.say_status :imported, "#{@aliases.size} objects", :green
    end

    def blacklist
      @shell.say_status :importing, "Blacklist database", :cyan
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
      @shell.say_status :imported, "#{@blacklist.size} objects", :green
    end

    def niceranks
      @shell.say_status :importing, "Niceranks database", :cyan
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
      @shell.say_status :imported, "#{@niceranks.size} objects", :green
    end

    def users
      @shell.say_status :importing, "Users database", :cyan
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
      @shell.say_status :imported, "#{@users.size} objects", :green
    end

    def pagination
      @shell.say_status :importing, "Pagination database", :cyan
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
      @shell.say_status :imported, "#{@pagination.size} objects", :green
    end

    def index
      @shell.say_status :importing, "Index database", :cyan
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
      @shell.say_status :imported, "#{@index.size} objects", :green
    end

  end
end
