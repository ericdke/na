module Ayadn

  class Set < Thor

    desc "scroll ITEM VALUE", "Set the waiting time (in seconds, min 0.7) between two requests when scrolling"
    def scroll(*args)
      scroll_config = SetScroll.new
      if args[0]
        scroll_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      scroll_config.save
    end

    desc "movie ITEM VALUE", "Set values for movie (nowwatching)"
    map "nowwatching" => :movie
    def movie(*args)
      movie_config = SetMovie.new
      unless args.length != 2
        movie_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      movie_config.save
    end

    desc "tvshow ITEM VALUE", "Set values for tvshow (nowwatching)"
    map "tv" => :tvshow
    def tvshow(*args)
      tvshow_config = SetTVShow.new
      unless args.length != 2
        tvshow_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      tvshow_config.save
    end

    desc "marker ITEM TRUE/FALSE", "Set values for stream markers"
    map "markers" => :marker
    def marker(*args)
      marker_config = SetMarker.new
      unless args.length != 2
        marker_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      marker_config.save
    end

    desc "channels ITEM TRUE/FALSE", "Set values for stream markers"
    map "channel" => :channels
    def channels(*args)
      channels_config = SetChannels.new
      unless args.length != 2
        channels_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      channels_config.save
    end

    desc "blacklist ITEM TRUE/FALSE", "Set values for the blacklist"
    def blacklist(*args)
      blacklist_config = SetBlacklist.new
      unless args.length != 2
        blacklist_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      blacklist_config.save
    end

    desc "nicerank ITEM VALUE", "Set NiceRank filter values"
    long_desc Descriptions.set_nicerank
    def nicerank *args
      nicerank_config = SetNiceRank.new
      if args[0]
        nicerank_config.send(args[0], args[1])
      else
        Status.new.error_missing_parameters
        exit
      end
      nicerank_config.save
    end

    desc "timeline ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    long_desc Descriptions.set_timeline
    def timeline(*args)
      timeline_config = SetTimeline.new
      if args[0]
        begin
          timeline_config.send(args[0], args[1])
        rescue NoMethodError, ArgumentError
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
      timeline_config.save
    end

    desc "count ITEM NUMBER", "Set ITEM to retrieve NUMBER of elements by default"
    long_desc Descriptions.set_counts
    map "counts" => :count
    def count(*args)
      counts_config = SetCounts.new
      if args[0]
        begin
          counts_config.send(args[0], args[1])
        rescue NoMethodError, ArgumentError
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
      counts_config.save
    end

    desc "color ITEM COLOR", "Set ITEM to COLOR"
    long_desc Descriptions.set_color
    map "colors" => :color
    map "colour" => :color
    map "colours" => :color
    def color(*args)
      color_config = SetColor.new
      if args[0]
        begin
          color_config.send(args[0], args[1])
        rescue NoMethodError, ArgumentError
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
      color_config.save
    end

    desc "backup ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    long_desc Descriptions.set_backup
    def backup(*args)
      backup_config = SetBackup.new
      if args[0]
        begin
          backup_config.send(args[0], args[1])
        rescue NoMethodError, ArgumentError
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
      backup_config.save
    end

    desc "defaults", "Sets back the configuration to defaults values"
    long_desc Descriptions.set_defaults
    def defaults
      Settings.restore_defaults
      Status.new.done
    end

    desc "formats ITEM VALUE", "Set values for formatting fields"
    def formats(*args)
      formats_config = SetFormats.new
      if args[0]
        begin
          command = args.shift
          formats_config.send(command, args)
        rescue NoMethodError, ArgumentError
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
      formats_config.save
    end

    desc "api URL", "Set an alternative base URL for the API calls."
    def api(*args)
      if args[0]
        begin
          SetAPI.new.setURL(args[0])
        rescue NoMethodError, ArgumentError => e
          Status.new.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        Status.new.error_missing_parameters
        exit
      end
    end

  end

  class Validators

    def self.URL(str)
      require 'net/http'
      if(str.to_s.empty?)
        Status.new.error_missing_parameters
        exit
      end
      begin
        URI.parse(str)
        # if url.host.nil? || (url.scheme != 'http' && url.scheme != 'https')
            # ask: are you sure about this url?
        # end
        # url
      rescue URI::Error => e
        return nil
      end
    end

    def self.boolean(value)
      case value.downcase
      when "true", "1", "yes"
        true
      when "false", "0", "no"
        false
      else
        Status.new.error_missing_parameters
        exit
      end
    end

    def self.index_range(min, max, value)
      x = value.to_i
      if x >= min && x <= max
        x
      else
        Status.new.must_be_integer
      end
    end

    def self.width_range value
      if value >= 60 && value <= 90
        value.round
      else
        75
      end
    end

    def self.threshold value
      value = value.to_f
      if value > 0 and value < 5
        value
      else
        Status.new.threshold
      end
    end

    def self.timer(t)
      t = t.to_f.round
      t >= 1 ? t : 3
    end

    def self.color(color)
      colors_list = %w{red green magenta cyan yellow blue white black}
      unless colors_list.include?(color.to_s)
        Status.new.error_missing_parameters
        Status.new.valid_colors(colors_list)
        exit
      else
        return color.to_sym
      end
    end

  end

  class SetBase

    attr_accessor :input, :output, :category

    def initialize
      Settings.load_config()
      Settings.get_token()
      Settings.init_config()
      Logs.create_logger()
      @status = Status.new
    end

    def save
      Settings.save_config()
      log()
    end

    def log
      @status.say do
        @status.say_cyan :updated, "'#{@input}' in '#{@category}'"
        @status.say_green :content, "'#{@output}'"
      end
      Logs.rec.info "new value for '#{@input}' in '#{@category}' => '#{@output}'"
    end

  end

  class SetAPI < SetBase

    def initialize
      super
      @category = 'API'
      @status = Status.new
    end

    def setURL(url)
      @input = url
      # @status.say_header "checking URL validity"
      url = Validators.URL(url)
      if url != nil
        @output = url.to_s
        @status.say_info "setting up configuration"
        File.write(Dir.home + "/ayadn/.api.yml", {root: @output}.to_yaml)
        log()
      else
        @status.say_red :canceled, "URL is invalid"
        exit
      end
    end

  end

  class SetFormats < SetBase

    def initialize
      super
      @category = 'formats'
    end

    def table(args)
      type = args.shift.downcase
      if type == 'width'
        value = args[0].to_i
        @input = 'table width'
        @output = Validators.width_range(value)
        Settings.options[:formats][:table][:width] = @output
      elsif type == 'borders' || type == 'border'
        value = args[0]
        @input = 'table borders'
        @output = Validators.boolean(value)
        Settings.options[:formats][:table][:borders] = @output
      else
        @status.error_missing_parameters
        exit
      end
    end

    def tables(args)
      table(args)
    end

    def list(args)
      type = args.shift.downcase
      value = args[0]
      if type == 'reverse' || type == 'reversed'
        @input = 'list reverse'
        @output = Validators.boolean(value)
        Settings.options[:formats][:list][:reverse] = @output
      else
        @status.error_missing_parameters
        exit
      end
    end

    def lists(args)
      list(args)
    end

  end

  class SetScroll < SetBase

    def initialize
      super
      @category = 'scroll'
    end

    def validate(t)
      Validators.timer(t)
    end

    def timer(t)
      @input = 'timer'
      @output = validate(t)
      Settings.options[:scroll][:timer] = @output
    end

    def date(value)
      @input = 'date'
      @output = Validators.boolean(value)
      Settings.options[:scroll][:date] = @output
    end

    def spinner(value)
      @input = 'spinner'
      @output = Validators.boolean(value)
      Settings.options[:scroll][:spinner] = @output
    end

  end

  class SetMovie < SetBase

    def initialize
      super
      @category = 'movie'
    end

    def hashtag(tag)
      @input = 'hashtag'
      @output = tag
      Settings.options[:movie][:hashtag] = @output
    end

  end

  class SetTVShow < SetBase

    def initialize
      super
      @category = 'tvshow'
    end

    def hashtag(tag)
      @input = 'hashtag'
      @output = tag
      Settings.options[:tvshow][:hashtag] = @output
    end

  end

  class SetNiceRank < SetBase

    def initialize
      super
      @category = 'nicerank'
    end

    def filter value
      @input = 'filter'
      @output = Validators.boolean(value)
      Settings.options[:nicerank][:filter] = @output
    end

    def active value
      filter(value)
    end

    def unranked value
      @input = 'unranked'
      @output = Validators.boolean(value)
      Settings.options[:nicerank][:unranked] = @output
    end

    def threshold value
      @input = 'threshold'
      @output = Validators.threshold(value)
      Settings.options[:nicerank][:threshold] = @output
    end

  end

  class SetBackup < SetBase

    def initialize
      super
      @category = 'backup'
    end

    def validate(value)
      Validators.boolean(value)
    end

    def method_missing(meth, options)
      @input = meth.to_s
      @output = validate(options)
      case @input
      when 'posts', 'messages', 'lists'
        Settings.options[:backup][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetMarker < SetBase

    def initialize
      super
      @category = 'marker'
    end

    def validate(value)
      Validators.boolean(value)
    end

    def method_missing(meth, options)
      @input = meth.to_s
      @output = validate(options)
      case @input
      when 'messages'
        Settings.options[:marker][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetChannels < SetBase

    def initialize
      super
      @category = 'channels'
    end

    def validate(value)
      Validators.boolean(value)
    end

    def method_missing(meth, options)
      @input = meth.to_s
      @output = validate(options)
      case @input
      when 'links'
        Settings.options[:channels][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetBlacklist < SetBase

    def initialize
      super
      @category = 'blacklist'
    end

    def validate(value)
      Validators.boolean(value)
    end

    def method_missing(meth, options)
      @input = meth.to_s
      @output = validate(options)
      case @input
      when 'active', 'activated'
        Settings.options[:blacklist][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetCounts < SetBase

    def initialize
      super
      @category = 'counts'
    end

    def validate(value)
      Validators.index_range(1, 200, value)
    end

    def method_missing(meth, options)
      @input = meth.to_s.capitalize
      @output = validate(options.to_i)
      case meth.to_s
      when 'default', 'unified', 'checkins', 'conversations', 'global', 'photos', 'trending', 'mentions', 'convo', 'posts', 'messages', 'search', 'whoreposted', 'whostarred', 'whatstarred', 'files'
        Settings.options[:counts][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetTimeline < SetBase

    def initialize
      super
      @category = 'timeline'
    end

    def validate(value)
      Validators.boolean(value)
    end

    def method_missing(meth, options)
      @input = meth.to_s
      @output = validate(options)
      case @input
      when 'directed', 'source', 'symbols', 'name', 'date', 'debug', 'compact'
        Settings.options[:timeline][meth.to_sym] = @output
      else
        super
      end
    end

  end

  class SetColor < SetBase

    def initialize
      super
      @category = 'colors'
    end

    def validate(color)
      Validators.color(color)
    end

    def method_missing(meth, options)
      @input = meth.to_s.capitalize
      @output = validate(options)
      case meth.to_s
      when 'id', 'index', 'username', 'name', 'date', 'link', 'dots', 'hashtags', 'mentions', 'source', 'symbols', 'unread', 'debug', 'excerpt'
        Settings.options[:colors][meth.to_sym] = @output
      when 'hashtag', 'mention', 'symbol'
        Settings.options[:colors]["#{meth}s".to_sym] = @output
      when 'client'
        Settings.options[:colors][:source] = @output
      else
        super
      end
    end

  end
end
