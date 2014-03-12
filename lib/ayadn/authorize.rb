# encoding: utf-8
module Ayadn
  class Authorize
    def initialize
      Settings.load_config
      #Logs.create_logger
    end

    def authorize
      puts "\e[H\e[2J"
      if FileOps.old_ayadn?
        puts "\nAn old version of Ayadn has been detected and will be deleted. Install and authorize the new version? [y/N]\n".color(:red)
        print "> "
        answer = STDIN.getch
        unless answer.downcase == "y"
          puts Status.canceled
          exit
        end
        puts "\nDeleting old version...\n".color(:green)
        Dir.rmdir(Dir.home + "/ayadn")
      end
      if Settings.has_token_file?
        puts "\nYou're already authorized. If you authorize again, your config file will be deleted. Are you sure you want to authorize a new account? [y/N]\n".color(:red)
        print "> "
        answer = STDIN.getch
        unless answer.downcase == "y"
          puts Status.canceled
          exit
        end
      end
      show_link
      token = STDIN.gets.chomp()
      puts "\n\nOk! Creating Ayadn folders...\n".color(:green)
      Settings.create_config_folders
      Logs.create_logger
      Errors.info "Folders created:"
      Errors.info "#{Settings.config[:paths]}"
      puts "Saving user token...\n".color(:green)
      Settings.create_token_file(token)
      Errors.info "Token saved."
      Settings.get_token
      puts "Installing config files...\n".color(:green)
      install
      puts Status.done
      Errors.info "Done!"
      puts "\nThank you for using Ayadn. Enjoy!\n\n".color(:yellow)
    end

    def show_link
      puts "\nPlease click this URL, or open a browser then copy/paste it:\n".color(:cyan)
      puts Endpoints.new.authorize_url
      puts "\n"
      puts "On this page, log in with your App.net account to authorize Ayadn.\n".color(:cyan)
      puts "You will then be redirected to a page showing a 'user token' (a secret code).\n".color(:cyan)
      puts "Copy it then paste it here:\n".color(:yellow)
      print "> "
    end

    def install
      puts "Creating identity file...\n".color(:green)
      Errors.info "Creating identity file..."
      Settings.create_identity_file
      puts "Creating api and config files...\n".color(:green)
      Errors.info "Creating api and config files..."
      Settings.init_config
      puts "Creating version file...\n".color(:green)
      Errors.info "Creating version file..."
      Settings.create_version_file
    end
  end
end
