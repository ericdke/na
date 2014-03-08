module Ayadn
  class FileOps

    def self.save_post(resp)
      id = resp['data']['id']
      f = File.new(MyConfig.config[:paths][:posts] + "/#{id}.json", "w")
      f.write(resp['data'].to_json)
      f.close
    end

    def self.save_message(resp)
      id = resp['data']['id']
      f = File.new(MyConfig.config[:paths][:messages] + "/#{id}.json", "w")
      f.write(resp['data'].to_json)
      f.close
    end

  end
end
