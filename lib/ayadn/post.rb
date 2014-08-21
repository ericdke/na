# encoding: utf-8
module Ayadn
  class Post

    def post(dic)
      send_content(Endpoints.new.posts_url, payload_basic(dic))
    end

    def reply(dic)
      replied_to = dic[:reply_to].values[0]
      reply = replied_to[:handle].dup
      reply << " #{dic[:text]}"
      replied_to[:mentions].uniq!
      replied_to[:mentions].each do |m|
        next if m == replied_to[:username]
        next if m == Settings.config[:identity][:username]
        reply << " @#{m}"
      end
      dic[:text] = reply
      dic[:reply_to] = dic[:id]
      send_content(Endpoints.new.posts_url, payload_reply(dic))
    end

    def pm(dic)
      send_content(Endpoints.new.pm_url, payload_pm(dic))
    end

    def message(dic)
      send_content(Endpoints.new.messages(dic[:id]), payload_basic(dic))
    end

    # -----

    def payload_basic(dic)
      {
        "text" => dic[:text],
        "entities" => entities(),
        "annotations" => Annotations.new(dic).content
      }
    end

    def payload_pm(dic)
      {
        "text" => dic[:text],
        "entities" => entities(),
        "destinations" => dic[:username],
        "annotations" => Annotations.new(dic).content
      }
    end

    def payload_reply(dic)
      {
        "text" => dic[:text],
        "reply_to" => dic[:reply_to],
        "entities" => entities(),
        "annotations" => Annotations.new(dic).content
      }
    end

    # -----

    def send_content(url, payload)
      url << "?include_annotations=1&access_token=#{Ayadn::Settings.user_token}"
      JSON.parse(CNX.post(url, payload))
    end



    def send_nowplaying dic
      send_content(Endpoints.new.posts_url, payload_nowplaying(dic))
    end

    def send_movie dic
      send_content(Endpoints.new.posts_url, payload_movie(dic))
    end

    def send_tvshow dic
      send_content(Endpoints.new.posts_url, payload_tvshow(dic))
    end

    # -----

    def compose
      readline()
    end

    def auto_readline
      loop do
        begin
          #while buffer = Readline.readline("#{Settings.config[:identity][:handle]} >> ".color(:red))
          while buffer = Readline.readline(">> ".color(:red))
            send_post(buffer)
            puts Status.done
          end
        rescue Interrupt
          abort(Status.canceled)
        end
      end
    end

    def readline
      puts Status.readline
      post = []
      begin
        while buffer = Readline.readline("> ")
          post << buffer
        end
      rescue Interrupt
        abort(Status.canceled)
      end
      post
    end

    def check_post_length(lines_array)
      check_length(lines_array, Settings.config[:post_max_length])
    end

    def check_message_length(lines_array)
      check_length(lines_array, Settings.config[:message_max_length])
    end

    def check_length(lines_array, max_size)
      words_array = []
      lines_array.each { |word| words_array << get_markdown_text(word) }
      size = words_array.join.length
      if size < 1
        error_text_empty
        exit
      elsif size > max_size
        Errors.warn "Canceled: too long (#{size - max_size}chars)"
        abort(Status.too_long(size, max_size))
      end
    end

    def get_markdown_text(str)
      str.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1')
    end

    def markdown_extract(str)
        result = str.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1|||\2')
        result.split('|||') #=> [text, link]
    end

    def text_is_empty?(args)
      args.empty? || args[0] == ""
    end

    def error_text_empty
      puts Status.no_text
      Errors.warn "-Post without text-"
    end

    def entities
      {
        "parse_markdown_links" => true,
        "parse_links" => true
      }
    end

    # def annotations
    #   [
    #     {
    #     "type" => "com.ayadn.user",
    #     "value" => {
    #       "+net.app.core.user" => {
    #           "user_id" => "#{Settings.config[:identity][:handle]}",
    #           "format" => "basic"
    #         }
    #       }
    #     },
    #     {
    #     "type" => "com.ayadn.client",
    #     "value" => {
    #       "url" => "http://ayadn-app.net",
    #       "author" => {
    #           "name" => "Eric Dejonckheere",
    #           "username" => "ericd",
    #           "id" => "69904",
    #           "email" => "eric@aya.io"
    #         },
    #       "version" => "#{Settings.config[:version]}"
    #       }
    #     }
    #   ]
    # end

    # def payload_movie dic
    #   ann = annotations_embedded(dic)
    #   ann << {
    #     "type" => "com.ayadn.movie",
    #       "value" => {
    #         "title" => dic['title'],
    #         "source" => dic['source']
    #       }
    #   }
    #   {
    #     "text" => dic['text'],
    #     "entities" => entities,
    #     "annotations" => ann
    #   }
    # end

    # def payload_tvshow dic
    #   ann = annotations_embedded(dic)
    #   ann << {
    #     "type" => "com.ayadn.tvshow",
    #       "value" => {
    #         "title" => dic['title'],
    #         "source" => dic['source']
    #       }
    #   }
    #   {
    #     "text" => dic['text'],
    #     "entities" => entities,
    #     "annotations" => ann
    #   }
    # end

    # def payload_nowplaying dic
    #   ann = annotations()
    #   if dic['visible'] == true
    #     ann << {
    #       "type" => "com.ayadn.nowplaying",
    #         "value" => {
    #           "title" => dic['title'],
    #           "artist" => dic['artist'],
    #           "artwork" => dic['artwork'],
    #           "link" => dic['link'],
    #           "source" => dic['source']
    #         }
    #     }
    #   else
    #     ann << {
    #       "type" => "com.ayadn.nowplaying",
    #         "value" => {
    #           "status" => "no-url",
    #           "source" => dic['source']
    #         }
    #     }
    #   end
    #   if dic['visible'] == true
    #     ann << {
    #       "type" => "net.app.core.oembed",
    #       "value" => {
    #         "version" => "1.0",
    #         "type" => "photo",
    #         "width" => dic['width'],
    #         "height" => dic['height'],
    #         "title" => dic['title'],
    #         "url" => dic['artwork'],
    #         "embeddable_url" => dic['artwork'],
    #         "provider_url" => "https://itunes.apple.com",
    #         "provider_name" => "iTunes",
    #         "thumbnail_url" => dic['artwork_thumb'],
    #         "thumbnail_width" => dic['width_thumb'],
    #         "thumbnail_height" => dic['height_thumb']
    #       }
    #     }
    #   end
    #   {
    #     "text" => dic['text'],
    #     "entities" => entities,
    #     "annotations" => ann
    #   }
    # end

    # def payload_basic(text)
    #   {
    #     "text" => text,
    #     "entities" => entities,
    #     "annotations" => annotations
    #   }
    # end

    # def payload_pm(username, text)
    #   {
    #     "text" => text,
    #     "entities" => entities,
    #     "destinations" => username,
    #     "annotations" => annotations
    #   }
    # end

    # def payload_reply(text, reply_to)
    #   {
    #     "text" => text,
    #     "reply_to" => reply_to,
    #     "entities" => entities,
    #     "annotations" => annotations
    #   }
    # end

    # def payload_log(data)
    #   extended = annotations
    #   extended << {
    #       "type" => "com.ayadn.log",
    #       "value" => data
    #     }
    #   return {
    #     "text" => "#ayadnlog",
    #     "entities" => entities,
    #     "annotations" => extended
    #   }
    # end

  end
end
