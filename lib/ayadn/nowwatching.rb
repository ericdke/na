# encoding: utf-8
module Ayadn

  class NowWatching

    begin
      require 'spotlite'
    rescue LoadError => e
      puts "\nAYADN: Error while loading an external resource\n\n"
      puts "RUBY: #{e}\n\n"
      exit
    end

    def initialize view = nil
      @view = view
      @spotlite = Spotlite::Movie
      @status = Status.new
    end

    # -----

    def get_response args, options
      find_by_title(args, options)
    end

    def create_filename response
      reg = /[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/
      "#{response.title.downcase.strip.gsub(reg, '_').split(' ').join('_')}.jpg"
    end

    # This is only for the `-M` option in the CLI
    def get_poster args, options
      options = options.dup
      response = get_response(args, options)
      filename = create_filename(response)
      FileOps.download_url(filename, response.poster_url)
      options[:embed] ||= []
      options[:embed] << "#{Settings.config[:paths][:downloads]}/#{filename}"
      return options
    end

    # -----

    def post args, options
      options = options.dup
      @status.info("connected", "IMDb", "yellow")
      response = find_by_title(args, options)
puts response.inspect
exit
      text = format_post(response)
      show_post(text)
      filename = create_filename(response)
      FileOps.download_url(filename, response.poster_url) # !!!

      @view.clear_screen
      @status.info("uploading", "movie poster", "yellow")
      options[:embed] = ["#{Settings.config[:paths][:downloads]}/#{filename}"]
      options[:movie] = true
      dic = {
        options: options,
        text: text,
        title: response.title,
        source: 'IMDb'
      }
      resp = Post.new.post(dic)
      post_object = PostObject.new(resp["data"])
      FileOps.save_post(resp) if Settings.options[:backup][:posts]
      @view.clear_screen
      @status.yourpost
      puts "\n\n"
      @view.show_posted([post_object])
    end

    def find_by_title args, options = {}
      resp = @spotlite.find(args.join(' '))
      if options['alt']
        resp[1]
      else
        resp[0]
      end
    end

    def format_post response
      tag = Settings.options[:movie][:hashtag]
      text_1 = "'#{response.title}' (#{response.year})"
      link = "[IMDb](#{response.url})"
      plot = format_plot(response, text_1)
      "#{text_1}\n \n#{plot}\n \n#{link}\n \n##{tag}\n\n"
    end

    def format_plot response, text
      max = 239 - (text.length + Settings.options[:movie][:hashtag].length)
      short = max - 3
      plot = response.description.nil? ? response.title : response.description
      if plot.length > max
        "#{plot[0..short]}..."
       else
        plot
      end
    end

    private

    def show_post text
      @view.clear_screen
      @status.writing
      @status.to_be_posted
      thor = Thor::Shell::Basic.new
      puts "\n"
      text.split("\n").each do |line|
        thor.say_status(nil, line.color(Settings.options[:colors][:excerpt]))
      end
      puts "\n"
      @status.ok?
      unless STDIN.getch == ("y" || "Y")
        @status.canceled
        exit
      end
    end

  end
end
