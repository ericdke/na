# encoding: utf-8
module Ayadn
  class Settings

    # Replace with your own client ID if you forked this code
    # 
    # Otherwise your posts will be annotated with Ayadn's informations
    # instead of yours and App.net could ban your account
    # 
    AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

    class << self
      attr_accessor :options, :config, :global
      attr_reader :user_token
    end

    def self.load_config
      active = self.check_for_accounts
      if active.empty?
        Status.new.not_authorized
        exit
      end
      home = active[3]
      api_file = Dir.home + "/ayadn/.api.yml"
      baseURL = if File.exist?(api_file)
        YAML.load(File.read(api_file))[:root]
      else
        "https://api.app.net"
      end
      @config = {
        paths: {
          home: home,
          log: "#{home}/log",
          db: "#{home}/db",
          config: "#{home}/config",
          auth: "#{home}/auth",
          downloads: "#{home}/downloads",
          posts: "#{home}/posts",
          messages: "#{home}/messages",
          lists: "#{home}/lists"
        },
        identity: {
          id: active[1],
          username: active[0],
          handle: active[2]
        },
        api: {
          baseURL: baseURL
        }
      }
      @options = self.defaults
      @global = {scrolling: false, force: false}
    end

    def self.check_for_accounts
      sqlaccounts = Dir.home + "/ayadn/accounts.sqlite"
      status = Status.new
      if File.exist?(sqlaccounts)
        # Ayadn 2.x with already authorized account(s)
        return self.init_sqlite(sqlaccounts)
      else
        if File.exist?(Dir.home + "/ayadn/accounts.db")
          # Ayadn 1.x with already authorized account(s)
          status.deprecated_ayadn
          exit
        else
          # Ayadn without any authorized account (gem installed but no ~/ayadn folder)
          status.not_authorized
          exit
        end
      end
    end

    def self.init_sqlite(sqlaccounts)
      Databases.active_account(Amalgalite::Database.new(sqlaccounts))
    end

    def self.get_token
      if self.has_token_file?
        @user_token = self.read_token_file
      else
        Status.new.not_authorized
        exit
      end
    end

    def self.init_config
      @config[:version] = VERSION
      @config[:platform] = RbConfig::CONFIG['host_os']
      @config[:ruby] = RUBY_VERSION
      @config[:locale] = ENV["LANG"]
      self.config_file
      self.create_api_file
      self.create_version_file
    end

    def self.save_config
      File.write(@config[:paths][:config] + "/config.yml", @options.to_yaml)
    end

    def self.has_token_file?
      File.exist?(@config[:paths][:auth] + "/token")
    end

    def self.read_token_file
      File.read(@config[:paths][:auth] + "/token")
    end

    def self.config_file
      config_file = @config[:paths][:config] + "/config.yml"
      if File.exist?(config_file)
        begin
          # conf = YAML.load(File.read(config_file))
          # @options = conf
          @options = YAML.load(File.read(config_file))
          # self.write_config_file(config_file, @options)
        rescue => e
          Errors.global_error({error: e, caller: caller, data: []})
        end
      else
        begin
          self.write_config_file(config_file, @options)
        rescue => e
          Errors.global_error({error: e, caller: caller, data: []})
        end
      end
    end

    def self.create_api_file
      api_file = @config[:paths][:config] + "/api.json"
      if File.exist?(api_file)
        # should be 48h in secs (172800)
        # but since ADN's API won't change any time soon...
        if ( File.ctime(api_file) < (Time.now - 604800) )
          self.new_api_file(api_file)
        end
      else
        self.new_api_file(api_file)
      end
      self.read_api(api_file)
    end

    def self.create_version_file
      File.write(@config[:paths][:config] + "/version.yml", {version: @config[:version]}.to_yaml)
    end

    def self.restore_defaults
      self.load_config
      File.write(@config[:paths][:config] + "/config.yml", @options.to_yaml)
    end

    private

    def self.new_api_file(api_file)
      api = API.new
      resp = api.get_config
      api.check_response_meta_code(resp)
      File.write(api_file, resp['data'].to_json)
    end

    def self.read_api(api_file)
      content = JSON.parse(File.read(api_file))
      @config[:post_max_length] = content['post']['text_max_length']
      @config[:message_max_length] = content['message']['text_max_length']
    end

    def self.has_version_file?
      File.exist?(@config[:paths][:config] + "/version.yml")
    end

    def self.read_version_file
      YAML.load(File.read(@config[:paths][:config] + "/version.yml"))
    end

    def self.write_config_file(config_file, options)
      File.write(config_file, options.to_yaml)
    end

    def self.defaults
      {
        timeline: {
          directed: true,
          source: true,
          symbols: true,
          name: true,
          date: true,
          debug: false,
          compact: false
        },
        marker: {
          messages: true
        },
        counts: {
          default: 50,
          unified: 50,
          global: 50,
          checkins: 50,
          conversations: 50,
          photos: 50,
          trending: 50,
          mentions: 50,
          convo: 50,
          posts: 50,
          messages: 20,
          search: 200,
          whoreposted: 20,
          whostarred: 20,
          whatstarred: 100,
          files: 50
        },
        formats: {
          table: {
            width: 75,
            borders: true
          },
          list: {
            reverse: true
          }
        },
        channels: {
          links: true
        },
        colors: {
          id: :blue,
          index: :red,
          username: :green,
          name: :magenta,
          date: :cyan,
          link: :yellow,
          dots: :blue,
          hashtags: :cyan,
          mentions: :red,
          source: :cyan,
          symbols: :green,
          unread: :cyan,
          debug: :red,
          excerpt: :green
        },
        backup: {
          posts: false,
          messages: false,
          lists: false
        },
        scroll: {
          spinner: true,
          timer: 3,
          date: false
        },
        nicerank: {
          threshold: 2.1,
          filter: true,
          unranked: false
        },
        nowplaying: {},
        movie: {
          hashtag: 'nowwatching'
        },
        tvshow: {
          hashtag: 'nowwatching'
        },
        blacklist: {
          active: true
        }
      }
    end

  end

end
