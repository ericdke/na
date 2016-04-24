# encoding: utf-8
module Ayadn

  class PreferencesFormatsList
    attr_accessor :reverse
    def initialize hash
      @reverse = hash[:reverse]
    end
    def to_h
      { reverse: @reverse }
    end
  end

  class PreferencesFormatsTable
    attr_accessor :width, :borders
    def initialize hash
      @width = hash[:width]
      @borders = hash[:borders]
    end
    def to_h
      {
        width: @width,
        borders: @borders
      }
    end
  end

  class PreferencesFormats
    attr_accessor :table, :list
    def initialize hash
      @table = PreferencesFormatsTable.new(hash[:table])
      @list = PreferencesFormatsList.new(hash[:list])
    end
    def to_h
      {
        table: @table.to_h,
        list: @list.to_h
      }
    end
  end

  class PreferencesCounts
    attr_accessor :default, :unified, :global, :checkins, :conversations, :photos, :trending, :mentions, :convo, :posts, :messages, :search, :whoreposted, :whostarred, :whatstarred, :files
    def initialize hash
      @default = hash[:default]
      @unified = hash[:unified]
      @global = hash[:global]
      @checkins = hash[:checkins]
      @conversations = hash[:conversations]
      @photos = hash[:photos]
      @trending = hash[:trending]
      @mentions = hash[:mentions]
      @convo = hash[:convo]
      @posts = hash[:posts]
      @messages = hash[:messages]
      @search = hash[:search]
      @whoreposted = hash[:whoreposted]
      @whostarred = hash[:whostarred]
      @whatstarred = hash[:whatstarred]
      @files = hash[:files]
    end
    def to_h
      {
        default: @default,
        unified: @unified,
        global: @global,
        checkins: @checkins,
        conversations: @conversations,
        photos: @photos,
        trending: @trending,
        mentions: @mentions,
        convo: @convo,
        posts: @posts,
        messages: @messages,
        search: @search,
        whoreposted: @whoreposted,
        whostarred: @whostarred,
        whatstarred: @whatstarred,
        files: @files
      }
    end
  end

  class PreferencesMarker
    attr_accessor :messages
    def initialize hash
      @messages = hash[:messages]
    end
    def to_h
      {messages: @messages}
    end
  end
  
  class PreferencesTimeline
    attr_accessor :directed, :source, :symbols, :name, :date, :debug, :compact
    def initialize hash
      @directed = hash[:directed]
      @source = hash[:source]
      @symbols = hash[:symbols]
      @name = hash[:name]
      @date = hash[:date]
      @debug = hash[:debug]
      @compact = hash[:compact]
    end
    def to_h
      {
        directed: @directed,
        source: @source,
        symbols: @symbols,
        name: @name,
        date: @date,
        debug: @debug,
        compact: @compact
      }
    end
  end

  class PreferencesChannels
    attr_accessor :links
    def initialize hash
      @links = hash[:links]
    end
    def to_h
      { links: @links }
    end
  end

  class PreferencesColors
    attr_accessor :id, :index, :username, :name, :date, :link, :dots, :hashtags, :mentions, :source, :symbols, :unread, :debug, :excerpt
    def initialize hash
      @id = hash[:id],
      @index = hash[:index],
      @username = hash[:username],
      @name = hash[:name],
      @date = hash[:date],
      @link = hash[:link],
      @dots = hash[:dots],
      @hashtags = hash[:hashtags],
      @mentions = hash[:mentions],
      @source = hash[:source],
      @symbols = hash[:symbols],
      @unread = hash[:unread],
      @debug = hash[:debug],
      @excerpt = hash[:excerpt]
    end
    def to_h
      {
        id: @id,
        index: @index,
        username: @username,
        name: @name,
        date: @date,
        link: @link,
        dots: @dots,
        hashtags: @hashtags,
        mentions: @mentions,
        source: @source,
        symbols: @symbols,
        unread: @unread,
        debug: @debug,
        excerpt: @excerpt       
      }
    end
  end

  class PreferencesBackup
    attr_accessor :posts, :messages, :lists
    def initialize hash
      @posts = hash[:posts]
      @messages = hash[:messages]
      @lists = hash[:lists]
    end
    def to_h
      {
        posts: @posts,
        messages: @messages,
        lists: @lists
      }
    end
  end

  class PreferencesScroll
    attr_accessor :spinner, :timer, :date
    def initialize hash
      @spinner = hash[:spinner]
      @timer = hash[:timer]
      @date = hash[:date]
    end
    def to_h
      {
        spinner: @spinner,
        timer: @timer,
        date: @date
      }
    end
  end

  class PreferencesNicerank
    attr_accessor :threshold, :filter, :unranked
    def initialize hash
      @threshold = hash[:threshold]
      @filter = hash[:filter]
      @unranked = hash[:unranked]
    end
    def to_h
      {
        threshold: @threshold,
        filter: @filter,
        unranked: @unranked
      }
    end
  end

  class PreferencesBlacklist
    attr_accessor :active
    def initialize hash
      @active = hash[:active]
    end
    def to_h
      { active: @active }
    end
  end

  class Preferences
    attr_accessor :source_hash, :timeline, :marker, :counts, :formats, :channels, :colors, :backup, :scroll, :nicerank, :nowplaying, :blacklist

    def initialize hash
      @source_hash = hash
      @timeline = PreferencesTimeline.new(hash[:timeline])
      @marker = PreferencesMarker.new(hash[:marker])
      @counts = PreferencesCounts.new(hash[:counts])
      @formats = PreferencesFormats.new(hash[:formats])
      @channels = PreferencesChannels.new(hash[:channels])
      @colors = PreferencesColors.new(hash[:colors])
      @backup = PreferencesBackup.new(hash[:backup])
      @scroll = PreferencesScroll.new(hash[:scroll])
      @nicerank = PreferencesNicerank.new(hash[:nicerank])
      @nowplaying = {}
      @blacklist = PreferencesBlacklist.new(hash[:blacklist])
    end
    def to_h
      {
        timeline: @timeline.to_h,
        marker: @marker.to_h,
        counts: @counts.to_h,
        formats: @formats.to_h,
        channels: @channels.to_h,
        colors: @colors.to_h,
        backup: @backup.to_h,
        scroll: @scroll.to_h,
        nicerank: @nicerank.to_h,
        blacklist: @blacklist.to_h
      }
    end
  end
end