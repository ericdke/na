module Ayadn

  class Set < Thor

    desc "scroll ITEM VALUE", "Set the waiting time (in seconds, min 0.7) between two requests when scrolling"
    def scroll(*args)
      scroll_config = SetScroll.new
      if args[0]
        scroll_config.send(args[0], args[1])
      else
        abort(Status.error_missing_parameters)
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
        abort(Status.error_missing_parameters)
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
        abort(Status.error_missing_parameters)
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
        abort(Status.error_missing_parameters)
      end
      marker_config.save
    end

    desc "blacklist ITEM TRUE/FALSE", "Set values for the blacklist"
    def blacklist(*args)
      blacklist_config = SetBlacklist.new
      unless args.length != 2
        blacklist_config.send(args[0], args[1])
      else
        abort(Status.error_missing_parameters)
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
        abort(Status.error_missing_parameters)
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
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
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
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
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
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
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
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      backup_config.save
    end

    desc "defaults", "Sets back the configuration to defaults values"
    long_desc Descriptions.set_defaults
    def defaults
      Settings.restore_defaults
      puts Status.done
    end

    desc "formats ITEM VALUE", "Set values for formatting fields"
    def formats(*args)
      formats_config = SetFormats.new
      if args[0]
        begin
          command = args.shift
          formats_config.send(command, args)
        rescue NoMethodError, ArgumentError
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      formats_config.save
    end

  end

  class Validators

    def self.boolean(value)
      case value.downcase
      when "true", "1", "yes"
        true
      when "false", "0", "no"
        false
      else
        abort(Status.error_missing_parameters)
      end
    end

    def self.index_range(min, max, value)
      x = value.to_i
      if x >= min && x <= max
        x
      else
        abort(Status.must_be_integer)
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
        abort(Status.threshold)
      end
    end

    def self.timer(t)
      t = t.to_f.round
      t >= 1 ? t : 3
    end

    def self.color(color)
      colors_list = %w{red green magenta cyan yellow blue white black}
      unless colors_list.include?(color.to_s)
        puts Status.error_missing_parameters
        abort(Status.valid_colors(colors_list))
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
    end

    def save
      Settings.save_config()
      log()
    end

    def log
      x = "New value for '#{@input}' in '#{@category}' => #{@output}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end

  end

  class SetFormats < SetBase

    def initialize
      super
      @category = 'formats'
    end

    def table(args)
      type = args.shift.downcase
      value = args[0].to_i
      if type == 'width'
        @input = 'table width'
        @output = Validators.width_range(value)
        Settings.options[:formats][:table][:width] = @output
      else
        abort(Status.error_missing_parameters)
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
        abort(Status.error_missing_parameters)
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

    def filter_unranked value
      @input = 'filter_unranked'
      @output = Validators.boolean(value)
      Settings.options[:nicerank][:filter_unranked] = @output
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
      when 'auto_save_sent_posts', 'auto_save_sent_messages', 'auto_save_lists'
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
      when 'update_messages'
        Settings.options[:marker][meth.to_sym] = @output
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
      when 'directed', 'html', 'source', 'symbols', 'real_name', 'date', 'spinner', 'debug', 'compact', 'channel_oembed'
        Settings.options[:timeline][meth.to_sym] = @output
      when 'deleted', 'annotations'
        abort(Status.not_mutable)
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
      when 'id', 'index', 'username', 'name', 'date', 'link', 'dots', 'hashtags', 'mentions', 'source', 'symbols', 'unread', 'debug'
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
