# encoding: utf-8
module Ayadn
  class FileOps

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

    def self.old_ayadn?
      Dir.exist?(Dir.home + "/ayadn/data")
    end

    def self.upload(file, token)
      case File.extname(file).downcase
      when ".png"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=image/png" -X POST`
      when ".gif"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=image/gif" -X POST`
      when ".json",".txt",".md",".markdown",".mdown",".html",".css",".scss",".sass",".jade",".rb",".py",".sh",".js",".xml",".csv",".styl",".liquid",".ru","yml",".coffee",".php"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=text/plain" -X POST`
      when ".zip"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=application/zip" -X POST`
      when ".rar"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content= ile};type=application/rar" -X POST`
      when ".mp4"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=video/mp4" -X POST`
      when ".mov"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content=@#{file};type=video/quicktime" -X POST`
      when ".mkv",".mp3",".m4a",".m4v",".wav",".aif",".aiff",".aac",".flac"
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F "content= ile};type=application/octet-stream" -X POST`
      else
        `curl -k -H 'Authorization: BEARER #{token}' https://api.app.net/files -F 'type=com.ayadn.files' -F content=@#{file} -X POST`
      end
    end

    private

    def get_users(list)
      h = {}
      list.each {|k,v| h[k] = { username: v[0], name: v[1] }}
      h
    end

  end
end
