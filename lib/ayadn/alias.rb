# encoding: utf-8
module Ayadn
  class Alias < Thor

    desc "create CHANNEL ALIAS", "Creates an alias for a channel"
    map "add" => :create
    long_desc Descriptions.alias_create
    def create(*args)
      begin
        init
        unless args.empty?
          channel, channel_alias = args[0], args[1]
        else
          Action.quit Status.wrong_arguments
        end
        if channel.is_integer?
          Databases.create_alias(channel, channel_alias)
          Logs.rec.info "Added alias '#{channel_alias}' for channel #{channel}."
          puts Status.done
        else
          puts Status.error_missing_channel_id
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      ensure
        Databases.close_all
      end
    end

    desc "delete ALIAS", "Deletes a previously created alias"
    map "remove" => :delete
    long_desc Descriptions.alias_delete
    def delete(*args)
      begin
        init
        unless args.empty?
          Databases.delete_alias(args[0])
          Logs.rec.info "Deleted alias '#{args[0]}'."
          puts Status.done
        else
          Action.quit Status.wrong_arguments
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      ensure
        Databases.close_all
      end
    end

    desc "import DATABASE", "Imports an aliases database from a backed up Ayadn account"
    long_desc Descriptions.alias_import
    def import(database)
      begin
        init
        unless database.nil?
          new_db = File.realpath(database)
        else
          Action.quit Status.wrong_arguments
        end
        if File.exist?(new_db)
          Databases.import_aliases(new_db)
          Logs.rec.info "Imported '#{new_db}' values in aliases database."
          puts Status.done
        else
          puts "\nFile '#{new_db}' doesn't exist.".color(:red)
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [database]})
      ensure
        Databases.close_all
      end
    end

    desc "list", "List previously created aliases"
    long_desc Descriptions.alias_list
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in JSON"
    def list
      begin
        init
        list = Databases.aliases
        unless list.empty? || list.nil?
          if options[:raw]
            h = {}
            list.each {|k,v| h[k] = v}
            puts h.to_json
          else
            View.new.page Workers.new.build_aliases_list(list)
          end
        else
          puts Status.empty_list
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
      ensure
        Databases.close_all
      end
    end

    desc "clear", "Clear your aliases database"
    def clear
      begin
        init
        puts "\n\nAre you sure you want to erase all the content of your aliases database?\n\n[y/N]\n".color(:red)
        input = STDIN.getch
        if input == 'y' || input == 'Y'
          Databases.clear_aliases
          Logs.rec.info "Cleared the aliases database."
          puts Status.done
        else
          abort Status.canceled
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: []})
      ensure
        Databases.close_all
      end
    end

    private

    def init
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

  end
end
