# encoding: utf-8
module Ayadn

  class TvShow

    require 'tvdb_party'

    AYADN_TVDB_API_KEY = '3F21527FE4C9C274'

    attr_accessor :language, :name, :poster_url, :banner_url, :plot, :text, :imdb_link, :tag, :link, :date

    def initialize
      @language = 'en'
      @view = View.new
      @tvdb = TvdbParty::Search.new(AYADN_TVDB_API_KEY)
    end

    def find title
      res = find_all(title)
      abort(Status.no_show) if res[0].nil?
      if res[0].has_key?('FirstAired')
        return @tvdb.get_series_by_id(res[0]['seriesid'])
      else
        return @tvdb.get_series_by_id(res[1]['seriesid']) unless res[1].nil?
      end
      abort(Status.no_show)
    end

    def find_alt title
      res = find_all(title)
      abort(Status.no_show) if res[0].nil?
      if res[0].has_key?('FirstAired')
        return @tvdb.get_series_by_id(res[1]['seriesid']) unless res[1].nil?
      else
        return @tvdb.get_series_by_id(res[2]['seriesid']) unless res[2].nil?
      end
      abort(Status.no_show)
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
      puts "\nYour post:\n\n".color(:cyan)
      puts @text
      puts "\n\nIs it ok? (y/N)".color(:yellow)
      STDIN.getch == ("y" || "Y") ? true : false
    end

    def post options = {}
      reg = /[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/
      filename = "#{@name.downcase.strip.gsub(reg, '_').split(' ').join('_')}.jpg"
      if options['banner']
        FileOps.download_url(filename, @banner_url)
      else
        FileOps.download_url(filename, @poster_url)
      end
      @view.clear_screen
      puts "\nPosting and uploading the show poster...\n".color(:green)
      file = ["#{Settings.config[:paths][:downloads]}/#{filename}"]
      dic = {
        'text' => @text,
        'data' => FileOps.upload_files(file),
        'title' => @name,
        'source' => 'TVDb'
      }
      resp = Post.new.send_tvshow(dic)
      FileOps.save_post(resp) if Settings.options[:backup][:auto_save_sent_posts]
      @view.clear_screen
      puts Status.yourpost
      @view.show_posted(resp)
    end

    def cancel
      abort(Status.canceled)
    end

    private

    def find_all title
      @tvdb.search(title)
    end

    def find_poster_url show_obj
      poster = show_obj.posters(@language).first
      poster.nil? ? abort(Status.no_show_infos) : poster.url
    end

    def find_banner_url show_obj
      banner = show_obj.series_banners(@language).first
      banner.nil? ? abort(Status.no_show_infos) : banner.url
    end

    def find_plot show_obj
      show_obj.overview
    end

  end
end
