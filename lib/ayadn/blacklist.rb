# encoding: utf-8
module Ayadn
  class Blacklist < Thor
    desc "blacklist add TYPE TARGET", "Adds a mention, hashtag or client to your blacklist"
    long_desc Descriptions.blacklist_add
    def add(*args)
      if args.length != 2
        puts Status.type_and_target_missing
      end
      blacklist = BlacklistWorkers.new
      blacklist.add(args)
      puts Status.done
    end

    desc "blacklist remove TYPE TARGET", "Removes a mention, hashtag or client from your blacklist"
    long_desc Descriptions.blacklist_remove
    def remove(*args)
      if args.length != 2
        puts Status.type_and_target_missing
      end
      blacklist = BlacklistWorkers.new
      blacklist.remove(args)
      puts Status.done
    end

    desc "blacklist list", "List the content of your blacklist"
    long_desc Descriptions.blacklist_list
    def list
      blacklist = BlacklistWorkers.new
      blacklist.list
    end

    desc "blacklist import DATABASE", "Imports a blacklist database from another Ayadn account"
    long_desc Descriptions.blacklist_import
    def import(database)
      blacklist = BlacklistWorkers.new
      blacklist.import(database)
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
          Logs.rec.info "Imported #{new_db} values in blacklist database."
        else
          puts "\nFile '#{new_db}' doesn't exist.\n\n".color(:red)
          Logs.rec.warn "File '#{new_db}' doesn't exist."
        end
      ensure
        Databases.close_all
      end
    end
    def add(args)
      begin
        type, target = args[0], args[1]
        case type
        when 'mention', 'mentions'
          target = Workers.add_arobase_if_missing([target])
          Databases.add_mention_to_blacklist(target)
          Logs.rec.info "Added #{target} to blacklist of mentions."
        when 'client', 'source'
          Databases.add_client_to_blacklist(target)
          Logs.rec.info "Added #{target} to blacklist of clients."
        when 'hashtag', 'tag'
          Databases.add_hashtag_to_blacklist(target)
          Logs.rec.info "Added #{target} to blacklist of hashtags."
        else
          puts Status.wrong_arguments
        end
      ensure
        Databases.close_all
      end
    end
    def remove(args)
      begin
        type, target = args[0], args[1]
        case type
        when 'mention', 'mentions'
          target = Workers.add_arobase_if_missing([target])
          Databases.remove_from_blacklist(target)
          Logs.rec.info "Removed #{target} from blacklist of mentions."
        when 'client', 'source', 'hashtag', 'tag'
          Databases.remove_from_blacklist(target)
          Logs.rec.info "Removed #{type}:#{target} from blacklist."
        else
          puts Status.wrong_arguments
        end
      ensure
        Databases.close_all
      end
    end
    def list
      begin
        list = Databases.blacklist
        unless list.empty?
          puts Workers.new.build_blacklist_list(list)
        else
          abort(Status.empty_list)
        end
      ensure
        Databases.close_all
      end
    end
  end
end
