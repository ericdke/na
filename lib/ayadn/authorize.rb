# encoding: utf-8
module Ayadn
  class Authorize

    def initialize
      @thor = Thor::Shell::Color.new # local statuses
      @status = Status.new # global statuses + utils
      @baseURL = "https://api.app.net" # may be overriden
    end

    def authorize(options)
      puts "\n"
      if File.exist?(Dir.home + "/ayadn/accounts.db")
        @status.deprecated_ayadn
        exit
      end
      api_file = Dir.home + "/ayadn/.api.yml"
      # overrides the default value
      if File.exist?(api_file)
        @baseURL = YAML.load(File.read(api_file))[:root]
      end
      # overrides the config file
      if options["api"]
        @baseURL = options["api"]
      end
      puts "\e[H\e[2J"
      show_link
      token = get_token
      check_token(token)
      puts "\e[H\e[2J"
      @status.say_yellow :connexion, "downloading user info"
      user = create_user_data(token, Dir.home + "/ayadn")
      prepare(user)
      @status.say_yellow :create, "configuration"
      Settings.load_config
      Logs.create_logger
      install
      @status.say_green :done, "user #{user.handle} is authorized"
      Errors.info "#{user.handle} authorized."
      @status.say { @status.say_green :end, "Thank you for using Ayadn. Enjoy!" }
      Switch.new.list
    end

    def unauthorize(user, options)
      begin
        @workers = Workers.new
        if user.size != 1
          @status.one_username
          exit
        end
        user = @workers.remove_arobase_if_present(user)[0]
        puts "\e[H\e[2J"
        if options[:delete]
          sure = @thor.yes?("Are you sure you want to unauthorize user @#{user} and delete its folders?\n\n> ", :red)
        else
          sure = @thor.yes?("Are you sure you want to unauthorize user @#{user} ?\n\n> ", :red)
        end
        unless sure == true
          Status.new.canceled
          exit
        end
        puts "\e[H\e[2J"
        @status.say_yellow :delete, "database entry for @#{user}"
        db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
        Databases.remove_from_accounts(db, user)
        if options[:delete]
          @status.say_yellow :delete, "@#{user} user folders"
          FileUtils.remove_dir(Dir.home + "/ayadn/#{user}")
        end
        @status.say_green :done, "user @#{user} has been unauthorized"
        remaining = Databases.all_accounts(db)
        if remaining.flatten.empty?
          @status.say_info "accounts database is now empty"
        else
          username = remaining[0][0]
          Databases.set_active_account(db, username)
          @status.say_info "user @#{username} is now the active user"
        end
        puts "\n"
      rescue Interrupt
        Status.new.canceled
        exit
      end
    end

    private

    def prepare(user)
      @status.say_yellow :create, "user folders"
      create_config_folders(user)
      @status.say_yellow :save, "user token"
      create_token_file(user)
      @status.say_yellow :create, "Ayadn account"
      acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      user_db = Amalgalite::Database.new("#{user.user_path}/db/ayadn.sqlite")
      if user_db.schema.tables.empty?
        Databases.create_tables(user)
      end
      if acc_db.schema.tables.empty?
        Databases.create_account_table(acc_db)
      end
      Databases.create_account(acc_db, user)
    end

    def install
      @status.say_yellow :create, "api and config files"
      Errors.info "Creating api and config files..."
      Errors.info "Creating version file..."
      Settings.init_config
    end

    def create_token_file(user)
      File.write("#{user.user_path}/auth/token", user.token)
    end

    def create_config_folders(user)
      begin
        FileUtils.mkdir_p(user.user_path)
        %w{log db config auth downloads posts messages lists}.each do |target|
          Dir.mkdir("#{user.user_path}/#{target}") unless Dir.exist?("#{user.user_path}/#{target}")
        end
      rescue => e
        @status.say do
          @status.say_error "can't create #{user.handle} account folders"
        end
        @status.say { puts "\nError: #{e}" }
        exit
      end
    end

    def show_link
      @status.say do
        @status.say_yellow :please, "click or copy/paste this URL in a browser"
        puts "\n"
        puts "\t#{Endpoints.new.authorize_url}"
        puts "\n"
        @status.say_cyan :next, "log in to authorize Ayadn"
        @status.say_center "you will be redirected to your 'user token'"
        @status.say_yellow :please, "copy/paste the token here:"
      end
      print "\t> "
    end

    def get_user(token)
      begin
        JSON.parse(RestClient.get("#{@baseURL}/users/me?access_token=#{token}", :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response })
      rescue Exception => e
        @status.say do
          @status.say_error "connection problem"
        end
        puts "#{e}"
      end
    end

    def get_token
      begin
        STDIN.gets.chomp()
      rescue Interrupt
        @status.canceled
        exit
      end
    end

    def check_token(token)
      if token.empty? || token.nil?
        @status.say do
          @status.say_error "couldn't get the token"
        end
        exit
      end
    end

    def create_user_data(token, home_path)
      resp = get_user(token)
      model = Struct.new(:resp, :username, :id, :handle, :home_path, :user_path, :token)
      username = resp['data']['username']
      model.new(resp, username, resp['data']['id'], "@" + username, home_path, home_path + "/#{username}", token)
    end

  end
end
