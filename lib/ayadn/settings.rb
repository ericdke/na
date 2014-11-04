# encoding: utf-8
module Ayadn
  class Settings

    AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

    class << self
      attr_accessor :options, :config
      attr_reader :user_token, :default_nr
    end

    def self.load_config
      active = self.check_for_accounts
      home = active[3]
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
        }
      }
      @default_nr = {
        threshold: 2.1,
        cache: 48,
        filter: true,
        filter_unranked: false
      }
      @options = self.defaults
    end

    def self.check_for_accounts
      sqlaccounts = Dir.home + "/ayadn/accounts.sqlite"
      if File.exist?(sqlaccounts)
        return self.init_sqlite(sqlaccounts)
      else
        puts "\nAyadn 1.x is installed. Migrate to #{VERSION} now? (y/N)\n".color(:red)
        puts "\n"
        sh = Thor::Shell::Color.new
        input = sh.ask("> ")
        if input == "y" || input == "Y"
          Action.migrate
        else
          puts Status.canceled
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
        puts Status.not_authorized
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
          conf = YAML.load(File.read(config_file))

          # force delete obsolete keys (because legacy versions of the config file)
          conf[:timeline].delete_if {|k,_| k == :show_nicerank}
          conf[:colors].delete_if {|k,_| k == :nicerank}
          # force create mandatory keys (idem)
          conf[:nicerank] = @default_nr if conf[:nicerank].nil? || conf[:nicerank].size != 4
          conf[:timeline][:show_debug] = false if conf[:timeline][:show_debug].nil?
          conf[:timeline][:show_spinner] = true if conf[:timeline][:show_spinner].nil?
          conf[:colors][:debug] = :red if conf[:colors][:debug].nil?
          conf[:colors][:unread] = :cyan if conf[:colors][:unread].nil?
          conf[:nowplaying] = {} if conf[:nowplaying].nil?
          conf[:movie] = {hashtag: 'nowwatching'} if conf[:movie].nil?
          conf[:tvshow] = {hashtag: 'nowwatching'} if conf[:tvshow].nil?
          conf[:formats][:list] = {reverse: true} if conf[:formats][:list].nil?
          conf[:timeline][:compact] = false if conf[:timeline][:compact].nil?
          conf[:timeline][:show_channel_oembed] = true if conf[:timeline][:show_channel_oembed].nil?
          conf[:marker] = {update_messages: true} if conf[:marker].nil?

          @options = conf
          self.write_config_file(config_file, @options)
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
        if ( File.ctime(api_file) < (Time.now - 172800) ) #48h in secs
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
          directed: 1,
          deleted: 0,
          html: 0,
          annotations: true,
          show_source: true,
          show_symbols: true,
          show_real_name: true,
          show_date: true,
          show_spinner: true,
          show_debug: false,
          show_channel_oembed: true,
          compact: false
        },
        marker: {
          update_messages: true
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
          posts: 100,
          messages: 50,
          search: 200,
          whoreposted: 20,
          whostarred: 20,
          whatstarred: 100,
          files: 50
        },
        formats: {
          table: {
            width: 75
          },
          list: {
            reverse: true
          }
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
          debug: :red
        },
        backup: {
          auto_save_sent_posts: false,
          auto_save_sent_messages: false,
          auto_save_lists: false
        },
        scroll: {
          timer: 3
        },
        nicerank: @default_nr,
        nowplaying: {},
        movie: {
          hashtag: 'nowwatching'
        },
        tvshow: {
          hashtag: 'nowwatching'
        }
      }
    end

  end

end
