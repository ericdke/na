module Ayadn
  class PinBoard

    def has_credentials_file?
      File.exist?(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db')
    end

    def ask_credentials
      begin
        puts "Please enter your Pinboard username (CTRL+C to cancel): ".color(:green)
        pin_username = STDIN.gets.chomp()
        puts "\nPlease enter your Pinboard password (invisible, CTRL+C to cancel): ".color(:green)
        pin_password = STDIN.noecho(&:gets).chomp()
      rescue Exception
        puts Status.stopped
      end
      save_credentials(encode(pin_username, pin_password))
    end

    def load_credentials
      decode(File.read(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db'))
    end

    def pin(data)
      pinboard = Pinboard::Client.new(:username => data.username, :password => data.password)
      pinboard.add(:url => data.url, :tags => data.tags, :extended => data.text, :description => data.description)
    end

    private

    def decode(encoded_pinboard_credentials)
      Base64.strict_decode64(encoded_pinboard_credentials[/AyadnPinboard (.*)/, 1]).split(":")
    end

    def save_credentials(encoded_pinboard_credentials)
      File.write(Ayadn::MyConfig.config[:paths][:db] + '/ayadn_pinboard.db', encoded_pinboard_credentials)
    end

    def encode(username, password)
      "AyadnPinboard #{Base64.strict_encode64([username, password].join(":"))}"
    end

  end
end
