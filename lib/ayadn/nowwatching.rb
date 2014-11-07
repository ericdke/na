# encoding: utf-8
module Ayadn

  class NowWatching

    require 'spotlite'

    def initialize view = nil
      @view = view
      @spotlite = Spotlite::Movie
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
      puts "\nContacting IMDb.com...".color(:cyan)
      response = find_by_title(args, options)
      text = format_post(response)
      show_post(text)
      filename = create_filename(response)
      FileOps.download_url(filename, response.poster_url)
      @view.clear_screen
      puts "\nPosting and uploading the movie poster...\n".color(:green)
      options[:embed] = ["#{Settings.config[:paths][:downloads]}/#{filename}"]
      options[:movie] = true
      dic = {
        options: options,
        text: text,
        title: response.title,
        source: 'IMDb'
      }
      resp = Post.new.post(dic)
      FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
      @view.clear_screen
      puts Status.yourpost
      @view.show_posted(resp)
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
      plot = response.description
      if plot.length > max
        "#{plot[0..short]}..."
       else
        plot
      end
    end

    private

    def show_post text
      @view.clear_screen
      puts Status.writing
      puts "\nYour post:\n\n".color(:cyan)
      puts text
      puts "\nIs it ok? (y/N)".color(:yellow)
      abort(Status.canceled) unless STDIN.getch == ("y" || "Y")
    end

  end
end
