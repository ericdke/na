# encoding: utf-8
module Ayadn
  class CNX

    def self.download url
      working = true
      begin
        RestClient.get(url) {|response, request, result| response}
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError, RestClient::RequestTimeout => e
        if working == true
          working = false
          puts "\nOoops, '#{url}' didn't respond. Trying again in 5 secs.\n".color(:red)
          sleep 5
          retry
        end
        puts "\nConnexion error.\n\n".color(:red)
        Errors.global_error({error: e, caller: caller, data: [url, response]})
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, response]})
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
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, response]})
      end
    end

    def self.check_nr response, url
      case response.code
      when 200
        response
      when 204
        puts "\nError: the NiceRank filter made too many requests to the server. You may either wait for a little while before scrolling the filtered Global again, or set the scroll timer to a greater value (example: `ayadn set scroll timer 5`). (see http://ayadn-app.net/doc).\n".color(:red)
        Errors.global_error({error: "NiceRank: TOO MANY REQUESTS", caller: caller, data: [url, response.inspect, response.headers]})
      else
        response
      end
    end

    def self.get_response_from(url)
      try_cnx = 1
      begin
        RestClient.get(url) do |response, request, result| #, :verify_ssl => OpenSSL::SSL::VERIFY_NONE
          Debug.http response, url
          check response
        end
      rescue SocketError, SystemCallError, OpenSSL::SSL::SSLError, RestClient::RequestTimeout => e
        if try_cnx < 4
          try_cnx = retry_adn 10, try_cnx
          retry
        end
        puts "\nConnection error.".color(:red)
        Errors.global_error({error: e, caller: caller, data: [url]})
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, response]})
      end
    end

    def self.retry_adn seconds, try_cnx
      Errors.warn "Unable to connect to App.net"
      puts "\n\nUnable to connect to App.net\nRetrying in #{seconds} seconds... (#{try_cnx}/3)\n".color(:red)
      try_cnx += 1
      sleep seconds
      puts "\e[H\e[2J"
      try_cnx
    end

    def self.check response
      message = JSON.parse(response)['meta']['error_message'] if response.code != 200
      case response.code
      when 200
        response
      when 204
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "NO CONTENT", caller: caller, data: [message, response.headers]})
      when 400
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "BAD REQUEST", caller: caller, data: [message, response.headers]})
      when 401
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "UNAUTHORIZED", caller: caller, data: [message, response.headers]})
      when 403
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "FORBIDDEN", caller: caller, data: [message, response.headers]})
      when 405
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "METHOD NOT ALLOWED", caller: caller, data: [message, response.headers]})
      when 429
        puts "\n#{message}".color(:red)
        puts "\n\nAyadn made too many requests to the App.net API. You should wait at least ".color(:cyan) + "#{response.headers[:retry_after]} ".color(:red) + "seconds before trying again. Maybe you launched a lot of Ayadn instances at the same time? That's no problem, but in this case you should increase the value of the scroll timer (with `ayadn set scroll timer 5` for example). App.net allows 5000 requests per hour per account maximum.".color(:cyan)
        Errors.global_error({error: "TOO MANY REQUESTS", caller: caller, data: [message, response.headers]})
      when 500
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "APP.NET SERVER ERROR", caller: caller, data: [message, response.headers]})
      when 507
        puts "\n#{message}".color(:red)
        Errors.global_error({error: "INSUFFICIENT STORAGE", caller: caller, data: [message, response.headers]})
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
        puts "\nConnection error.".color(:red)
        Errors.global_error({error: e, caller: caller, data: [url]})
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
        puts "\nConnection error.".color(:red)
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
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
        puts "\nConnection error.".color(:red)
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [url, payload]})
      end
    end

  end
end
