# encoding: utf-8
module Ayadn
  class Diagnostics < Thor

    desc "nicerank", "Tests the NiceRank API"
    def nicerank
      CheckNiceRank.new.check
    end

  end

  class CheckBase

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

    def get_response(url)
      RestClient.get(url) {|response, request, result| response}
    end

  end

  class CheckNiceRank < CheckBase
    def check
      begin
        response = get_response "http://api.nice.social/user/nicerank?ids=1"
        say_header "checking server response"
        code = response.code
        if code == 200
          say_green :status, "OK"
        else
          say_red :status, "#{code}"
        end
        ratelimit = response.headers[:x_ratelimit_remaining]
        if Integer(ratelimit) > 120
          say_green :ratelimit, "OK"
        else
          say_red :ratelimit, ratelimit
        end
        say_end
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        say_error "connection problem"
        @status.say { puts e }
      rescue RestClient::RequestTimeout => e
        say_error "connection timeout"
        @status.say { puts e }
      rescue Interrupt
        say_error "operation canceled"
      rescue => e
        say_error "unknown error"
        @status.say { puts e }
      end
    end
  end


  
end