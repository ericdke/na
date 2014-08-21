# encoding: utf-8

module Ayadn

  class Annotations

    attr_accessor :content

    def initialize(dic)
      dic[:options] = {} if dic[:options].nil?
      @content = base()
      @content += files(dic) if dic[:options][:embed]
      @content += youtube(dic) if dic[:options][:youtube]
      @content += nowplaying(dic) if dic[:options][:nowplaying]
      @content += movie(dic) if dic[:options][:movie]
    end

    def base
      [
        {
        "type" => "com.ayadn.user",
        "value" => {
          "+net.app.core.user" => {
              "user_id" => "#{Settings.config[:identity][:handle]}",
              "format" => "basic"
            }
          }
        },
        {
        "type" => "com.ayadn.client",
        "value" => {
          "url" => "http://ayadn-app.net",
          "author" => {
              "name" => "Eric Dejonckheere",
              "username" => "ericd",
              "id" => "69904",
              "email" => "eric@aya.io"
            },
          "version" => "#{Settings.config[:version]}"
          }
        }
      ]
    end

    def files(dic)
      files = FileOps.make_paths(dic[:options][:embed])
      data = FileOps.upload_files(files)
      data.map do |obj|
        {
          "type" => "net.app.core.oembed",
          "value" => {
             "+net.app.core.file" => {
                "file_id" => obj['data']['id'],
                "file_token" => obj['data']['file_token'],
                "format" => "oembed"
             }
          }
        }
      end
    end

    def youtube(dic)
      dic['link'] = dic[:options][:youtube][0]
      req_url = "http://www.youtube.com/oembed?url=#{dic['link']}&format=json"
      dic.merge!(JSON.parse(CNX.download(req_url)))
      [{
        "type" => "net.app.core.oembed",
        "value" => {
          "version" => "1.0",
          "type" => "video",
          "provider_name" => "YouTube",
          "provider_url" => "http://youtube.com/",
          "width" => dic['width'],
          "height" => dic['height'],
          "title" => dic['title'],
          "author_name" => dic['author_name'],
          "author_url" => dic['author_url'],
          "embeddable_url" => dic['link'],
          "html" => dic['html'],
          "thumbnail_url" => dic['thumbnail_url'],
          "thumbnail_height" => dic['thumbnail_height'],
          "thumbnail_width" => dic['thumbnail_width']
        }
      },
      {
        "type" => "com.ayadn.youtube",
          "value" => {
            "title" => dic['title'],
            "link" => dic['link']
          }
      }]
    end

    def movie(dic)
      [{
        "type" => "com.ayadn.movie",
          "value" => {
            "title" => dic[:title],
            "source" => dic[:source]
          }
      }]
    end

    def tvshow(dic)
      [{
        "type" => "com.ayadn.tvshow",
          "value" => {
            "title" => dic['title'],
            "source" => dic['source']
          }
      }]
    end

    def nowplaying_silent(dic)
      [{
        "type" => "com.ayadn.nowplaying",
          "value" => {
            "status" => "no-url",
            "source" => dic[:source]
          }
      }]
    end

    def nowplaying(dic)
      return nowplaying_silent(dic) if dic[:options][:no_url]
      [{
        "type" => "com.ayadn.nowplaying",
          "value" => {
            "title" => dic[:title],
            "artist" => dic[:artist],
            "artwork" => dic[:artwork],
            "link" => dic[:link],
            "source" => dic[:source]
          }
      },
      {
        "type" => "net.app.core.oembed",
        "value" => {
          "version" => "1.0",
          "type" => "photo",
          "width" => dic[:width],
          "height" => dic[:height],
          "title" => dic[:title],
          "url" => dic[:artwork],
          "embeddable_url" => dic[:artwork],
          "provider_url" => "https://itunes.apple.com",
          "provider_name" => "iTunes",
          "thumbnail_url" => dic[:artwork_thumb],
          "thumbnail_width" => dic[:width_thumb],
          "thumbnail_height" => dic[:height_thumb]
        }
      }]
    end

  end

end
