module Ayadn
  class FileOps

    def save_post(resp)
      id = resp['data']['id']
      f = File.new(MyConfig.config[:paths][:posts] + "/#{id}.json")
      f.write(resp.to_json)
      f.close
    end

  end
end
