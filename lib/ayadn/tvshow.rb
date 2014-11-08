# encoding: utf-8
module Ayadn

  class TvShow

    begin
      require 'tvdb_party'
    rescue LoadError => e
      puts "\nAYADN: Error while loading Gems\n\n"
      puts "RUBY: #{e}\n\n"
      exit
    end

    AYADN_TVDB_API_KEY = 'E874ACBC542CAA53'

    attr_accessor :language, :name, :poster_url, :banner_url, :plot, :text, :imdb_link, :tag, :link, :date

    def initialize
      @language = 'en'
      @view = View.new
      @tvdb = TvdbParty::Search.new(AYADN_TVDB_API_KEY)
      @status = Status.new
    end

    def find title
      res = find_all(title)
      if res[0].nil?
        @status.no_show
        exit
      end
      if res[0].has_key?('FirstAired')
        return @tvdb.get_series_by_id(res[0]['seriesid'])
      else
        return @tvdb.get_series_by_id(res[1]['seriesid']) unless res[1].nil?
      end
      @status.no_show
      exit
    end

    def find_alt title
      res = find_all(title)
      if res[0].nil?
        @status.no_show
        exit
      end
      if res[0].has_key?('FirstAired')
        return @tvdb.get_series_by_id(res[1]['seriesid']) unless res[1].nil?
      else
        return @tvdb.get_series_by_id(res[2]['seriesid']) unless res[2].nil?
      end
      @status.no_show
      exit
    end

    def create_details show_obj
      @name = show_obj.name
      @poster_url = find_poster_url(show_obj)
      @banner_url = find_banner_url(show_obj)
      @plot = find_plot(show_obj)
      @date = show_obj.first_aired.year
      @imdb_link = "http://imdb.com/title/#{show_obj.imdb_id}/"
      create_text()
      return self
    end

    def create_text
      @link = "[IMDb](#{@imdb_link})"
      @tag = Settings.options[:tvshow][:hashtag]
      @date.nil? ? date = '' : date = "(#{@date})"
      pre = "#{@name} #{date}\n \n"
      presize = pre.length + @tag.length + 4 + @plot.length
      max = 241
      if presize > max
        plot_max = max - (pre.length + @tag.length)
        @text = "#{pre}#{@plot[0..plot_max]}...\n \n#{@link}\n \n##{@tag}"
      else
        @text = "#{pre}#{@plot}\n \n#{@link}\n \n##{@tag}"
      end
    end

    def ok
      @view.clear_screen
      @status.writing
      @status.to_be_posted
      thor = Thor::Shell::Basic.new
      puts "\n"
      @text.split("\n").each do |line|
        thor.say_status(nil, line)
      end
      puts "\n"
      @status.ok?
      STDIN.getch == ("y" || "Y") ? true : false
    end

    def post options = {}
      options = options.dup
      reg = /[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/
      filename = "#{@name.downcase.strip.gsub(reg, '_').split(' ').join('_')}.jpg"
      if options['banner']
        FileOps.download_url(filename, @banner_url)
      else
        FileOps.download_url(filename, @poster_url)
      end
      @view.clear_screen
      @status.info("uploading", "show poster", "yellow")
      options[:embed] = ["#{Settings.config[:paths][:downloads]}/#{filename}"]
      options[:tvshow] = true
      dic = {
        options: options,
        text: @text,
        title: @name,
        source: 'TVDb'
      }
      resp = Post.new.post(dic)
      FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
      @view.clear_screen
      @status.yourpost
      puts "\n\n"
      @view.show_posted(resp)
    end

    def cancel
      @status.canceled
      exit
    end

    private

    def find_all title
      @tvdb.search(title)
    end

    def find_poster_url show_obj
      poster = show_obj.posters(@language).first
      if poster.nil?
        @status.no_show_infos
        exit
      else
        poster.url
      end
    end

    def find_banner_url show_obj
      banner = show_obj.series_banners(@language).first
      if banner.nil?
        @status.no_show_infos
        exit
      else
        banner.url
      end
    end

    def find_plot show_obj
      show_obj.overview
    end

  end
end
