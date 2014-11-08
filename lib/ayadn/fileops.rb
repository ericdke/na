# encoding: utf-8
module Ayadn
  class FileOps

    def self.save_links(obj, name)
      File.write(Settings.config[:paths][:lists] + "/#{name}", obj.to_json)
    end

    def self.save_post(resp)
      File.write(Settings.config[:paths][:posts] + "/#{resp['data']['id']}.json", resp['data'].to_json)
    end

    def self.save_message(resp)
      File.write(Settings.config[:paths][:messages] + "/#{resp['data']['id']}.json", resp['data'].to_json)
    end

    def self.save_followings_list(list)
      fg = get_users(list)
      File.write(Settings.config[:paths][:lists] + "/followings.json", fg.to_json)
    end

    def self.save_followers_list(list)
      fr = get_users(list)
      File.write(Settings.config[:paths][:lists] + "/followers.json", fr.to_json)
    end

    def self.save_muted_list(list)
      mt = get_users(list)
      File.write(Settings.config[:paths][:lists] + "/muted.json", mt.to_json)
    end

    def self.download_url(name, url)
      file = CNX.get_response_from(url)
      File.write(Settings.config[:paths][:downloads] + "/#{name}", file)
    end

    def self.upload_files files
      files.map do |file|
        puts "\n#{file}\n\n"
        JSON.load(self.upload(file, Settings.user_token))
      end
    end

    def self.upload(file, token)
      begin
        case File.extname(file).downcase
        when ".png"
          `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=image/png" -F 'public=true' -X POST`
        when ".gif"
          `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=image/gif" -F 'public=true' -X POST`
        else #jpg or jpeg or JPG or JPEG, automatically recognized as such
          `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file}" -F 'public=true' -X POST`
        end
      rescue Errno::ENOENT
        Status.new.no_curl
        exit
      end
    end

    def self.make_paths(files_array)
      files_array.map do |file|
        unless File.exist?(file)
          Status.new.bad_path
          exit
        end
        File.absolute_path(file)
      end
    end

    def self.upload_avatar file
      begin
        `curl -X POST -H "Authorization: Bearer #{Settings.user_token}" -F "avatar=@#{file}" #{Endpoints.new.avatar}`
      rescue Errno::ENOENT
        Status.new.no_curl
        exit
      end
    end

    def self.upload_cover file
      begin
        `curl -X POST -H "Authorization: Bearer #{Settings.user_token}" -F "cover=@#{file}" #{Endpoints.new.cover}`
      rescue Errno::ENOENT
        Status.new.no_curl
        exit
      end
    end

    def self.get_users(list)
      h = {}
      list.each {|k,v| h[k] = { username: v[0], name: v[1] }}
      h
    end

  end
end
