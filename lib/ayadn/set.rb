module Ayadn

  class Set < Thor

    desc "set timeline ITEM TRUE/FALSE", "Set ITEM to be activated or not"
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

    desc "set count ITEM NUMBER", "Set ITEM to retrieve NUMBER of elements by default"
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

    # desc "format ITEM NUMBER", "Set ITEM parameter to NUMBER by default"
    # map "formats" => :format
    # def format(*args)
    #   puts args
    # end

    desc "set color ITEM COLOR", "Set ITEM to COLOR"
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

    desc "set backup ITEM TRUE/FALSE", "Set ITEM to be activated or not"
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
      case value
      when "TRUE", "true", "1", "yes"
        true
      when "FALSE", "false", "0", "no"
        false
      end
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
      if value.is_integer?
        x = value
      else
        x = value.to_i
      end
      if x >= 1 && x <= 200
        x
      else
        abort(Status.must_be_integer)
      end
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
      case value
      when "TRUE", "true", "1", "yes"
        1
      when "FALSE", "false", "0", "no"
        0
      end
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
  end

  class SetColor
    def initialize
      Settings.load_config
      Settings.get_token
      Settings.init_config
      Logs.create_logger
    end

    def validate(color)
      colors_list = %w{red green magenta cyan yellow blue white}
      unless colors_list.include?(color)
        puts Status.error_missing_parameters
        abort(Status.valid_colors(colors_list))
      end
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

    def mentions(color)
      Settings.options[:colors][:mentions] = color.to_sym
    end

    def source(color)
      Settings.options[:colors][:source] = color.to_sym
    end

    def symbols(color)
      Settings.options[:colors][:symbols] = color.to_sym
    end
  end
end
