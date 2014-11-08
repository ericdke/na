# encoding: utf-8
module Ayadn
  class Blacklist < Thor
    desc "add TYPE TARGET", "Adds a mention, hashtag, client or username to your blacklist"
    map "create" => :add
    long_desc Descriptions.blacklist_add
    def add(*args)
      if args.length < 2
        Status.new.type_and_target_missing
        exit
      end
      BlacklistWorkers.new.add(args)
      puts Status.done
    end

    desc "remove TYPE TARGET", "Removes a mention, hashtag, client or username from your blacklist"
    map "delete" => :remove
    long_desc Descriptions.blacklist_remove
    def remove(*args)
      if args.length < 2
        Status.new.type_and_target_missing
        exit
      end
      BlacklistWorkers.new.remove(args)
      puts Status.done
    end

    desc "list", "List the content of your blacklist"
    long_desc Descriptions.blacklist_list
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in CSV"
    def list
      BlacklistWorkers.new.list(options)
    end

    # desc "import DATABASE", "Imports a blacklist database from another Ayadn account"
    # long_desc Descriptions.blacklist_import
    # def import(database)
    #   BlacklistWorkers.new.import(database)
    # end

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
      @workers = Workers.new
    end
    # def import(database)
    #   begin
    #     new_db = File.realpath(database)
    #     if File.exist?(new_db)
    #       Databases.import_blacklist(new_db)
    #       Logs.rec.info "Imported '#{new_db}' values in blacklist database."
    #     else
    #       puts "\nFile '#{new_db}' doesn't exist.\n\n".color(:red)
    #       Logs.rec.warn "File '#{new_db}' doesn't exist."
    #     end
    #   end
    # end
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
      end
    end
    def add(args)
      begin
        type = args.shift
        case type
        when 'user', 'username', 'account'
          target = @workers.remove_arobase_if_present(args)
          Databases.add_to_blacklist('user', target)
          target = @workers.add_arobases_to_usernames args
          Logs.rec.info "Added '#{target}' to blacklist of users."
        when 'mention', 'mentions'
          target = @workers.remove_arobase_if_present(args)
          Databases.add_to_blacklist('mention', target)
          target = @workers.add_arobases_to_usernames args
          Logs.rec.info "Added '#{target}' to blacklist of mentions."
        when 'client', 'source'
          Databases.add_to_blacklist('client', args)
          Logs.rec.info "Added '#{args}' to blacklist of clients."
        when 'hashtag', 'tag'
          Databases.add_to_blacklist('hashtag', args)
          Logs.rec.info "Added '#{args}' to blacklist of hashtags."
        else
          Status.new.wrong_arguments
        end
      end
    end
    def remove(args)
      begin
        type = args.shift
        case type
        when 'user', 'username', 'account'
          Databases.remove_from_blacklist(args)
          target = @workers.add_arobases_to_usernames(args)
          Logs.rec.info "Removed '#{target}' from blacklist of users."
        when 'mention', 'mentions'
          Databases.remove_from_blacklist(args)
          target = @workers.add_arobases_to_usernames(args)
          Logs.rec.info "Removed '#{target}' from blacklist of mentions."
        when 'client', 'source', 'hashtag', 'tag'
          Databases.remove_from_blacklist(args)
          Logs.rec.info "Removed '#{type}:#{args}' from blacklist."
        else
          Status.new.wrong_arguments
        end
      end
    end
    def list(options)
      begin
        show_list(options)
      end
    end

    private

    def show_list(options)
      list = Databases.all_blacklist
      unless list.empty?
        if options[:raw]
          xx = list.map {|obj| [obj[0], obj[1].to_s.force_encoding("UTF-8")] }
          puts xx.to_json
        else
          puts Workers.new.build_blacklist_list(list)
        end
      else
        Status.new.empty_list
        exit
      end
    end
  end
end
