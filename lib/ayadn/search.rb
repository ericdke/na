# encoding: utf-8
module Ayadn

  class Search

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
    end

    def hashtag(hashtag, options)
      Settings.options[:force] = true if options[:force]
      @view.downloading(options)
      stream = @api.get_hashtag(hashtag)
      Check.no_data(stream, 'hashtag')
      if options[:extract]
        @view.all_hashtag_links(stream, hashtag)
      else
        @view.render(stream, options)
      end
    end

    def find(words, options)
      Settings.options[:force] = true if options[:force]
      @view.downloading(options)
      stream = get_stream(words, options)
      Check.no_data(stream, 'search')
      if options[:users]
        get_users(stream, options)
      elsif options[:channels]
        get_channels(stream, options)
      else
        get_generic(stream, words, options)
      end
    end

    private

    def get_generic stream, words, options
      if options[:extract]
        @view.all_search_links(stream, words)
      else
        @view.render(stream, options)
      end
    end

    def get_channels stream, options
      @view.show_channels(stream, options)
    end

    def get_users stream, options
      sorted = stream['data'].sort_by {|obj| obj['counts']['followers']}
      sorted.each do |obj|
        puts @view.big_separator
        @view.show_userinfos(obj, nil, false)
      end
    end

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

  end

end
