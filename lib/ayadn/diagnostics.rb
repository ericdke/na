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

    desc "all", "Run all tests"
    def all
      obj = CheckADN.new
      obj.check
      obj = CheckNiceRank.new
      obj.check
      obj = CheckAccounts.new
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
          raise "invalid server response"
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

    # require "pp"

    attr_accessor :sql_path, :active_account, :db, :paths

    def initialize
      super
      @sql_path = Dir.home + "/ayadn/accounts.sqlite"
    end

    def check
      begin
        say_header("checking accounts database")
        find_active_account
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
      handle = @active_account[2]
      say_green(:username, handle)
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
          raise "accounts database is not readable"
        else
          @active_account = Databases.active_account(@db)
        end
      else
        raise "accounts database is missing"
      end
    end
  end


end