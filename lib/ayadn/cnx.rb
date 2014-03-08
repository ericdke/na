module Ayadn
  class CNX

    def self.get_response_from(url)
      begin
        RestClient.get(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE) {|response, request, result| response }
      rescue => e
        Logs.rec.error "From cnx/get #{url}"
        Logs.rec.error "#{e}"
        raise e
      end
    end

    def self.delete(url)
      begin
        RestClient::Resource.new(url, :verify_ssl => OpenSSL::SSL::VERIFY_NONE).delete
      rescue => e
        Logs.rec.error "From cnx/delete #{url}"
        Logs.rec.error "#{e}"
        raise e
      end
    end

    def self.post(url, payload = nil)
      begin
        RestClient.post url, payload.to_json, :content_type => :json, :accept => :json
      rescue => e
        Logs.rec.error "From cnx/post #{url}"
        Logs.rec.error "#{e}"
        raise e
      end
    end

  end
end
