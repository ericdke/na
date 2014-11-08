# encoding: utf-8
module Ayadn
  class Alias < Thor

    desc "create CHANNEL ALIAS", "Creates an alias for a channel"
    map "add" => :create
    long_desc Descriptions.alias_create
    def create(*args)
      begin
        init
        status = Status.new
        unless args.empty?
          channel, channel_alias = args[0], args[1]
        else
          status.wrong_arguments
          exit
        end
        if channel.is_integer?
          Databases.create_alias(channel, channel_alias)
          Logs.rec.info "Added alias '#{channel_alias}' for channel #{channel}."
          puts Status.done
        else
          status.error_missing_channel_id
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
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
          Status.new.wrong_arguments
          exit
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [args]})
      end
    end

    desc "list", "List previously created aliases"
    long_desc Descriptions.alias_list
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in JSON"
    def list
      begin
        init
        list = Databases.all_aliases
        unless list.empty? || list.nil?
          if options[:raw]
            puts list.to_json
          else
            View.new.page Workers.new.build_aliases_list(list)
          end
        else
          Status.new.empty_list
        end
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [options]})
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
