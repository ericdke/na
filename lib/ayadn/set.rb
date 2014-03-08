module Ayadn

  class Set < Thor

    desc "timeline ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    long_desc Descriptions.set_timeline
    def timeline(*args)
      timeline_config = SetTimeline.new
      if args[0]
        param = timeline_config.validate(args[1])
        timeline_config.send(args[0], param)
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
        param = counts_config.validate(args[1])
        counts_config.send(args[0], param)
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

    desc "color ITEM COLOR", "Set ITEM to COLOR"
    long_desc Descriptions.set_color
    map "colors" => :color
    def color(*args)
      color_config = SetColor.new
      if args[0]
        color_config.validate(args[1])
        color_config.send(args[0], args[1])
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
        param = backup_config.validate(args[1])
        backup_config.send(args[0], param)
      else
        abort(Status.error_missing_parameters)
      end
      backup_config.log(args)
      backup_config.save
    end
  end

  class SetBackup
    def initialize
      MyConfig.load_config
      Logs.create_logger
    end
    def log(args)
      Logs.rec.info "New value for '#{args[0]}' in 'Backup' => #{args[1]}"
    end
    def save
      MyConfig.save_config
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
      MyConfig.options[:backup][:auto_save_sent_posts] = value
    end
    def auto_save_sent_messages(value)
      MyConfig.options[:backup][:auto_save_sent_messages] = value
    end
    def auto_save_lists(value)
      MyConfig.options[:backup][:auto_save_lists] = value
    end
  end

  class SetCounts
    def initialize
      MyConfig.load_config
      Logs.create_logger
    end
    def log(args)
      Logs.rec.info "New value for '#{args[0]}' in 'Counts' => #{args[1]}"
    end
    def save
      MyConfig.save_config
    end
    def validate(value)
      if value.is_integer?
        if value >= 1 && value <= 200
          value
        else
          abort(Status.must_be_integer)
        end
      else
        puts Status.error_missing_parameters
        abort(Status.must_be_integer)
      end
    end
    def default(value)
      MyConfig.options[:counts][:default] = value
    end
    def unified(value)
      MyConfig.options[:counts][:unified] = value
    end
    def global(value)
      MyConfig.options[:counts][:global] = value
    end
    def checkins(value)
      MyConfig.options[:counts][:checkins] = value
    end
    def conversations(value)
      MyConfig.options[:counts][:conversations] = value
    end
    def photos(value)
      MyConfig.options[:counts][:photos] = value
    end
    def trending(value)
      MyConfig.options[:counts][:trending] = value
    end
    def mentions(value)
      MyConfig.options[:counts][:mentions] = value
    end
    def convo(value)
      MyConfig.options[:counts][:convo] = value
    end
    def posts(value)
      MyConfig.options[:counts][:posts] = value
    end
    def messages(value)
      MyConfig.options[:counts][:messages] = value
    end
    def search(value)
      MyConfig.options[:counts][:search] = value
    end
    def whoreposted(value)
      MyConfig.options[:counts][:whoreposted] = value
    end
    def whostarred(value)
      MyConfig.options[:counts][:whostarred] = value
    end
    def whatstarred(value)
      MyConfig.options[:counts][:whatstarred] = value
    end
    def files(value)
      MyConfig.options[:counts][:files] = value
    end
  end

  class SetTimeline
    def initialize
      MyConfig.load_config
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
      Logs.rec.info "New value for '#{args[0]}' in 'Timeline' => #{args[1]}"
    end
    def save
      MyConfig.save_config
    end
    def directed(value)
      MyConfig.options[:timeline][:directed] = value
    end
    def deleted(value)
      #MyConfig.options[:timeline][:deleted] = value
      abort(Status.not_mutable)
    end
    def html(value)
      MyConfig.options[:timeline][:html] = value
    end
    def annotations(value)
      #MyConfig.options[:timeline][:annotations] = value
      abort(Status.not_mutable)
    end
    def show_source(value)
      MyConfig.options[:timeline][:show_source] = value
    end
    def show_symbols(value)
      MyConfig.options[:timeline][:show_symbols] = value
    end
    def show_real_name(value)
      MyConfig.options[:timeline][:show_real_name] = value
    end
    def show_date(value)
      MyConfig.options[:timeline][:show_date] = value
    end
  end

  class SetColor
    def initialize
      MyConfig.load_config
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
      Logs.rec.info "New value for '#{args[0]}' in 'Colors' => #{args[1]}"
    end

    def save
      MyConfig.save_config
    end

    def id(color)
      MyConfig.options[:colors][:id] = color
    end

    def index(color)
      MyConfig.options[:colors][:index] = color
    end

    def username(color)
      MyConfig.options[:colors][:username] = color
    end

    def name(color)
      MyConfig.options[:colors][:name] = color
    end

    def date(color)
      MyConfig.options[:colors][:date] = color
    end

    def link(color)
      MyConfig.options[:colors][:link] = color
    end

    def dots(color)
      MyConfig.options[:colors][:dots] = color
    end

    def hashtags(color)
      MyConfig.options[:colors][:hashtags] = color
    end

    def mentions(color)
      MyConfig.options[:colors][:mentions] = color
    end

    def source(color)
      MyConfig.options[:colors][:source] = color
    end

    def symbols(color)
      MyConfig.options[:colors][:symbols] = color
    end
  end
end
