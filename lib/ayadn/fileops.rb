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

    def self.save_followings_list(list)
      fg = get_users(list)
      f = File.new(MyConfig.config[:paths][:lists] + "/followings.json", "w")
      f.write(fg.to_json)
      f.close
    end

    def self.save_followers_list(list)
      fg = get_users(list)
      f = File.new(MyConfig.config[:paths][:lists] + "/followers.json", "w")
      f.write(fg.to_json)
      f.close
    end

    def self.save_muted_list(list)
      fg = get_users(list)
      f = File.new(MyConfig.config[:paths][:lists] + "/muted.json", "w")
      f.write(fg.to_json)
      f.close
    end

    private

    def get_users(list)
      h = {}
      list.each do |k,v|
        h[k] = { username: v[0], name: v[1] }
      end
      h
    end

  end
end
