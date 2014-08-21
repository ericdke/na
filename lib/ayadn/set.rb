module Ayadn

  class Set < Thor

    desc "scroll ITEM VALUE", "Set the waiting time (in seconds, min 0.7) between two requests when scrolling"
    def scroll(*args)
      scroll_config = SetScroll.new
      if args[0]
        param = scroll_config.validate(args[1])
        scroll_config.send(args[0], param)
      else
        abort(Status.error_missing_parameters)
      end
      scroll_config.log(args)
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
      movie_config.log(args)
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
      tvshow_config.log(args)
      tvshow_config.save
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
      nicerank_config.log(args)
      nicerank_config.save
    end

    desc "timeline ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    long_desc Descriptions.set_timeline
    def timeline(*args)
      timeline_config = SetTimeline.new
      if args[0]
        begin
          param = timeline_config.validate(args[1])
          timeline_config.send(args[0], param)
        rescue NoMethodError
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      timeline_config.log(args)
      timeline_config.save
    end

    desc "count ITEM NUMBER", "Set ITEM to retrieve NUMBER of elements by default"
    long_desc Descriptions.set_counts
    map "counts" => :count
    def count(*args)
      counts_config = SetCounts.new
      if args[0]
        begin
          param = counts_config.validate(args[1])
          counts_config.send(args[0], param)
        rescue NoMethodError
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      counts_config.log(args)
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
          color_config.validate(args[1])
          color_config.send(args[0], args[1])
        rescue NoMethodError
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      color_config.log(args)
      color_config.save
    end

    desc "backup ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    long_desc Descriptions.set_backup
    def backup(*args)
      backup_config = SetBackup.new
      if args[0]
        begin
          param = backup_config.validate(args[1])
          backup_config.send(args[0], param)
        rescue NoMethodError
          puts Status.error_missing_parameters
          exit
        rescue => e
          raise e
        end
      else
        abort(Status.error_missing_parameters)
      end
      backup_config.log(args)
      backup_config.save
    end

    desc "defaults", "Sets back the configuration to defaults values"
    long_desc Descriptions.set_defaults
    def defaults
      Settings.restore_defaults
      puts Status.done
    end

  end

  class SetScroll
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'Scroll' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def validate(t)
      Validators.timer(t)
    end
    def timer(t)
      Settings.options[:scroll][:timer] = t
    end
  end

  class SetMovie
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'Movie' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def hashtag(tag)
      Settings.options[:movie][:hashtag] = tag
    end
  end

  class SetTVShow
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'TV Show' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def hashtag(tag)
      Settings.options[:tvshow][:hashtag] = tag
    end
  end

  class SetNiceRank
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'NiceRank' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def filter value
      Settings.options[:nicerank][:filter] = Validators.boolean(value)
    end
    def filter_unranked value
      Settings.options[:nicerank][:filter_unranked] = Validators.boolean(value)
    end
    def threshold value
      Settings.options[:nicerank][:threshold] = Validators.threshold value
    end
    def cache value
      Settings.options[:nicerank][:cache] = Validators.cache_range value.to_i
    end
  end

  class SetBackup
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'Backup' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def validate(value)
      Validators.boolean(value)
    end
    def auto_save_sent_posts(value)
      Settings.options[:backup][:auto_save_sent_posts] = value
    end
    def auto_save_sent_messages(value)
      Settings.options[:backup][:auto_save_sent_messages] = value
    end
    def auto_save_lists(value)
      Settings.options[:backup][:auto_save_lists] = value
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
    def self.cache_range value
      if value >= 1 && value <= 168
        value.round
      else
        abort(Status.cache_range)
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
      t = t.to_i
      t >= 1 ? t : 3
    end
    def self.color(color)
      colors_list = %w{red green magenta cyan yellow blue white black}
      unless colors_list.include?(color)
        puts Status.error_missing_parameters
        abort(Status.valid_colors(colors_list))
      end
    end
  end

  class SetCounts
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'Counts' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def validate(value)
      Validators.index_range(1, 200, value)
    end
    def default(value)
      Settings.options[:counts][:default] = value
    end
    def unified(value)
      Settings.options[:counts][:unified] = value
    end
    def global(value)
      Settings.options[:counts][:global] = value
    end
    def checkins(value)
      Settings.options[:counts][:checkins] = value
    end
    def conversations(value)
      Settings.options[:counts][:conversations] = value
    end
    def photos(value)
      Settings.options[:counts][:photos] = value
    end
    def trending(value)
      Settings.options[:counts][:trending] = value
    end
    def mentions(value)
      Settings.options[:counts][:mentions] = value
    end
    def convo(value)
      Settings.options[:counts][:convo] = value
    end
    def posts(value)
      Settings.options[:counts][:posts] = value
    end
    def messages(value)
      Settings.options[:counts][:messages] = value
    end
    def search(value)
      Settings.options[:counts][:search] = value
    end
    def whoreposted(value)
      Settings.options[:counts][:whoreposted] = value
    end
    def whostarred(value)
      Settings.options[:counts][:whostarred] = value
    end
    def whatstarred(value)
      Settings.options[:counts][:whatstarred] = value
    end
    def files(value)
      Settings.options[:counts][:files] = value
    end
  end

  class SetTimeline
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end
    def validate(value)
      Validators.boolean(value)
    end
    def log(args)
      x = "New value for '#{args[0]}' in 'Timeline' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end
    def save
      Settings.save_config
    end
    def directed(value)
      Settings.options[:timeline][:directed] = value
    end
    def deleted(value)
      #Settings.options[:timeline][:deleted] = value
      abort(Status.not_mutable)
    end
    def html(value)
      Settings.options[:timeline][:html] = value
    end
    def annotations(value)
      #Settings.options[:timeline][:annotations] = value
      abort(Status.not_mutable)
    end
    def show_source(value)
      Settings.options[:timeline][:show_source] = value
    end
    def show_symbols(value)
      Settings.options[:timeline][:show_symbols] = value
    end
    def show_real_name(value)
      Settings.options[:timeline][:show_real_name] = value
    end
    def show_date(value)
      Settings.options[:timeline][:show_date] = value
    end
    def show_spinner value
      Settings.options[:timeline][:show_spinner] = value
    end
    def show_debug value
      Settings.options[:timeline][:show_debug] = value
    end
  end

  class SetColor
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end

    def validate(color)
      Validators.color(color)
    end

    def log(args)
      x = "New value for '#{args[0]}' in 'Colors' => #{args[1]}"
      puts "\n#{x}\n".color(:cyan)
      Logs.rec.info x
    end

    def save
      Settings.save_config
    end

    def id(color)
      Settings.options[:colors][:id] = color.to_sym
    end

    def index(color)
      Settings.options[:colors][:index] = color.to_sym
    end

    def username(color)
      Settings.options[:colors][:username] = color.to_sym
    end

    def name(color)
      Settings.options[:colors][:name] = color.to_sym
    end

    def date(color)
      Settings.options[:colors][:date] = color.to_sym
    end

    def link(color)
      Settings.options[:colors][:link] = color.to_sym
    end

    def dots(color)
      Settings.options[:colors][:dots] = color.to_sym
    end

    def hashtags(color)
      Settings.options[:colors][:hashtags] = color.to_sym
    end

    def hashtag color
      hashtags color
    end

    def mentions(color)
      Settings.options[:colors][:mentions] = color.to_sym
    end

    def mention color
      mentions color
    end

    def source(color)
      Settings.options[:colors][:source] = color.to_sym
    end

    def client color
      source color
    end

    def symbols(color)
      Settings.options[:colors][:symbols] = color.to_sym
    end

    def symbol(color)
      symbols color
    end

    def debug(color)
      Settings.options[:colors][:debug] = color.to_sym
    end
  end
end
