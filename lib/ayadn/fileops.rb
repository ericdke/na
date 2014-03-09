module Ayadn
  class FileOps

    def self.save_post(resp)
      File.write(MyConfig.config[:paths][:posts] + "/#{resp['data']['id']}.json", resp['data'].to_json)
    end

    def self.save_message(resp)
      File.write(MyConfig.config[:paths][:messages] + "/#{resp['data']['id']}.json", resp['data'].to_json)
    end

    def self.save_followings_list(list)
      fg = get_users(list)
      File.write(MyConfig.config[:paths][:lists] + "/followings.json", fg.to_json)
    end

    def self.save_followers_list(list)
      fr = get_users(list)
      File.write(MyConfig.config[:paths][:lists] + "/followers.json", fr.to_json)
    end

    def self.save_muted_list(list)
      mt = get_users(list)
      File.write(MyConfig.config[:paths][:lists] + "/muted.json", mt.to_json)
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
