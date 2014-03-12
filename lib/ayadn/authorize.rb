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
      if Settings.has_token_file?
        if Settings.has_identity_file?
          # already installed
          # alert and ask if continue with current
          # if yes, cancel, if no, authorize new user
        else
          # already logged but not installed
          # say something's wrong
          # authorize new user
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
      puts "Login on this page with your App.net account to authorize Ayadn.\n".color(:cyan)
      puts "You will be redirected to a page showing a 'user token'.\n".color(:cyan)
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
