# encoding: utf-8
module Ayadn
  class CNX

    def self.get(url)
      RestClient.get(url)
    end

    def self.get_response_from(url)
      begin
        RestClient.get(url) do |response, request, result| #, :verify_ssl => OpenSSL::SSL::VERIFY_NONE
          check(response)
        end
      rescue => e
        Errors.global_error("cnx/get", url, e)
      end
    end

    def self.check(response)
      case response.code
      when 200
        response
      when 204
        puts "\n'No content'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "NO CONTENT")
      when 400
        puts "\n'Bad request'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "BAD REQUEST")
      when 401
        puts "\n'Unauthorized'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "UNAUTHORIZED")
      when 403
        puts "\n'Forbidden'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "FORBIDDEN")
      when 405
        puts "\n'Method not allowed'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "METHOD NOT ALLOWED")
      when 429
        puts "\n'Too many requests'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "TOO MANY REQUESTS")
      when 500
        puts "\n'App.net server error'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "APP.NET SERVER ERROR")
      when 507
        puts "\n'Insufficient storage'".color(:red)
        Errors.global_error("cnx.rb", response.headers, "INSUFFICIENT STORAGE")
      else
        response
      end
    end

    def self.delete(url)
      begin
        RestClient::Resource.new(url).delete
      rescue => e
        Errors.global_error("cnx/delete", url, e)
      end
    end

    def self.post(url, payload = nil)
      begin
        RestClient.post(url, payload.to_json, :content_type => :json, :accept => :json) do |response, request, result|
          check(response)
        end
      rescue => e
        Errors.global_error("cnx/post", url, e)
      end
    end

    def self.put(url, payload = nil)
      begin
        RestClient.put url, payload.to_json, :content_type => :json, :accept => :json
      rescue => e
        Errors.global_error("cnx/put", url, e)
      end
    end

  end
end
