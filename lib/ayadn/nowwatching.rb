# encoding: utf-8
module Ayadn

  class NowWatching

    def initialize view
      @view = view
    end

    def post args, options
      puts "\nContacting IMDb.com...\n\n".color(:cyan)
      response = find_by_title(args)
      text = format_post(response)
      show_post(text)
      filename = "#{args.join('_')}.jpg"
      FileOps.download_url(filename, response.poster_url)
      @view.clear_screen
      puts "\nPosting and uploading the movie poster...\n".color(:green)
      file = ["#{Settings.config[:paths][:downloads]}/#{filename}"]
      resp = Post.new.send_embedded(text, file)
      FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
      @view.clear_screen
      puts Status.yourpost
      @view.show_posted(resp)
    end

    def find_by_title args
      require 'filmbuff'
      imdb = FilmBuff::IMDb.new
      response = imdb.find_by_title(args.join(' '))
      if response.nil? || response.is_a?(Array) || response.release_date.nil?
        raise ArgumentError
      end
      response
    end

    def format_post response
      text_1 = "#nowwatching #movie\n \n'#{response.title}' (#{response.release_date.year})"
      link = "[IMDb](http://imdb.com/title/#{response.imdb_id}/)"
      plot = format_plot(response, text_1)
      "#{text_1}\n \n#{plot}\n \n#{link}\n\n"
    end

    def format_plot response, text
      max = 250 - text.length  # 250 = 256 - 'IMDb' and 2 spaces
      short = max - 3
      if response.plot.length > max
        "#{response.plot[0..short]}..."
       else
        response.plot
      end
    end

    private

    def show_post text
      @view.clear_screen
      puts "\nYour post:\n\n".color(:cyan)
      puts text
      puts "\nIs it ok? (y/N)".color(:yellow)
      abort(Status.canceled) unless STDIN.getch == ("y" || "Y")
    end

  end
end
