module Ayadn
  class Alias < Thor

    desc "alias create CHANNEL ALIAS", "Creates an alias for a channel"
    long_desc Descriptions.alias_create
    def create(*args)
      begin
        init
        channel, channel_alias = args[0], args[1]
        if channel.is_integer?
          Databases.create_alias(channel, channel_alias)
          puts Status.done
        else
          puts Status.error_missing_channel_id
        end
      rescue => e
        Errors.global_error("alias/create", args, e)
      ensure
        Databases.close_all
      end
    end

    desc "alias delete ALIAS", "Deletes a previously created alias"
    long_desc Descriptions.alias_delete
    def delete(*args)
      begin
        init
        Databases.delete_alias(args[0])
        puts Status.done
      rescue => e
        Errors.global_error("alias/delete", args, e)
      ensure
        Databases.close_all
      end
    end

    desc "alias list", "List previously created aliases"
    long_desc Descriptions.alias_list
    def list
      begin
        init
        puts "\e[H\e[2J"
        list = Databases.aliases
        unless list.empty? || list.nil?
          puts Workers.new.build_aliases_list(list)
          puts "\n"
        else
          puts Status.empty_list
        end
      rescue => e
        Errors.global_error("alias/list", args, e)
      ensure
        Databases.close_all
      end
    end

    private

    def init
      MyConfig.load_config
      Logs.create_logger
      Databases.open_databases
    end

  end
end
