# encoding: utf-8

module Ayadn

  class Annotations

    ###
    # This class contains the "annotations" (metadata) templates for posting to ADN

    attr_accessor :content

    # Creates basic annotations and optionally adds necessary ones
    def initialize(dic)
      dic[:options] = {} if dic[:options].nil?
      @content = base()
      @content += files(dic) if dic[:options][:embed]
      @content += youtube(dic) if dic[:options][:youtube]
      @content += vimeo(dic) if dic[:options][:vimeo]
      @content += nowplaying(dic) if dic[:options][:nowplaying]
    end

    def base
      # Creates basic post metadata
      # Both types are custom types for Ayadn (all types beginning with "com.ayadn" are custom types)
      [
        {
        "type" => "com.ayadn.user",
        "value" => {
          "+net.app.core.user" => {
              "user_id" => Settings.config.identity.handle,
              "format" => "basic"
            },
            "env" => {
              "platform" => Settings.config.platform,
              "ruby" => Settings.config.ruby,
              "locale" => Settings.config.locale
            }
          }
        },
        {
        "type" => "com.ayadn.client",
        "value" => {
          "url" => "https://github.com/ericdke/na",
          "author" => {
              "name" => "Eric Dejonckheere",
              "username" => "ericd",
              "id" => "69904",
              "email" => "eric@aya.io"
            },
          "version" => Settings.config.version
          }
        }
      ]
    end

    def files(dic)
      # Creates "oembed" metadata for uploaded files
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
      # Fetch Youtube metadata for a video
      dic['link'] = dic[:options][:youtube][0]
      req_url = "http://www.youtube.com/oembed?url=#{dic['link']}&format=json"
      resp = CNX.download(req_url)

      begin
        decoded = JSON.parse(resp)
      rescue => e      
        if resp == "Not Found"       
          Status.new.info("error", "video doesn't exist", "red")
        elsif resp == "Unauthorized"
          Status.new.info("error", "unauthorized", "red")
        else
          Status.new.info("error", resp, "red")
        end
        Errors.global_error({error: e, caller: caller, data: [resp, dic]})
      end
      
      # Adds Youtube oembed metadata to the existing metadata
      # Also adds a custom type for Ayadn
      dic.merge!(decoded)
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

    def vimeo(dic)
      dic[:link] = dic[:options][:vimeo][0]
      req_url = "http://vimeo.com/api/oembed.json?url=#{dic[:link]}"
      resp = CNX.download(req_url)
      begin
        decoded = JSON.parse(resp)
      rescue => e
        Status.new.info("error", resp, "red")
        Errors.global_error({error: e, caller: caller, data: [resp, dic]})
      end
      dic.merge!(decoded)
      [{
        "type" => "net.app.core.oembed",
        "value" => {
          "version" => "1.0",
          "type" => "video",
          "provider_name" => "Vimeo",
          "provider_url" => "http://vimeo.com/",
          "width" => dic['width'],
          "height" => dic['height'],
          "title" => dic['title'],
          "author_name" => dic['author_name'],
          "author_url" => dic['author_url'],
          "embeddable_url" => dic[:link],
          "html" => dic['html'],
          "thumbnail_url" => dic['thumbnail_url'],
          "thumbnail_height" => dic['thumbnail_height'],
          "thumbnail_width" => dic['thumbnail_width']
        }
      },
      {
        "type" => "com.ayadn.vimeo",
          "value" => {
            "title" => dic['title'],
            "link" => dic[:link]
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
      return nowplaying_silent(dic) if dic[:options][:no_url] == true || dic[:visible] == false
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
