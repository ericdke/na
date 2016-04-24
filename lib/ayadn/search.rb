# encoding: utf-8
module Ayadn

  class Search

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
      @check = Check.new
    end

    def hashtag(hashtag, options)
      Settings.global[:force] = true if options[:force]
      @view.downloading(options)
      stream = @api.get_hashtag(hashtag)
      @check.no_data(stream, 'hashtag')
      if options[:extract]
        @view.all_hashtag_links(stream, hashtag)
      else
        @view.render(stream, options)
        if Settings.options[:timeline][:compact] == true && !options[:raw]
          puts "\n" 
        end
      end
    end

    def find(words, options)
      Settings.global[:force] = true if options[:force]
      @view.downloading(options)
      stream = get_stream(words, options)
      if options[:users]
        stream_object = stream["data"].map { |user| UserObject.new(user) }
      elsif !options[:channels]
        stream_object = StreamObject.new(stream)
      end
      if options[:users]
        get_users(stream_object, options)
      elsif options[:channels]
        get_channels(stream, options)
      else
        get_generic(stream_object, words, options)
      end
      if Settings.options[:timeline][:compact] == true && !options[:raw]
        puts "\n" 
      end
    end

    private

    def get_stream words, options
      if options[:users]
        @api.search_users words, options
      elsif options[:annotations]
        @api.search_annotations words, options
      elsif options[:channels]
        @api.search_channels words, options
      elsif options[:messages]
        words = words.split(',')
        channel_id = @workers.get_channel_id_from_alias(words[0])
        words.shift
        @api.search_messages channel_id, words.join(','), options
      else
        @api.get_search words, options
      end
    end

    def get_generic stream, words, options
      if options[:extract]
        @view.all_search_links(stream, words)
      else
        @view.render(stream, options)
      end
    end

    def get_channels stream, options
      stream_object = stream["data"].map { |ch| ChannelObject.new(ch) }
      @view.show_channels(stream_object, options)
    end

    def get_users stream, options
      sorted = stream.sort_by {|obj| obj.counts.followers}
      sorted.each do |obj|
        puts @view.big_separator unless Settings.options[:timeline][:compact] == true
        @view.show_userinfos(obj, nil, false)
      end
      puts "\n" if Settings.options[:timeline][:compact] == true
    end

  end

end
