# encoding: utf-8
module Ayadn
  class Authorize
    def initialize
      Settings.load_config
      #Logs.create_logger
    end

    def authorize
      if FileOps.old_ayadn?
        # ask if delete
        # if no, give up
      end
      if Settings.has_identity_file? # || has_token_file?
        puts "oh!"
        exit
        # alert and ask if continue with current or authorize new user
      end

      show_link
      # (open browser)
      token = STDIN.gets.chomp()
      puts "\n\nOk! Creating Ayadn folders...\n".color(:green)
      Settings.create_config_folders
      puts "Saving user token...\n".color(:green)
      Settings.create_token_file(token)
      Settings.get_token
      puts "Installing config files...".color(:green)
      install
      puts Status.done
    end

    def show_link
      link = Endpoints.new.authorize_url
      puts "\nPlease click this URL, or open a browser then copy/paste it:\n".color(:cyan)
      puts link
      puts "\n"
      puts "Login on this page with your App.net account to authorize Ayadn.\n".color(:cyan)
      puts "You will be redirected to a page showing a 'user token'.\n".color(:cyan)
      puts "Copy it then paste it here:\n".color(:yellow)
      print "> "
    end

    def install
      Settings.config_file
      Settings.create_version_file
      Settings.create_identity_file
    end
  end
end
