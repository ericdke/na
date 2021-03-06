# encoding: utf-8
module Ayadn
  class Scroll

    def initialize(api, view)
      @api = api
      @view = view
      @view.hide_cursor
      @chars = %w{ - \\ | / }
      at_exit { @view.show_cursor }
    end

    def method_missing(meth, *args)
      options = if args.size > 1
        args[1]
      else
        args[0]
      end
      case meth
      when :trending, :photos, :checkins, :replies, :global, :unified
        scroll_explore_stream(meth.to_s, options)
      when :mentions, :posts
        scroll_user_stream(args[0], meth.to_s, options)
      else
        super
      end
    end

    def scroll_explore_stream target, options
      Settings.global.scrolling = true
      options = check_raw(options)
      orig_target = target
      @nr = NiceRank.new
      loop do
        begin
          stream_object = StreamObject.new(get(target, options))
          stream_object.posts.empty? ? niceranks = {} : niceranks = @nr.get_ranks(stream_object)
          Debug.stream stream_object, options, target          
          target = "explore:#{target}" if explore?(target) # explore but not global
          clear() if Settings.options.scroll.spinner
          show_if_new(stream_object, options, target, niceranks)          
          target = orig_target if target =~ /explore/
          options = save_then_return(stream_object, options, target)
          countdown
          print "..." if Settings.options.scroll.spinner
        rescue Interrupt
          canceled
        end
      end
    end

    def scroll_user_stream username, type, options
      Settings.global.scrolling = true
      options = check_raw(options)
      id = @api.get_user(username)['data']['id'] 
      loop do
        begin
          stream = @api.send("get_#{type}".to_sym, username, options)
          stream_object = StreamObject.new(stream)
          Debug.stream stream_object, options, username
          clear() if Settings.options.scroll.spinner
          show_if_new(stream_object, options, "#{type}:#{id}")
          options = save_then_return(stream_object, options, "#{type}:#{id}")
          countdown
          print "..." if Settings.options.scroll.spinner
        rescue Interrupt
          canceled
        end
      end
    end

    def convo(post_id, options)
      Settings.global.scrolling = true
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_convo(post_id, options)
          stream_object = StreamObject.new(stream)
          Debug.stream stream_object, options, post_id
          clear() if Settings.options.scroll.spinner
          show_if_new(stream_object, options, "replies:#{post_id}")
          options = save_then_return(stream_object, options, "replies:#{post_id}")
          countdown
          print "..." if Settings.options.scroll.spinner
        rescue Interrupt
          canceled
        end
      end
    end

    def messages(channel_id, options)
      Settings.global.scrolling = true
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_messages(channel_id, options)
          stream_object = StreamObject.new(stream)
          Debug.stream stream_object, options, channel_id
          clear() if Settings.options.scroll.spinner
          show_if_new(stream_object, options, "channel:#{channel_id}")
          if Settings.options.marker.messages
            unless stream_object.meta.max_id.nil?
              marked = @api.update_marker("channel:#{channel_id}", stream_object.meta.max_id)
              updated = JSON.parse(marked)
              if updated['meta']['code'] != 200
                Errors.warn "couldn't update channel #{channel_id} as read"
              end
            end
          end
          options = save_then_return(stream_object, options, "channel:#{channel_id}")
          countdown
          print "..." if Settings.options.scroll.spinner
        rescue Interrupt
          canceled
        end
      end
    end

    private

    def countdown
      Settings.options.scroll.spinner ? waiting : pause
    end

    def clear
      print("\r")
      print(" ".ljust(40))
      print("\r")
    end

    def spin
      print(@chars[0])          # Print the next character...
      sleep(0.1)                # ...wait 100ms...
      print("\b")               # ...move the cursor back by one...
      @chars.push(@chars.shift) # ...rotate the characters array.
    end

    def get(target, options)
      case target
      when 'global'
        @api.get_global(options)
      when 'unified'
        @api.get_unified(options)
      when 'trending'
        @api.get_trending(options)
      when 'photos'
        @api.get_photos(options)
      when 'checkins'
        @api.get_checkins(options)
      when 'replies'
        @api.get_conversations(options)
      end
    end

    def explore?(target)
      case target
      when 'trending', 'photos', 'checkins', 'replies'
        true
      else
        false
      end
    end

    def waiting
      (Settings.options.scroll.timer * 10).times { spin }
    end

    def pause
      sleep Settings.options.scroll.timer
    end

    def show_if_new(stream, options, target, niceranks = {})
      show(stream, options, niceranks) if Databases.has_new?(stream, target)
    end

    def save_then_return(stream, options, name = 'unknown')
      unless stream.meta.max_id.nil?
        Databases.save_max_id(stream, name)
        return options_hash(stream, options)
      end
      options
    end

    def check_raw(options)
      if options[:raw]
        if options[:filter]
          {count: 200, since_id: nil, raw: true, scroll: true, filter: true}
        else
          {count: 200, since_id: nil, raw: true, scroll: true}
        end
      else
        if options[:filter]
          {count: 200, since_id: nil, scroll: true, filter: true}
        else
          {count: 200, since_id: nil, scroll: true}
        end
      end
    end

    def options_hash(stream, options)
      if options[:filter]
        {:count => 50, :since_id => stream.meta.max_id, scroll: true, filter: true}
      else
        {:count => 50, :since_id => stream.meta.max_id, scroll: true}
      end
    end

    def show(stream, options, niceranks)
      if options[:raw]
        jj stream.input
      else
        @view.show_posts(stream, options, niceranks)
      end
    end

    def canceled
      Status.new.canceled
      exit
    end
  end
end
