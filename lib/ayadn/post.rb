# encoding: utf-8
module Ayadn
  class Post

    require_relative "annotations"

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
        next if m == Settings.config.identity.username
        reply << " @#{m}"
      end
      post_size_error(reply) if post_size_ok?(reply) == false
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
          while buffer = Readline.readline(">> ".color(:red))
            resp = post({text: buffer})
            FileOps.save_post(resp) if Settings.options[:backup][:posts]
            @status.done
          end
        rescue Interrupt
          @status.canceled
          exit
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
        @status.canceled
        exit
      end
      post
    end

    def post_size_ok?(post) # works on a string, returns boolean
      text = keep_text_from_markdown_links(post)
      size, max_size = text.length, Settings.config.post_max_length
      (size >= 1 && size <= max_size)
    end

    def message_size_ok?(message) # works on a string, returns boolean
      text = keep_text_from_markdown_links(message)
      size, max_size = text.length, Settings.config.message_max_length
      (size >= 1 && size <= max_size)
    end

    def post_size_error(post)
      text = keep_text_from_markdown_links(post)
      size, max_size = text.length, Settings.config.post_max_length
      bad_text_size(post, size, max_size)
    end

    def message_size_error(message)
      text = keep_text_from_markdown_links(message)
      size, max_size = text.length, Settings.config.message_max_length
      bad_text_size(message, size, max_size)
    end

    def bad_text_size(post, size, max_size)
      if size < 1
        error_text_empty()
      elsif size > max_size
        Errors.warn "Canceled: too long (#{size - max_size}chars)"
        @status.info("info", "your text:", "cyan")
        puts post
        @status.too_long(size, max_size)
        exit
      end
    end

    def keep_text_from_markdown_links(str)
      str.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1')
    end

    def markdown_extract(str)
        result = str.gsub(/\[([^\]]+)\]\(([^)]+)\)/, '\1|||\2')
        result.split('|||') #=> [text, link]
    end

    def error_text_empty
      @status.no_text
      Errors.warn "-No text-"
      exit
    end

  end
end
