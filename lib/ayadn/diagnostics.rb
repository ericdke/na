# encoding: utf-8
module Ayadn

  class Diagnostics < Thor

    desc "nicerank", "Tests the NiceRank API"
    def nicerank
      obj = CheckNiceRank.new
      obj.check
      obj.status.say_end
    end

    desc "adn", "Tests the App.net API"
    def adn
      obj = CheckADN.new
      obj.check
      obj.status.say_end
    end

    desc "accounts", "Tests registered Ayadn accounts"
    def accounts
      obj = CheckAccounts.new
      obj.check
      obj.status.say_end
    end

    desc "ayadn", "Tests the Ayadn Gem"
    def ayadn
      obj = CheckAyadn.new
      obj.check
      obj.status.say_end
    end

    desc "all", "Run all tests"
    def all
      obj = CheckADN.new
      obj.check
      obj = CheckAyadn.new
      obj.check
      obj = CheckAccounts.new
      obj.check
      obj = CheckNiceRank.new
      obj.check
      obj.status.say_end
    end
  end

  class CheckBase

    attr_accessor :response, :status, :baseURL

    def initialize
      @status = Status.new
    end

    def get_response(url)
      @response = RestClient.get(url) {|response, request, result| response}
    end

    def check_response_code
      code = @response.code
      if code == 200
        @status.say_green :status, "OK"
      else
        @status.say_red :status, "#{code}"
      end
    end

    def rescue_network(error)
      begin
        raise error
      rescue RestClient::RequestTimeout => e
        @status.say_error "connection timeout"
        @status.say_trace e
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        @status.say_error "connection problem"
        @status.say_trace e
      rescue Interrupt
        @status.say_error "operation canceled"
        exit
      rescue => e
        @status.say_error "unknown error"
        @status.say_trace e
      end
    end
  end

  class CheckNiceRank < CheckBase

    def check
      begin
        @status.say_header "checking NiceRank server response"
        get_response "http://api.nice.social/user/nicerank?ids=1"
        check_response_code
        ratelimit = @response.headers[:x_ratelimit_remaining]
        if ratelimit.blank?
          @status.say_red :ratelimit, "invalid server response"
        else
          Integer(ratelimit) > 120 ? @status.say_green(:ratelimit, "OK") : @status.say_red(:ratelimit, ratelimit)
        end
      rescue => e
        rescue_network(e)
      end
    end
  end

  class CheckADN < CheckBase

    def check
      begin
        check_root_api
        @status.say_header "checking ADN server response"
        get_response "#{@baseURL}/config"
        check_response_code
        body = JSON.parse(@response.body)
        if body.blank? || body["data"].blank?
          @status.say_red(:config, "no data")
        else
          @status.say_green(:config, "OK")
        end
      rescue => e
        rescue_network(e)
      end
    end

    private

    def check_root_api
      @status.say_header("default root API endpoint")
      api_file = Dir.home + "/ayadn/.api.yml"
      @baseURL = if File.exist?(api_file)
        YAML.load(File.read(api_file))[:root]
      else
        "https://api.app.net"
      end
      @status.say_green(:url, @baseURL)
    end
  end

  class CheckAccounts < CheckBase

    attr_accessor :sql_path, :active_account, :db, :paths, :handle, :userDB

    def initialize
      super
      @sql_path = Dir.home + "/ayadn/accounts.sqlite"
    end

    def check
      begin
        @status.say_header("checking accounts database")
        if find_active_account
          users = @db.execute("SELECT * FROM Accounts")
          if users.blank?
            @status.say_red(:abort, "no registered Ayadn users")
          else
            @status.say_green(:accounts, users.map { |user| user[2] }.join(", "))
            if @active_account.blank?
              @status.say_red(:warning, "no active account")
            else
              @status.say_header("checking active account")
              check_id_handle
              check_token
              check_paths
              check_config
              @status.say_header("checking #{@handle}'s account database")
              if find_active_tables
                check_tables_schemas
              end
            end
          end
        end
      rescue Interrupt
        @status.say_error "operation canceled"
        exit
      rescue Amalgalite::SQLite3::Error => e
        @status.say_error "database error"
        @status.say_trace e
      rescue => e
        @status.say_error "unknown error"
        @status.say_trace e
      end
    end

    private

    def check_token
      token = @active_account[5]
      if token.blank?
        @status.say_red(:missing, "authorization token")
      else
        @status.say_green(:auth_token, token[0..20] + "...")
      end
    end

    def check_tables_schemas
      @status.say_header("checking tables schemas")
      if @userDB.schema.tables.count != 6
        @status.say_red :error, "#{@handle}'s account database is corrupted"
      else
        @userDB.schema.tables.each do |table|
          @status.say_info "checking table #{table[0]}"
          case table[0]
          when "Bookmarks"
            break if !check_bookmarks(table)
          when "Aliases"
            break if !check_aliases(table)
          when "Blacklist"
            break if !check_blacklist(table)
          when "Users"
            break if !check_users(table)
          when "Pagination"
            break if !check_pagination(table)
          when "TLIndex"
            break if !check_TLIndex(table)
          end
        end
      end
    end

    def check_bookmarks(table)
      if table[1].columns.count != 2
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "post_id" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          elsif name == "bookmark" && data.declared_data_type == "TEXT"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_aliases(table)
      if table[1].columns.count != 2
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "channel_id" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          elsif name == "alias" && data.declared_data_type == "VARCHAR(255)"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_blacklist(table)
      if table[1].columns.count != 2
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "type" && data.declared_data_type == "VARCHAR(255)"
            @status.say_green(name.to_sym, "OK")
          elsif name == "content" && data.declared_data_type == "TEXT"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_users(table)
      if table[1].columns.count != 3
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "user_id" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          elsif name == "username" && data.declared_data_type == "VARCHAR(20)"
            @status.say_green(name.to_sym, "OK")
          elsif name == "name" && data.declared_data_type == "TEXT"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_pagination(table)
      if table[1].columns.count != 2
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "name" && data.declared_data_type == "TEXT"
            @status.say_green(name.to_sym, "OK")
          elsif name == "post_id" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_TLIndex(table)
      if table[1].columns.count != 3
        @status.say_red :error, "#{table[0]} table is corrupted"
        return false
      else
        table[1].columns.each do |name, data|
          if name == "count" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          elsif name == "post_id" && data.declared_data_type == "INTEGER"
            @status.say_green(name.to_sym, "OK")
          elsif name == "content" && data.declared_data_type == "TEXT"
            @status.say_green(name.to_sym, "OK")
          else
            @status.say_red :error, "#{table[0]} table is corrupted"
            return false
          end
        end
      end
      return true
    end

    def check_config
      @status.say_header("checking active account settings")
      config_path = @paths[:config] + "/config.yml"
      config = YAML.load(File.read(config_path))
      if config.blank?
        @status.say_error("active user has no config file")
      else
        @status.say_green(:found, "active user config file")
        @status.say_header("difference default/current")
        diff = Settings.defaults.deep_diff(config)
        if diff.blank?
          @status.say_green(:pass, "current user is using default values")
        else
          diff.each do |key, value|
            skip if key == :movie || key == :tvshow # those are deprecated, not missing
            if value.is_a?(Hash)
              value.each do |inner_key, inner_value|
                default = inner_value[0].nil? ? "none" : inner_value[0]
                current = if inner_key == :deezer
                  inner_value[1].nil? ? "none" : inner_value[1][:code][0..10] + "..."
                else
                  inner_value[1].nil? ? "none" : inner_value[1]
                end
                @status.say_green(:changed, "#{key}/#{inner_key} - Default: #{default}, Current: #{current}")
              end
            else
              default = value[0].nil? ? "none" : value[0]
              val = value[1]
              if val.nil?
                @status.say_red(:missing, "#{key} - Default: #{default}, Current: none")
              else
                @status.say_green(:changed, "#{key} - Default: #{default}, Current: #{val}")
              end
            end
          end
        end
      end
    end

    def check_id_handle
      id = @active_account[1]
      @status.say_green(:id, id)
      @handle = @active_account[2]
      @status.say_green(:username, @handle)
    end

    def check_paths
      home = @active_account[3]
      @status.say_green(:path, home)
      @paths = {
        log: "#{home}/log",
        db: "#{home}/db",
        config: "#{home}/config",
        downloads: "#{home}/downloads",
        posts: "#{home}/posts",
        messages: "#{home}/messages",
        lists: "#{home}/lists"
      }
      @paths.each do |key, value|
        if Dir.exist?(value)
          @status.say_green(key, value)
        else
          @status.say_red(:missing, value)
        end
      end
    end

    def find_active_account
      if File.exist?(@sql_path)
        @status.say_green(:found, "database accounts file")
        @db = Amalgalite::Database.new(@sql_path)
        if @db.nil?
          @status.say_red :error, "accounts database is not readable"
          return false
        else
          @active_account = Databases.active_account(@db)
        end
      else
        @status.say_red :error, "accounts database is missing"
        return false
      end
      return true
    end

    def find_active_tables
      tables_path = @paths[:db] + "/ayadn.sqlite"
      if File.exist?(tables_path)
        @status.say_green(:found, "#{@handle}'s database file")
        @userDB = Amalgalite::Database.new(tables_path)
        if @userDB.nil?
          @status.say_red :error, "#{@handle}'s database is not readable"
          return false
        end
      else
        @status.say_red :error, "#{@handle}'s database is missing"
        return false
      end
      return true
    end
  end

  class CheckAyadn < CheckBase

    attr_accessor :response

    def check
      begin
        @status.say_header "checking RubyGems server response"
        get_response "https://rubygems.org/api/v1/gems/ayadn.json"
        check_response_code
        @status.say_header "checking Ayadn version"
        info = JSON.parse(@response.body)
        live = info["version"]
        @status.say_green(:live, "version #{live}")
        if live != VERSION
          @status.say_red(:local, "version #{VERSION}")
          @status.say { @status.say_yellow :update, "run 'gem update ayadn' to get the last version" }
        else
          @status.say_green(:local, "version #{VERSION}")
        end
      rescue JSON::ParserError => e
        @status.say_error "JSON error"
        @status.say_trace e
      rescue Interrupt
        @status.say_error "operation canceled"
        exit
      rescue => e
        rescue_network(e)
      end
    end

  end

end