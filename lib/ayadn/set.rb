module Ayadn

  class Set < Thor

    desc "timeline ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    def timeline(*args)
      puts args
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
    map "colors" => :color
    def color(*args)
      cf = Ayadn::Color.new
      param = args[1]
      case args[0]
      when "id"
        cf.id(param)
      else
        puts "You have to submit valid items and values. See 'ayadn -sg' for a list of valid parameters and values."
      end
    end

    desc "backup ITEM TRUE/FALSE", "Set ITEM to be activated or not"
    def backup(*args)
      puts args
    end

  end

  class Color

    def id(color)
      puts color
    end
  end

end
