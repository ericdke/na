# encoding: utf-8
module Ayadn
  class CNX

    def self.download url
      working = true
      begin
        RestClient.get(url) {|response, request, result| response}
      rescue RestClient::RequestTimeout => e
        thor = Thor::Shell::Color.new
        thor.say_status :error, "connection timeout", :red
        if working == true
          working = false
          thor.say_status :info, "trying again", :yellow
          retry
        end
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        thor = Thor::Shell::Color.new
        if working == true
          working = false
          thor.say_status :error, "'#{url}' didn't respond", :red
          thor.say_status :info, "trying again in 5 secs", :yellow
          sleep 5
          retry
        end
        thor.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url]})
      end
    end

    def self.get url
      working = true
      begin
        RestClient.get(url) do |response, request, result|
          Debug.http response, url
          check_nr response, url
        end
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError, RestClient::RequestTimeout => e
        if working == true
          working = false
          sleep 0.5
          retry
        end
        Errors.nr "URL: #{url}"
        return {'meta' => {'code' => 666}, 'data' => "#{e}"}.to_json
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url]})
      end
    end

    def self.check_nr response, url
      case response.code
      when 200
        response
      when 204
        puts "\nError: the NiceRank filter made too many requests to the server. You may either wait for a little while before scrolling the filtered Global again, or set the scroll timer to a greater value (example: `ayadn set scroll timer 5`). (see https://github.com/ericdke/na/tree/master/doc).\n".color(:red)
        Errors.global_error({error: "NiceRank: TOO MANY REQUESTS", caller: caller, data: [url, response.inspect, response.headers]})
      else
        response
      end
    end

    def self.get_response_from(url)
      try_cnx = 1
      begin
        RestClient::Request.execute(:method => :get, :url => url, :timeout => 20) do |response, request, result|
        #RestClient.get(url) do |response, request, result| #, :verify_ssl => OpenSSL::SSL::VERIFY_NONE
          Debug.http response, url
          check response
        end
      rescue RestClient::RequestTimeout => e
        thor = Thor::Shell::Color.new
        thor.say_status :error, "connection timeout", :red
        if try_cnx < 4
          try_cnx = retry_adn 5, try_cnx
          retry
        end
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError => e
        if try_cnx < 4
          try_cnx = retry_adn 10, try_cnx
          retry
        end
        Thor::Shell::Color.new.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue URI::InvalidURIError => e
        Thor::Shell::Color.new.say_status :error, "connection or authorization problem", :red
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url]})
      end
    end

    def self.retry_adn seconds, try_cnx
      thor = Thor::Shell::Color.new
      thor.say_status :error, "unable to connect to App.net", :red
      thor.say_status :info, "trying again in #{seconds} seconds (#{try_cnx}/3)", :yellow
      Errors.warn "Unable to connect to App.net"
      try_cnx += 1
      sleep seconds
      puts "\e[H\e[2J"
      try_cnx
    end

    def self.check response
      if response.code != 200
        res = JSON.parse(response)
        message = res['meta']['error_message']
        thor = Thor::Shell::Color.new
        puts "\n"
      end
      case response.code
      when 200
        response
      when 204, 400, 401, 403, 405, 500, 502, 504
        thor.say_status :error, message.upcase, :red
        Errors.global_error({error: message, caller: caller, data: [res]})
      when 429
        thor.say_status :error, message.upcase, :red
        puts "\n\nAyadn made too many requests to the App.net API. You should wait at least ".color(:cyan) + "#{response.headers[:retry_after]} ".color(:red) + "seconds before trying again. Maybe you launched a lot of Ayadn instances at the same time? That's no problem, but in this case you should increase the value of the scroll timer (with `ayadn set scroll timer 5` for example). App.net allows 5000 requests per hour per account maximum.".color(:cyan)
        Errors.global_error({error: message, caller: caller, data: [res]})
      else
        response
      end
    end

    def self.delete(url)
      begin
        RestClient.delete(url) do |response, request, result|
          Debug.http response, url
          check response
        end
      rescue SocketError, SystemCallError => e
        Thor::Shell::Color.new.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url]})
      end
    end

    def self.post(url, payload = nil)
      begin
        RestClient.post(url, payload.to_json, :content_type => :json, :accept => :json) do |response, request, result|
          Debug.http response, url
          check response
        end
      rescue SocketError, SystemCallError => e
        Thor::Shell::Color.new.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      end
    end

    def self.put(url, payload)
      begin
        RestClient.put(url, payload.to_json, :content_type => :json, :accept => :json) do |response, request, result|
          Debug.http response, url
          check response
        end
      rescue SocketError, SystemCallError => e
        Thor::Shell::Color.new.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      end
    end

    def self.patch(url, payload)
      begin
        RestClient.patch(url, payload.to_json, :content_type => :json, :accept => :json) do |response, request, result|
          Debug.http response, url
          check response
        end
      rescue SocketError, SystemCallError => e
        Thor::Shell::Color.new.say_status :error, "connection problem", :red
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      rescue Interrupt
        thor = Thor::Shell::Color.new
        puts "\n"
        thor.say_status :canceled, "connection canceled", :red
        puts "\n"
        exit
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      end
    end

  end
end
