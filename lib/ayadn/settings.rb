# encoding: utf-8
module Ayadn
  class Settings

    AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

    class << self
      attr_accessor :options, :config
      attr_reader :user_token
    end

    def self.load_config
      home = Dir.home + "/ayadn2" #temp, will be /ayadn in v1
      @config = {
        paths: {
          home: home,
          log: "#{home}/log",
          db: "#{home}/db",
          pagination: "#{home}/pagination",
          config: "#{home}/config",
          auth: "#{home}/auth",
          downloads: "#{home}/downloads",
          backup: "#{home}/backup",
          posts: "#{home}/backup/posts",
          messages: "#{home}/backup/messages",
          lists: "#{home}/backup/lists"
        },
        identity: {}
      }
      @options = self.defaults
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
      self.config_file
      self.set_identity
      self.create_api_file
    end

    def self.save_config
      File.write(@config[:paths][:config] + "/config.yml", @options.to_yaml)
    end

    #private

    def self.has_token_file?
      File.exist?(@config[:paths][:auth] + "/token")
    end

    def self.read_token_file
      File.read(@config[:paths][:auth] + "/token")
    end

    def self.config_file
      config_file = @config[:paths][:config] + "/config.yml"
      if File.exists?(config_file)
        # TODO: system to merge existing config file when future category are added
        begin
          @options = YAML.load(File.read(config_file))
        rescue => e
          Errors.global_error("myconfig/load config.yml", nil, e)
        end
      else
        begin
          self.write_config_file(config_file, @options)
        rescue => e
          Errors.global_error("myconfig/create config.yml from defaults", nil, e)
        end
      end
    end

    def self.set_identity
      identity = self.read_identity_file
      @config[:identity][:username] = identity[:identity][:username]
      @config[:identity][:id] = identity[:identity][:id]
      @config[:identity][:handle] = identity[:identity][:handle]
    end

    def self.create_identity_file
      unless File.exist?(@config[:paths][:config] + "/identity.yml")
        resp = API.new.get_user("me")
        username = resp['data']['username']
        id = resp['data']['id']
        handle = "@" + username
        @config[:identity][:username] = username
        @config[:identity][:handle] = handle
        @config[:identity][:id] = id
        blob = {identity: {username: username, id: id, handle: handle}}
        File.write(@config[:paths][:config] + "/identity.yml", blob.to_yaml)
      end
    end

    def self.create_api_file
      api_file = @config[:paths][:config] + "/api.json"
      time_now = Time.now
      if File.exist?(api_file)
        if ( File.ctime(api_file) < (time_now - 172800) ) #48h in secs
          self.new_api_file(api_file)
        end
      else
        self.new_api_file(api_file)
      end
      self.read_api(api_file)
    end

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

    def self.read_identity_file
      YAML.load(File.read(@config[:paths][:config] + "/identity.yml"))
    end

    def self.has_identity_file?
      File.exist?(@config[:paths][:config] + "/identity.yml")
    end

    def self.create_version_file
      File.write(@config[:paths][:config] + "/version.yml", {version: @config[:version]}.to_yaml)
    end

    def self.has_version_file?
      File.exist?(@config[:paths][:config] + "/version.yml")
    end

    def self.read_version_file
      YAML.load(File.read(@config[:paths][:config] + "/version.yml"))
    end

    def self.create_token_file(token)
      unless token.nil? || token.empty?
        File.write(@config[:paths][:auth] + "/token", token)
      else
        puts Status.wtf
        exit
      end
    end

    def self.create_config_folders
      #todo: unless version file exists + more checks
      begin
        FileUtils.mkdir_p(@config[:paths][:home]) unless Dir.exists?(@config[:paths][:home])
        %w{log db pagination config auth downloads backup posts messages lists}.each do |target|
          Dir.mkdir(@config[:paths][target.to_sym]) unless Dir.exists?(@config[:paths][target.to_sym])
        end
      rescue => e
        Errors.global_error("myconfig/create ayadn folders", nil, e)
      end
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
          annotations: 1,
          show_source: true,
          show_symbols: true,
          show_real_name: true,
          show_date: true
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
          messages: 50,
          search: 100,
          whoreposted: 50,
          whostarred: 50,
          whatstarred: 100,
          files: 66
        },
        formats: {
          table: {
            width: 75
          }
        },
        colors: {
          id: :red,
          index: :red,
          username: :green,
          name: :magenta,
          date: :cyan,
          link: :yellow,
          dots: :blue,
          hashtags: :cyan,
          mentions: :red,
          source: :blue,
          symbols: :green
        },
        backup: {
          auto_save_sent_posts: false,
          auto_save_sent_messages: false,
          auto_save_lists: false
        },
        scroll: {
          countdown_1: 5,
          countdown_2: 15,
          timer: 0.7
        }
      }
    end

  end
end