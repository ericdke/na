module Ayadn
  class Post

    def post(args)
      unless text_is_empty?(args)
        send_post(args.join(" "))
      else
        error_text_empty
      end
    end

    def compose
      case Settings.config[:platform]
      when /mswin|mingw|cygwin/
        post = classic
      else
        require "readline"
        post = readline
      end
      post
    end

    def reply(new_post, replied_to)
      replied_to = replied_to.values[0]
      reply = replied_to[:handle].dup
      reply << " #{new_post}"
      replied_to[:mentions].uniq!
      replied_to[:mentions].each do |m|
        next if m == replied_to[:username]
        next if m == Settings.config[:identity][:username]
        reply << " @#{m}"
      end
      reply
    end

    def readline
      puts Status.readline
      post = []
      begin
        while buffer = Readline.readline("> ")
          post << buffer
        end
      rescue Interrupt
        #temp
        Errors.warn "Write post: canceled."
        abort(Status.canceled)
      end
      post
    end

    def classic
      puts Status.classic
      input_text = STDIN.gets.chomp
      [input_text]
    end

    def send_pm(username, text)
      url = Endpoints.new.pm_url
      url << "?include_post_annotations=1&access_token=#{Ayadn::Settings.user_token}"
      send_content(url, payload_pm(username, text))
    end

    def send_message(channel_id, text)
      url = Endpoints.new.messages(channel_id, {})
      send_content(url, payload_basic(text))
    end

    def send_log(data)
      url = Endpoints.new.ayadnlog
      send_content(url, payload_log(data))
    end

    def send_post(text)
      url = Endpoints.new.posts_url
      send_content(url, payload_basic(text))
    end

    def send_reply(text, post_id)
      url = Endpoints.new.posts_url
      send_content(url, payload_reply(text, post_id))
    end

    def send_content(url, payload)
      url << "?include_post_annotations=1&access_token=#{Ayadn::Settings.user_token}"
      JSON.parse(CNX.post(url, payload))
    end

    def check_post_length(lines_array)
      max_size = Settings.config[:post_max_length]
      check_length(lines_array, max_size)
    end

    def check_message_length(lines_array)
      max_size = Settings.config[:message_max_length]
      check_length(lines_array, max_size)
    end

    def check_length(lines_array, max_size)
      words_array = []
      lines_array.each { |word| words_array << get_markdown_text(word) }
      size = words_array.join.length
      if size < 1
        error_text_empty
        abort("")
      elsif size > max_size
        Errors.warn "Canceled: too long (#{size - max_size}chars)"
        abort("\n\nCanceled: too long. #{max_size} max, #{size - max_size} characters to remove.\n\n\n".color(:red))
      end
    end

    def get_markdown_text(str)
      str.gsub /\[([^\]]+)\]\(([^)]+)\)/, '\1'
    end

    def markdown_extract(str)
        result = str.gsub /\[([^\]]+)\]\(([^)]+)\)/, '\1|||\2'
        result.split('|||') #=> [text, link]
    end

    def text_is_empty?(args)
      args.empty? || args[0] == ""
    end

    def error_text_empty
      puts "\n\nYou must provide some text.\n\n".color(:red)
      Errors.warn "-Post without text-"
    end

    def annotations
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

    def entities
      {
        "parse_markdown_links" => true,
        "parse_links" => true
      }
    end

    def payload_basic(text)
      {
        "text" => text,
        "entities" => entities,
        "annotations" => annotations
      }
    end

    def payload_pm(username, text)
      {
        "text" => text,
        "entities" => entities,
        "destinations" => username,
        "annotations" => annotations
      }
    end

    def payload_reply(text, reply_to)
      {
        "text" => text,
        "reply_to" => reply_to,
        "entities" => entities,
        "annotations" => annotations
      }
    end

    def payload_log(data)
      extended = annotations
      extended << {
          "type" => "com.ayadn.log",
          "value" => data
        }
      return {
        "text" => "#ayadnlog",
        "entities" => entities,
        "annotations" => extended
      }
    end

  end
end
