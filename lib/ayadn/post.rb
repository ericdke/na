# encoding: utf-8
module Ayadn
  class Post

    def initialize
      @status = Status.new
    end

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
      post_size(reply)
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

    def entities
      {
        "parse_markdown_links" => true,
        "parse_links" => true
      }
    end

    # -----

    def send_content(url, payload)
      url << "?include_annotations=1&access_token=#{Ayadn::Settings.user_token}"
      JSON.parse(CNX.post(url, payload))
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
            resp = post({text: buffer})
            FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
            puts Status.done
          end
        rescue Interrupt
          abort(Status.canceled)
        end
      end
    end

    def readline
      @status.readline
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

    def post_size(post) # works on a string
      words = post.split(" ")
      result = []
      words.each { |word| result << get_markdown_text(word) }
      post = result.join(" ")
      size, max_size = post.length, Settings.config[:post_max_length]
      if size < 1
        abort(error_text_empty)
      elsif size > max_size
        Errors.warn "Canceled: too long (#{size - max_size}chars)"
        puts "\nYour text was: \n\n#{post}\n\n".color(:yellow)
        @status.too_long(size, max_size)
        exit
      end
    end

    def check_post_length(lines_array) # works on an array
      check_length(lines_array, Settings.config[:post_max_length])
    end

    def check_message_length(lines_array) # works on an array
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
        @status.too_long(size, max_size)
        exit
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
      @status.no_text
      Errors.warn "-Post without text-"
    end

  end
end
