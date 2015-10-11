# encoding: utf-8
module Ayadn
  class Diagnostics < Thor

    desc "nicerank", "Tests the NiceRank API"
    def nicerank
      CheckNiceRank.new.check
    end

    desc "adn", "Tests the App.net API"
    def adn
      CheckADN.new.check
    end

  end

  class CheckBase

    attr_accessor :response

    def initialize
      @thor = Thor::Shell::Color.new
      @status = Status.new
    end

    def say_error(message)
      @thor.say_status :error, message, :red
    end

    def say_info(message)
      @thor.say_status :info, message, :cyan
    end

    def say_green(tag, message)
      @thor.say_status tag, message, :green
    end

    def say_red(tag, message)
      @thor.say_status tag, message, :red
    end

    def say_end
      @status.say { say_green :done, "end of diagnostics" }
    end

    def say_header(message)
      @status.say { say_info message }
    end

    def say_text(text)
      @status.say { puts text }
    end

    def get_response(url)
      RestClient.get(url) {|response, request, result| response}
    end

    def check_response_code
      code = @response.code
      if code == 200
        say_green :status, "OK"
      else
        say_red :status, "#{code}"
        say_end
        exit
      end
    end

  end


  class CheckNiceRank < CheckBase

    def check
      begin
        say_header "checking NiceRank server response"
        @response = get_response "http://api.nice.social/user/nicerank?ids=1"
        check_response_code
        ratelimit = @response.headers[:x_ratelimit_remaining]
        Integer(ratelimit) > 120 ? say_green(:ratelimit, "OK") : say_red(:ratelimit, ratelimit)
        say_end
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        say_error "connection problem"
        say_text e
      rescue RestClient::RequestTimeout => e
        say_error "connection timeout"
        say_text e
      rescue Interrupt
        say_error "operation canceled"
      rescue => e
        say_error "unknown error"
        say_text e
      end
    end

  end

  class CheckADN < CheckBase

    def check
      begin
        say_header "checking ADN server response"
        @response = get_response "https://api.app.net/config"
        check_response_code
        if !JSON.parse(@response.body)["data"].nil?
          say_green :config, "OK"
        else
          say_red :config, "no data"
          say_end
          exit
        end
        say_end
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        say_error "connection problem"
        say_text e
      rescue RestClient::RequestTimeout => e
        say_error "connection timeout"
        say_text e
      rescue Interrupt
        say_error "operation canceled"
      rescue => e
        say_error "unknown error"
        say_text e
      end
    end

  end


end