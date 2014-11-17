# encoding: utf-8
module Ayadn
  class Migration

    begin
      require 'daybreak'
    rescue LoadError => e
      puts "\nAYADN: Error while loading Gems\n\n"
      puts "RUBY: #{e}\n\n"
      exit
    end

    def initialize
      @still = false
      @thor = Thor::Shell::Color.new
      accounts_old = Dir.home + "/ayadn/accounts.db"
      unless File.exist?(accounts_old)
        puts "\n"
        @thor.say_status :error, "can't find the Ayadn 1.x accounts database", :red
        @thor.say_status :canceled, "migration canceled", :red
        puts "\n"
        exit
      end
      begin
        @accounts = Daybreak::DB.new(accounts_old)
        # just in case of a previous canceled migration
        # which could have left the accounts.db in place
        if @accounts.size == 1 || @accounts.size == 0
          @accounts.close
          File.delete(Dir.home + "/ayadn/accounts.db")
          @thor.say_status :delete, Dir.home + "/ayadn/accounts.db", :yellow
          @thor.say_status :stopped, "no more accounts to migrate", :green
          exit
        end
        @active_old = @accounts['ACTIVE']
        @home = @accounts[@active_old][:path]
        bookmarks_old = "#{@home}/db/bookmarks.db"
        aliases_old = "#{@home}/db/aliases.db"
        blacklist_old = "#{@home}/db/blacklist.db"
        users_old = "#{@home}/db/users.db"
        @pagination_old = "#{@home}/pagination/pagination.db"
        @index_old = "#{@home}/pagination/index.db"

        @config_path_old = "#{@home}/config/config.yml"

        @bookmarks = Daybreak::DB.new(bookmarks_old) if File.exist?(bookmarks_old)
        @aliases = Daybreak::DB.new(aliases_old) if File.exist?(aliases_old)
        @blacklist = Daybreak::DB.new(blacklist_old) if File.exist?(blacklist_old)
        @users = Daybreak::DB.new(users_old) if File.exist?(users_old)
        @pagination = Daybreak::DB.new(@pagination_old) if File.exist?(@pagination_old)
        @index = Daybreak::DB.new(@index_old) if File.exist?(@index_old)

        @sqlfile = "#{@home}/db/ayadn.sqlite"
        @sql = Amalgalite::Database.new(@sqlfile)
      rescue Exception => e
        puts "\n"
        @thor.say_status :error, "#{e}", :red
        @thor.say_status :stack, "#{caller}", :red
        @thor.say_status :canceled, "migration canceled", :red
        puts "\n"
        exit
      end
    end

    def all
      # DON'T MODIFY THE ORDER!
      puts banner()
      puts "\n"
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
      bookmarks()
      aliases()
      blacklist()
      niceranks()
      users()
      pagination()
      index()
      accounts()
      config()
      @thor.say_status :done, "migration", :yellow
      puts "\n"
      if @still != false
        @thor.say_status :WARNING, "another user, @#{@still}, is still in the old database", :red
        @thor.say_status :PLEASE, "you should run `ayadn migrate` again right now", :yellow
        puts "\n"
      else
        @thor.say_status :ok, "ready to go!", :green
        @thor.say_status :thanks, "you can use Ayadn now", :cyan
        puts "\n"
      end
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
      @thor.say_status :import, "account informations", :cyan
      if sql.schema.tables.empty?
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
      end
      active, active_account = ""
      @accounts.each do |k,v|
        if k == "ACTIVE"
          active_account = v
          next
        end
      end
      actives = sql.execute("SELECT user_id FROM Accounts WHERE active=1")
      sql.execute("UPDATE Accounts SET active=0") unless actives.empty?
      sql.transaction do |db_in_transaction|
        active = [@accounts[active_account]]
        @thor.say_status :delete, "old @#{active_account} account", :green
        @accounts.delete(active_account)
        if @accounts.size == 1 # only the 'ACTIVE' label, so it's like 0
          @accounts.close
          File.delete(Dir.home + "/ayadn/accounts.db")
          @thor.say_status :delete, Dir.home + "/ayadn/accounts.db", :green
        else
          @accounts.each do |k,v|
            next if k == "ACTIVE"
            @accounts['ACTIVE'] = v[:username]
            @still = v[:username]
            break
          end
          @accounts.close
        end
        active.each do |obj|
          insert_data = {}
          insert_data[":username"] = obj[:username]
          insert_data[":user_id"] = obj[:id].to_i
          insert_data[":handle"] = obj[:handle]
          insert_data[":account_path"] = obj[:path]
          insert_data[":active"] = 1
          template = Dir.home + "/ayadn/#{obj[:username]}/auth/token"
          insert_data[":token"] = File.read(template)
          db_in_transaction.prepare("INSERT INTO Accounts(username, user_id, handle, account_path, active, token) VALUES(:username, :user_id, :handle, :account_path, :active, :token);") do |insert|
            insert.execute(insert_data)
          end
        end
      end
      @thor.say_status :imported, "@#{active_account} account", :green
    end

    def config
      @thor.say_status :load, "config file", :blue
      old_conf = YAML.load(File.read(@config_path_old))
      conf = Settings.defaults
      @thor.say_status :convert, "settings", :cyan
      conf[:timeline][:source] = old_conf[:timeline][:show_source] || true
      conf[:timeline][:symbols] = old_conf[:timeline][:show_symbols] || true
      conf[:timeline][:name] = old_conf[:timeline][:show_real_name] || true
      conf[:timeline][:date] = old_conf[:timeline][:show_date] || true
      conf[:timeline][:debug] = old_conf[:timeline][:show_debug] || false
      conf[:timeline][:compact] = old_conf[:timeline][:compact] || false
      if old_conf[:timeline][:directed] == 1 || old_conf[:timeline][:directed] == true
        conf[:timeline][:directed] = true
      else
        conf[:timeline][:directed] = false
      end
      if old_conf[:marker].nil?
        conf[:marker] = { messages: true }
      else
        conf[:marker][:messages] = old_conf[:marker][:update_messages] || true  
      end
      conf[:backup][:posts] = old_conf[:backup][:auto_save_sent_posts] || false
      conf[:backup][:messages] = old_conf[:backup][:auto_save_sent_messages] || false
      conf[:backup][:lists] = old_conf[:backup][:auto_save_lists] || false
      conf[:colors][:id] = old_conf[:colors][:id] || :blue
      conf[:colors][:index] = old_conf[:colors][:index] || :red
      conf[:colors][:username] = old_conf[:colors][:username] || :green
      conf[:colors][:name] = old_conf[:colors][:name] || :magenta
      conf[:colors][:debug] = old_conf[:colors][:debug] || :red
      conf[:colors][:date] = old_conf[:colors][:date] || :cyan
      conf[:colors][:link] = old_conf[:colors][:link] || :yellow
      conf[:colors][:dots] = old_conf[:colors][:dots] || :blue
      conf[:colors][:hashtags] = old_conf[:colors][:hashtags] || :cyan
      conf[:colors][:debug] = old_conf[:colors][:debug] || :red
      conf[:colors][:mentions] = old_conf[:colors][:mentions] || :red
      conf[:colors][:source] = old_conf[:colors][:source] || :cyan
      conf[:colors][:symbols] = old_conf[:colors][:symbols] || :green
      conf[:colors][:unread] = old_conf[:colors][:unread] || :cyan
      conf[:formats][:list] = old_conf[:formats][:list] || {}
      conf[:formats][:list][:reverse] = old_conf[:formats][:list][:reverse] || true
      conf[:formats][:table] = old_conf[:formats][:table] || {}
      conf[:formats][:table][:width] = old_conf[:formats][:table][:width] || 75
      conf[:formats][:table][:borders] = old_conf[:formats][:table][:borders] || true
      conf[:scroll][:spinner] = old_conf[:timeline][:show_spinner] || true
      conf[:scroll][:timer] = old_conf[:scroll][:timer] || 3
      conf[:movie][:hashtag] = old_conf[:movie][:hashtag] || 'nowwatching'
      conf[:tvshow][:hashtag] = old_conf[:tvshow][:hashtag] || 'nowwatching'
      conf[:channels][:links] = old_conf[:timeline][:show_channel_oembed] || true
      conf[:nicerank][:threshold] = old_conf[:nicerank][:threshold] || 2.1
      conf[:nicerank][:filter] = old_conf[:nicerank][:filter] || true
      conf[:counts][:defaults] = old_conf[:counts][:defaults] || 50
      conf[:counts][:unified] = old_conf[:counts][:unified] || 50
      conf[:counts][:global] = old_conf[:counts][:global] || 50
      conf[:counts][:checkins] = old_conf[:counts][:checkins] || 50
      conf[:counts][:conversations] = old_conf[:counts][:conversations] || 50
      conf[:counts][:photos] = old_conf[:counts][:photos] || 50
      conf[:counts][:trending] = old_conf[:counts][:trending] || 50
      conf[:counts][:mentions] = old_conf[:counts][:mentions] || 50
      conf[:counts][:convo] = old_conf[:counts][:convo] || 50
      conf[:counts][:posts] = old_conf[:counts][:posts] || 50
      conf[:counts][:messages] = old_conf[:counts][:messages] || 50
      conf[:counts][:search] = old_conf[:counts][:search] || 200
      conf[:counts][:whoreposted] = old_conf[:counts][:whoreposted] || 20
      conf[:counts][:whostarred] = old_conf[:counts][:whostarred] || 20
      conf[:counts][:whatstarred] = old_conf[:counts][:whatstarred] || 100
      conf[:counts][:files] = old_conf[:counts][:files] || 50
      @thor.say_status :save, "config file", :green
      File.write(@config_path_old, conf.to_yaml)
    end

    def banner
      <<-BANNER

\t\t     _____ __ __ _____ ____  _____
\t\t    |  _  |  |  |  _  |    \\|   | |
\t\t    |     |_   _|     |  |  | | | |
\t\t    |__|__| |_| |__|__|____/|_|___|


      BANNER
    end

  end
end
