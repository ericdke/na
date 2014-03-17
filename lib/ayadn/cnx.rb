# encoding: utf-8
module Ayadn
  class CNX

    def self.get(url)
      RestClient.get(url)
    end

    def self.get_response_from(url)
      begin
        RestClient.get(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response }
      rescue => e
        Errors.global_error("cnx/get", url, e)
      end
    end

    def self.delete(url)
      begin
        RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).delete
      rescue => e
        Errors.global_error("cnx/delete", url, e)
      end
    end

    def self.post(url, payload = nil)
      begin
        RestClient.post url, payload.to_json, :content_type => :json, :accept => :json
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
