module Ayadn
  class Post

    def post(args)
      unless text_is_empty?(args)
        send_post(args.join(" "))
      else
        error_text_empty
      end
    end

    def send_post(text)
      url = Endpoints::POSTS_URL
      url << "?include_post_annotations=1&access_token=#{Ayadn::MyConfig.user_token}"
      resp = CNX.post(url, payload_basic(text))
      API.check_http_error(resp)
      JSON.parse(resp)
    end

    def compose
      case MyConfig.config[:platform]
      when /mswin|mingw|cygwin/
        post = classic
      else
        require "readline"
        post = readline
      end
      post
    end

    def reply(post_id)
      #payload = payload_reply(text, post_id)
      # extract mentions
      # post = compose
      # post = mention + post + (other mentions)
      # prepare object
      # send
    end

    def readline
      puts "\nType your text. [CTRL+D] to validate, [CTRL+C] to cancel.\n\n".color(:cyan)
      post = []
      begin
        while buffer = Readline.readline("> ")
          post << buffer
        end
      rescue Interrupt
        #temp
        Logs.rec.warn "Write post: canceled."
        abort("Canceled.")
      end
      post
    end

    def classic
      puts "\nType your text. [ENTER] to validate, [CTRL+C] to cancel.\n\n".color(:cyan)
      input_text = STDIN.gets.chomp
      [input_text]
    end

    def check_length(lines_array, target)
      if target == :post
        max_size = 256 #temp
      elsif target == :message
        max_size = 2048 #temp
      end
      words_array, items_array = [], []
      lines_array.each { |word| words_array << get_markdown_text(word) }
      size = words_array.join.length
      if size < 1
        error_text_empty
        abort("")
      elsif size > max_size
        Logs.rec.warn "Canceled: too long (#{size - max_size}chars)"
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
      Logs.rec.warn "-Post without text-"
    end

    def annotations
      [
        {
        "type" => "com.ayadn.client",
        "value" => {
          "+net.app.core.user" => {
              "user_id" => "@ayadn",
              "format" => "basic"
            }
          }
        },
        {
        "type" => "com.ayadn.client",
        "value" => { "url" => "http://ayadn-app.net" }
        },
        "type" => "com.ayadn.client",
        "value" => { "version" => "#{MyConfig.config[:version]}" }
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

    def payload_reply(text, reply_to) #data should be a struct
      {
        "text" => text,
        "reply_to" => reply_to,
        "entities" => entities,
        "annotations" => annotations
      }
    end

  end
end
