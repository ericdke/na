# encoding: utf-8
module Ayadn
  class Authorize

    def initialize
      @thor = Thor::Shell::Color.new # local statuses
      @status = Status.new # global statuses + utils
    end

    def authorize
      puts "\n"
      if File.exist?(Dir.home + "/ayadn/accounts.db")
        @status.has_to_migrate
        exit
      end
      puts "\e[H\e[2J"
      show_link
      token = get_token
      check_token(token)
      puts "\e[H\e[2J"
      @thor.say_status :connexion, "downloading user info", :yellow
      user = create_user_data(token, Dir.home + "/ayadn")
      prepare(user)
      @thor.say_status :create, "configuration", :yellow
      Settings.load_config
      Logs.create_logger
      install
      @thor.say_status :done, "user #{user.handle} is authorized", :green
      Errors.info "#{user.handle} authorized."
      @status.say { @thor.say_status :end, "Thank you for using Ayadn. Enjoy!", :green }
      Switch.new.list
    end

    def unauthorize(user, options)
      begin
        @workers = Workers.new
        if user.size > 1
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
        @thor.say_status :delete, "database entry for @#{user}", :yellow
        db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
        Databases.remove_from_accounts(db, user)
        if options[:delete]
          @thor.say_status :delete, "@#{user} user folders", :yellow
          FileUtils.remove_dir(Dir.home + "/ayadn/#{user}")
        end
        @thor.say_status :done, "user @#{user} has been unauthorized", :green
        puts "\n"
      rescue Interrupt
        Status.new.canceled
        exit
      end
    end

    private

    def prepare(user)
      @thor.say_status :create, "user folders", :yellow
      create_config_folders(user)
      @thor.say_status :save, "user token", :yellow
      create_token_file(user)
      @thor.say_status :create, "Ayadn account", :yellow
      acc_db = Amalgalite::Database.new(Dir.home + "/ayadn/accounts.sqlite")
      Databases.create_account(acc_db, user)
      Databases.create_tables(user) unless File.exist?("#{user.user_path}/db/ayadn.sqlite")
    end

    def install
      @thor.say_status :create, "api and config files", :yellow
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
          @thor.say_status :error, "can't create #{user.handle} account folders", :red
        end
        @status.say { puts "\nError: #{e}" }
        exit
      end
    end

    def show_link
      @status.say do
        @thor.say_status :please, "click or copy/paste this URL in a browser", :yellow
        puts "\n"
        puts "\t#{Endpoints.new.authorize_url}"
        puts "\n"
        @thor.say_status :next, "log in to authorize Ayadn", :cyan
        @thor.say_status nil, "you will be redirected to your 'user token'"
        @thor.say_status :please, "copy/paste the token here:", :yellow
      end
      print "\t> "
    end

    def get_user(token)
      begin
        JSON.parse(RestClient.get("https://api.app.net/users/me?access_token=#{token}", :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response })
      rescue Exception => e
        @status.say do
          @thor.say_status :error, "connection problem", :red
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
          @thor.say_status :error, "couldn't get the token", :red
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
