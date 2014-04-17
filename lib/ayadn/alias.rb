# encoding: utf-8
module Ayadn
  class Alias < Thor

    desc "create CHANNEL ALIAS", "Creates an alias for a channel"
    long_desc Descriptions.alias_create
    def create(*args)
      begin
        init
        unless args.empty?
          channel, channel_alias = args[0], args[1]
        else
          puts Status.wrong_arguments
          exit
        end
        if channel.is_integer?
          Databases.create_alias(channel, channel_alias)
          Logs.rec.info "Added alias '#{channel_alias}' for channel #{channel}."
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

    desc "delete ALIAS", "Deletes a previously created alias"
    long_desc Descriptions.alias_delete
    def delete(*args)
      begin
        init
        unless args.empty?
          Databases.delete_alias(args[0])
          Logs.rec.info "Deleted alias '#{args[0]}'."
          puts Status.done
        else
          puts Status.wrong_arguments
          exit
        end
      rescue => e
        Errors.global_error("alias/delete", args, e)
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
          puts Status.wrong_arguments
          exit
        end
        if File.exist?(new_db)
          Databases.import_aliases(new_db)
          Logs.rec.info "Imported '#{new_db}' values in aliases database."
          puts Status.done
        else
          puts "\nFile '#{new_db}' doesn't exist.".color(:red)
        end
      rescue => e
        Errors.global_error("alias/import", database, e)
      ensure
        Databases.close_all
      end
    end

    desc "list", "List previously created aliases"
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
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
      Databases.open_databases
    end

  end
end
