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
      timeline_config.save
    end

    desc "count ITEM NUMBER", "Set ITEM to retrieve NUMBER of elements by default"
    map "counts" => :count
    def count(*args)
      puts args
    end

    desc "format ITEM NUMBER", "Set ITEM parameter to NUMBER by default"
    map "formats" => :format
    def format(*args)
      puts args
    end

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
      color_config.save
    end

    desc "backup ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    def backup(*args)
      puts args
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
    def save
      MyConfig.save_config
    end
    def directed(value)
      MyConfig.options[:timeline][:directed] = value
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
