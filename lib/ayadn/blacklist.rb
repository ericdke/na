# encoding: utf-8
module Ayadn
  class Blacklist < Thor
    desc "add TYPE TARGET", "Adds a mention, hashtag, client or username to your blacklist"
    map "create" => :add
    long_desc Descriptions.blacklist_add
    def add(*args)
      Action.quit(Status.type_and_target_missing) if args.length < 2
      BlacklistWorkers.new.add(args)
      puts Status.done
    end

    desc "remove TYPE TARGET", "Removes a mention, hashtag, client or username from your blacklist"
    map "delete" => :remove
    long_desc Descriptions.blacklist_remove
    def remove(*args)
      Action.quit(Status.type_and_target_missing) if args.length < 2
      BlacklistWorkers.new.remove(args)
      puts Status.done
    end

    desc "list", "List the content of your blacklist"
    long_desc Descriptions.blacklist_list
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in CSV"
    def list
      BlacklistWorkers.new.list(options)
    end

    desc "import DATABASE", "Imports a blacklist database from another Ayadn account"
    long_desc Descriptions.blacklist_import
    def import(database)
      BlacklistWorkers.new.import(database)
    end

    desc "convert", "Convert your current blacklist database to the new format"
    long_desc Descriptions.blacklist_convert
    def convert
      BlacklistWorkers.new.convert
      puts Status.done
    end

    desc "clear", "Clear your blacklist database"
    def clear
      BlacklistWorkers.new.clear
      puts Status.done
    end

  end

  class BlacklistWorkers
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end
    def import(database)
      begin
        new_db = File.realpath(database)
        if File.exist?(new_db)
          Databases.import_blacklist(new_db)
          Logs.rec.info "Imported '#{new_db}' values in blacklist database."
        else
          puts "\nFile '#{new_db}' doesn't exist.\n\n".color(:red)
          Logs.rec.warn "File '#{new_db}' doesn't exist."
        end
      ensure
        Databases.close_all
      end
    end
    def convert
      begin
        Databases.convert_blacklist
      ensure
        Databases.close_all
      end
    end
    def clear
      begin
        puts "\n\nAre you sure you want to erase all the content of your blacklist database?\n\n[y/N]\n".color(:red)
        input = STDIN.getch
        if input == 'y' || input == 'Y'
          Databases.clear_blacklist
          Logs.rec.info "Cleared the blacklist database."
        else
          abort Status.canceled
        end
      ensure
        Databases.close_all
      end
    end
    def add(args)
      begin
        type = args.shift
        case type
        when 'user', 'username', 'account'
          target = Workers.add_arobases_to_usernames args
          Databases.add_user_to_blacklist(target)
          Logs.rec.info "Added '#{target}' to blacklist of users."
        when 'mention', 'mentions'
          target = Workers.add_arobases_to_usernames args
          Databases.add_mention_to_blacklist(target)
          Logs.rec.info "Added '#{target}' to blacklist of mentions."
        when 'client', 'source'
          Databases.add_client_to_blacklist(args)
          Logs.rec.info "Added '#{args}' to blacklist of clients."
        when 'hashtag', 'tag'
          Databases.add_hashtag_to_blacklist(args)
          Logs.rec.info "Added '#{args}' to blacklist of hashtags."
        else
          puts Status.wrong_arguments
        end
      ensure
        Databases.close_all
      end
    end
    def remove(args)
      begin
        type = args.shift
        case type
        when 'user', 'username', 'account'
          temp = Workers.add_arobases_to_usernames args
          target = temp.map {|u| "-#{u}"}
          Databases.remove_from_blacklist(target)
          Logs.rec.info "Removed '#{target}' from blacklist of users."
        when 'mention', 'mentions'
          target = Workers.add_arobases_to_usernames args
          Databases.remove_from_blacklist(target)
          Logs.rec.info "Removed '#{target}' from blacklist of mentions."
        when 'client', 'source', 'hashtag', 'tag'
          Databases.remove_from_blacklist(args)
          Logs.rec.info "Removed '#{type}:#{args}' from blacklist."
        else
          puts Status.wrong_arguments
        end
      ensure
        Databases.close_all
      end
    end
    def list(options)
      begin
        show_list(options)
      ensure
        Databases.close_all
      end
    end

    private

    def show_list(options)
      list = Databases.blacklist
      unless list.empty?
        if options[:raw]
          list.each {|v,k| puts "#{v},#{k}"}
        else
          puts Workers.new.build_blacklist_list(list)
        end
      else
        abort(Status.empty_list)
      end
    end
  end
end
