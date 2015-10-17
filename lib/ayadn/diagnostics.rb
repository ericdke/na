# encoding: utf-8
module Ayadn

  class Diagnostics < Thor

    desc "nicerank", "Tests the NiceRank API"
    def nicerank
      obj = CheckNiceRank.new
      obj.check
      obj.say_end
    end

    desc "adn", "Tests the App.net API"
    def adn
      obj = CheckADN.new
      obj.check
      obj.say_end
    end

    desc "accounts", "Tests registered Ayadn accounts"
    def accounts
      obj = CheckAccounts.new
      obj.check
      obj.say_end
    end

    desc "ayadn", "Tests the Ayadn Gem"
    def ayadn
      obj = CheckAyadn.new
      obj.check
      obj.say_end
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
      obj.say_end
    end
  end

  class CheckBase

    attr_accessor :response

    def initialize
      @thor = Thor::Shell::Color.new
      @status = Status.new
    end

    def say_error(message)
      @thor.say_status :error, message, :red
    end

    def say_info(message)
      @thor.say_status :info, message, :cyan
    end

    def say_green(tag, message)
      @thor.say_status tag, message, :green
    end

    def say_red(tag, message)
      @thor.say_status tag, message, :red
    end

    def say_end
      @status.say { say_green :done, "end of diagnostics" }
    end

    def say_header(message)
      @status.say { say_info message }
    end

    def say_text(text)
      @status.say { puts text }
    end

    def say_trace(message)
      @status.say { @thor.say_status :message, message, :yellow }
    end

    def get_response(url)
      @response = RestClient.get(url) {|response, request, result| response}
    end

    def check_response_code
      code = @response.code
      if code == 200
        say_green :status, "OK"
      else
        say_red :status, "#{code}"
      end
    end

    def rescue_network(error)
      begin
        raise error
      rescue RestClient::RequestTimeout => e
        say_error "connection timeout"
        say_trace e
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        say_error "connection problem"
        say_trace e
      rescue Interrupt
        say_error "operation canceled"
        exit
      rescue => e
        say_error "unknown error"
        say_trace e
      end
    end
  end

  class CheckNiceRank < CheckBase

    def check
      begin
        say_header "checking NiceRank server response"
        get_response "http://api.nice.social/user/nicerank?ids=1"
        check_response_code
        ratelimit = @response.headers[:x_ratelimit_remaining]
        if ratelimit.blank?
          say_red :ratelimit, "invalid server response"
        else
          Integer(ratelimit) > 120 ? say_green(:ratelimit, "OK") : say_red(:ratelimit, ratelimit)
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
        say_header "checking ADN server response"
        get_response "https://api.app.net/config"
        check_response_code
        body = JSON.parse(@response.body)
        if body.blank? || body["data"].blank?
          say_red(:config, "no data")
        else
          say_green(:config, "OK")
        end
      rescue => e
        rescue_network(e)
      end
    end

    private

    def check_root_api
      say_header("default root API endpoint")
      api_file = Dir.home + "/ayadn/.api.yml"
      baseURL = if File.exist?(api_file)
        YAML.load(File.read(api_file))[:root]
      else
        "https://api.app.net"
      end
      say_green(:url, baseURL)
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
        say_header("checking accounts database")
        if find_active_account == true
          users = @db.execute("SELECT * FROM Accounts")
          if users.blank?
            say_red(:abort, "no registered Ayadn users")
          else
            say_green(:accounts, users.map { |user| user[2] }.join(", "))
            if @active_account.blank?
              say_red(:warning, "no active account")
            else
              say_header("checking active account")
              check_id_handle
              token = @active_account[5]
              if token.blank?
                say_red(:missing, "authorization token")
              else
                say_green(:auth_token, token[0..20] + "...")
              end
              check_paths
              check_config
              say_header("checking #{@handle}'s account database")
              if find_active_tables == true
                say_header("checking tables schemas")
                if @userDB.schema.tables.count != 6
                  say_red :error, "#{@handle}'s account database is corrupted"
                else
                  @userDB.schema.tables.each do |a|
                    say_info "checking table #{a[0]}"
                    case a[0]
                    when "Bookmarks"
                      if a[1].columns.count != 2
                        say_red :error, "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "post_id" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          elsif name == "bookmark" && data.declared_data_type == "TEXT"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    when "Aliases"
                      if a[1].columns.count != 2
                        say_red :error, "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "channel_id" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          elsif name == "alias" && data.declared_data_type == "VARCHAR(255)"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    when "Blacklist"
                      if a[1].columns.count != 2
                        say_red :error, "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "type" && data.declared_data_type == "VARCHAR(255)"
                            say_green(name.to_sym, "OK")
                          elsif name == "content" && data.declared_data_type == "TEXT"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    when "Users"
                      if a[1].columns.count != 3
                        say_red :error, "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "user_id" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          elsif name == "username" && data.declared_data_type == "VARCHAR(20)"
                            say_green(name.to_sym, "OK")
                          elsif name == "name" && data.declared_data_type == "TEXT"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    when "Pagination"
                      if a[1].columns.count != 2
                        say_red "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "name" && data.declared_data_type == "TEXT"
                            say_green(name.to_sym, "OK")
                          elsif name == "post_id" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    when "TLIndex"
                      if a[1].columns.count != 3
                        say_red "#{a[0]} table is corrupted"
                      else
                        a[1].columns.each do |name, data|
                          if name == "count" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          elsif name == "post_id" && data.declared_data_type == "INTEGER"
                            say_green(name.to_sym, "OK")
                          elsif name == "content" && data.declared_data_type == "TEXT"
                            say_green(name.to_sym, "OK")
                          else
                            say_red :error, "#{a[0]} table is corrupted"
                            break
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      rescue Interrupt
        say_error "operation canceled"
        exit
      rescue Amalgalite::SQLite3::Error => e
        say_error "database error"
        say_trace e
      rescue => e
        say_error "unknown error"
        say_trace e
      end
    end

    private

    def check_config
      say_header("checking active account settings")
      config_path = @paths[:config] + "/config.yml"
      config = YAML.load(File.read(config_path))
      if config.blank?
        say_error("active user has no config file")
      else
        say_green(:found, "active user config file")
        say_header("difference default/current")
        diff = Settings.defaults.deep_diff(config)
        if diff.blank?
          say_green(:pass, "current user is using default values")
        else
          diff.each do |key, value|
            if value.is_a?(Hash)
              value.each do |inner_key, inner_value|
                default = inner_value[0].nil? ? "none" : inner_value[0]
                current = if inner_key == :deezer
                  inner_value[1].nil? ? "none" : inner_value[1][:code][0..10] + "..."
                else
                  inner_value[1].nil? ? "none" : inner_value[1]
                end
                say_green(:changed, "#{key}/#{inner_key} - Default: #{default}, Current: #{current}")
              end
            else
              default = value[0].nil? ? "none" : value[0]
              if value[1].nil?
                say_red(:missing, "#{key} - Default: #{default}, Current: none")
              else
                say_green(:changed, "#{key} - Default: #{default}, Current: #{value[1]}")
              end
            end
          end
        end
      end
    end

    def check_id_handle
      id = @active_account[1]
      say_green(:id, id)
      # username = @active_account[0]
      @handle = @active_account[2]
      say_green(:username, @handle)
    end

    def check_paths
      home = @active_account[3]
      say_green(:path, home)
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
          say_green(key, value)
        else
          say_red(:missing, value)
        end
      end
    end

    def find_active_account
      if File.exist?(@sql_path)
        say_green(:found, "database accounts file")
        @db = Amalgalite::Database.new(@sql_path)
        if @db.nil?
          say_red :error, "accounts database is not readable"
          return false
        else
          @active_account = Databases.active_account(@db)
        end
      else
        say_red :error, "accounts database is missing"
        return false
      end
      return true
    end

    def find_active_tables
      tables_path = @paths[:db] + "/ayadn.sqlite"
      if File.exist?(tables_path)
        say_green(:found, "#{@handle}'s database file")
        @userDB = Amalgalite::Database.new(tables_path)
        if @userDB.nil?
          say_red :error, "#{@handle}'s database is not readable"
          return false
        end
      else
        say_red :error, "#{@handle}'s database is missing"
        return false
      end
      return true
    end
  end

  class CheckAyadn < CheckBase

    attr_accessor :response

    def check
      begin
        say_header "checking RubyGems server response"
        get_response "https://rubygems.org/api/v1/gems/ayadn.json"
        check_response_code
        say_header "checking Ayadn version"
        info = JSON.parse(@response.body)
        live = info["version"]
        say_green(:live, "version #{live}")
        if live != VERSION
          say_red(:local, "version #{VERSION}")
          @status.say { @thor.say_status :update, "run 'gem update ayadn' to get the last version", :yellow }
        else
          say_green(:local, "version #{VERSION}")
        end
      rescue JSON::ParserError => e
        say_error "JSON error"
        say_trace e
      rescue Interrupt
        say_error "operation canceled"
        exit
      rescue => e
        rescue_network(e)
      end
    end

  end

end