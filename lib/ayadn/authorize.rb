# encoding: utf-8
module Ayadn
  class Authorize

    def authorize
      puts "\e[H\e[2J"
      try_remove_old_ayadn
      show_link
      token = get_token
      check_token(token)
      puts "\n\nThanks! Contacting App.net...\n".color(:green)
      user = create_user_data(token, Dir.home + "/ayadn")
      prepare(user)
      puts "Creating configuration...\n".color(:green)
      Settings.load_config
      Logs.create_logger
      install
      puts Status.done
      Errors.info "Done!"
      puts "\nThank you for using Ayadn. Enjoy!\n\n".color(:yellow)
    end

    private

    def prepare(user)
      puts "Ok! Creating Ayadn folders...\n".color(:green)
      create_config_folders(user)
      puts "Saving user token...\n".color(:green)
      create_token_file(user)
      puts "Creating user account for #{user.handle}...\n".color(:green)
      accounts_db = Daybreak::DB.new("#{user.home_path}/accounts.db")
      create_account(user, accounts_db)
    end

    def install
      puts "Creating api and config files...\n".color(:green)
      Errors.info "Creating api and config files..."
      Settings.init_config
      puts "Creating version file...\n".color(:green)
      Errors.info "Creating version file..."
      Settings.create_version_file
    end

    def create_account(user, accounts_db)
      accounts_db[user.username] = {username: user.username, id: user.id, handle: user.handle, path: user.user_path}
      accounts_db['ACTIVE'] = user.username
      accounts_db.flush
      accounts_db.close
    end

    def create_token_file(user)
      File.write("#{user.user_path}/auth/token", user.token)
    end

    def create_config_folders(user)
      begin
        FileUtils.mkdir_p(user.user_path)
        %w{log db pagination config auth downloads backup posts messages lists}.each do |target|
          Dir.mkdir("#{user.user_path}/#{target}")
        end
      rescue => e
        puts "\nError creating Ayadn #{user.handle} account folders.\n\n"
        puts "Error: #{e}"
        exit
      end
    end

    def show_link
      puts "\nPlease click this URL, or open a browser then copy/paste it:\n".color(:cyan)
      puts Endpoints.new.authorize_url
      puts "\n"
      puts "On this page, log in with your App.net account to authorize Ayadn.\n".color(:cyan)
      puts "You will then be redirected to a page showing a 'user token' (your secret code).\n".color(:cyan)
      puts "Copy it then paste it here:\n".color(:yellow)
      print "> "
    end

    def get_user(token)
      JSON.parse(RestClient.get("https://alpha-api.app.net/stream/0/users/me?access_token=#{token}", :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response })
    end

    def get_token
      begin
        token = STDIN.gets.chomp()
      rescue Interrupt
        puts Status.canceled
        exit
      end
    end

    def check_token(token)
      if token.empty? || token.nil?
        puts "\n\nOops, something went wrong, I couldn't get the token. Please try again.\n\n".color(:red)
        exit
      end
    end

    def try_remove_old_ayadn
      if FileOps.old_ayadn?
        answer = ask_del_old_ayadn
        unless answer.downcase == "y"
          puts Status.canceled
          exit
        end
        puts "\nDeleting old version...\n".color(:green)
        begin
          old_dir = Dir.home + "/ayadn"
          FileUtils.remove_dir(old_dir)
        rescue => e
          puts "Unable to remove folder: #{old_dir}\n\n".color(:red)
          raise e
        end
      end
    end

    def ask_del_old_ayadn
      puts "\nAn obsolete version of Ayadn has been detected and will be deleted. Install and authorize the new version? [y/N]\n".color(:red)
      print "> "
      STDIN.getch
    end

    def create_user_data(token, home_path)
      resp = get_user(token)
      model = Struct.new(:resp, :username, :id, :handle, :home_path, :user_path, :token)
      username = resp['data']['username']
      model.new(resp, username, resp['data']['id'], "@" + username, home_path, home_path + "/#{username}", token)
    end

  end
end
