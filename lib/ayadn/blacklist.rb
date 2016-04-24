# encoding: utf-8
module Ayadn
  class Blacklist < Thor

    desc "add TYPE TARGET", "Adds a mention, hashtag, client, username or keyword to your blacklist"
    map "create" => :add
    long_desc Descriptions.blacklist_add
    def add(*args)
      if args.length < 2
        Status.new.type_and_target_missing
        exit
      end
      BlacklistWorkers.new.add(args)
      Status.new.done
    end

    desc "remove TYPE TARGET", "Removes a mention, hashtag, client, username or keyword from your blacklist"
    map "delete" => :remove
    long_desc Descriptions.blacklist_remove
    def remove(*args)
      if args.length < 2
        Status.new.type_and_target_missing
        exit
      end
      BlacklistWorkers.new.remove(args)
      Status.new.done
    end

    desc "list", "List the content of your blacklist"
    long_desc Descriptions.blacklist_list
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in CSV"
    option :compact, aliases: "-k", type: :boolean, desc: "Force the view to be compact if not already"
    def list
      BlacklistWorkers.new.list(options)
    end

    desc "clear", "Clear your blacklist database"
    def clear
      BlacklistWorkers.new.clear
      Status.new.done
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

    def clear
      begin
        Status.new.ask_clear_blacklist
        input = STDIN.getch
        if input == 'y' || input == 'Y'
          Databases.clear_blacklist
          Logs.rec.info "Cleared the blacklist database."
        else
          Status.new.canceled
          exit
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
        when 'word', 'keyword'
          args = args.map { |w| w.gsub(/[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/, "") }
          Databases.add_to_blacklist('word', args)
          Logs.rec.info "Added '#{args}' to blacklist of words."
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
          Databases.remove_from_blacklist('user', args)
          target = @workers.add_arobases_to_usernames(args)
          Logs.rec.info "Removed '#{type}:#{target}' from blacklist of users."
        when 'mention', 'mentions'
          Databases.remove_from_blacklist('mention', args)
          target = @workers.add_arobases_to_usernames(args)
          Logs.rec.info "Removed '#{target}' from blacklist of mentions."
        when 'client', 'source'
          Databases.remove_from_blacklist('client', args)
          Logs.rec.info "Removed '#{type}:#{args}' from blacklist."
        when 'hashtag', 'tag'
          Databases.remove_from_blacklist('hashtag', args)
          Logs.rec.info "Removed '#{type}:#{args}' from blacklist."
        when 'word', 'keyword'
          args = args.map { |w| w.gsub(/[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/, "") }
          Databases.remove_from_blacklist('word', args)
          Logs.rec.info "Removed '#{type}:#{args}' from blacklist."
        else
          Status.new.wrong_arguments
        end
      end
    end
    
    def list(options)
      begin
        Settings.options.timeline.compact = true if options[:compact] == true
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
          puts "\n"
          puts Workers.new.build_blacklist_list(list)
          puts "\n"
        end
      else
        Status.new.empty_list
        exit
      end
    end
  end
end
