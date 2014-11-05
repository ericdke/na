# encoding: utf-8
module Ayadn
  class PinBoard

    def has_credentials_file?
      File.exist?(Ayadn::Settings.config[:paths][:auth] + '/pinboard.data')
    end

    def ask_credentials
      begin
        puts Status.pin_username
        pin_username = STDIN.gets.chomp()
        puts Status.pin_password
        pin_password = STDIN.noecho(&:gets).chomp()
      rescue Interrupt
        abort(Status.canceled)
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [pin_username]})
      end
      save_credentials(encode(pin_username, pin_password))
    end

    def load_credentials
      decode(File.read(Ayadn::Settings.config[:paths][:auth] + '/pinboard.data'))
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
      File.write(Ayadn::Settings.config[:paths][:auth] + '/pinboard.data', encoded_pinboard_credentials)
    end

    def encode(username, password)
      "AyadnPinboard #{Base64.strict_encode64([username, password].join(":"))}"
    end

  end
end
