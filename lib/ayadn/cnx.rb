module Ayadn
  class CNX

    def self.get_response_from(url)
      RestClient.get(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response }
    end

    def self.delete(url)
      begin
        RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).delete
      rescue => e
        Logs.rec.error "From cnx/delete"
        Logs.rec.error "#{e}"
      end
    end

    def self.post(url, payload)
      begin
        RestClient.post url, payload.to_json, :content_type => :json, :accept => :json
      rescue => e
        Logs.rec.error "From cnx/post"
        Logs.rec.error "#{e}"
      end
    end

  end
end
