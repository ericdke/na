# encoding: utf-8
module Ayadn
  class Scroll

    def initialize(api, view)
      @api = api
      @view = view
      @view.hide_cursor
      @chars = %w{ | / - \\ }
      at_exit { @view.show_cursor }
    end

    def method_missing(meth, options)
      case meth.to_s
      when 'trending', 'photos', 'checkins', 'replies', 'global', 'unified'
        scroll_it(meth.to_s, options)
      else
        super
      end
    end

    def scroll_it(target, options)
      options = check_raw(options)
      orig_target = target
      @nr = NiceRank.new
      loop do
        begin
          stream = get(target, options)
          stream['data'].empty? ? niceranks = {} : niceranks = @nr.get_ranks(stream)
          Debug.stream stream, options, target
          target = "explore:#{target}" if explore?(target) # explore but not global
          show_if_new(stream, options, target, niceranks)
          target = orig_target if target =~ /explore/
          options = save_then_return(stream, options, target)
          countdown
        rescue Interrupt
          canceled
        end
      end
    end

    def mentions(username, options)
      options = check_raw(options)
      id = @api.get_user(username)['data']['id']
      loop do
        begin
          stream = @api.get_mentions(username, options)
          Debug.stream stream, options, username
          show_if_new(stream, options, "mentions:#{id}")
          options = save_then_return(stream, options, "mentions:#{id}")
          countdown
        rescue Interrupt
          canceled
        end
      end
    end

    def posts(username, options)
      options = check_raw(options)
      id = @api.get_user(username)['data']['id']
      loop do
        begin
          stream = @api.get_posts(username, options)
          Debug.stream stream, options, username
          show_if_new(stream, options, "posts:#{id}")
          options = save_then_return(stream, options, "posts:#{id}")
          countdown
        rescue Interrupt
          canceled
        end
      end
    end

    def convo(post_id, options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_convo(post_id, options)
          Debug.stream stream, options, post_id
          show_if_new(stream, options, "replies:#{post_id}")
          options = save_then_return(stream, options, "replies:#{post_id}")
          countdown
        rescue Interrupt
          canceled
        end
      end
    end

    def messages(channel_id, options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_messages(channel_id, options)
          Debug.stream stream, options, channel_id
          show_if_new(stream, options, "channel:#{channel_id}")
          if Settings.options[:marker][:update_messages] == true
            unless resp['meta']['max_id'].nil?
              marked = @api.update_marker("channel:#{channel_id}", stream['meta']['max_id'])
              updated = JSON.parse(marked)
              if updated['meta']['code'] != 200
                Errors.warn "couldn't update channel #{channel_id} as read"
              end
            end
          end
          options = save_then_return(stream, options, "channel:#{channel_id}")
          countdown
        rescue Interrupt
          canceled
        end
      end
    end

    private

    def countdown
      Settings.options[:timeline][:spinner] == true ? waiting : pause
    end

    def clear
      print("\r")
      print(" ".ljust(5))
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
      (Settings.options[:scroll][:timer] * 10).times { spin }
    end

    def pause
      sleep Settings.options[:scroll][:timer]
    end

    def show_if_new(stream, options, target, niceranks = {})
      show(stream, options, niceranks) if Databases.has_new?(stream, target)
    end

    def save_then_return(stream, options, name = 'unknown')
      unless stream['meta']['max_id'].nil?
        Databases.save_max_id(stream, name)
        return options_hash(stream, options)
      end
      options
    end

    def check_raw(options)
      if options[:raw]
        if options[:filter] == true
          {count: 200, since_id: nil, raw: true, scroll: true, filter: true}
        else
          {count: 200, since_id: nil, raw: true, scroll: true}
        end
      else
        if options[:filter] == true
          {count: 200, since_id: nil, scroll: true, filter: true}
        else
          {count: 200, since_id: nil, scroll: true}
        end
      end
    end

    def options_hash(stream, options)
      if options[:filter] == true
        {:count => 50, :since_id => stream['meta']['max_id'], scroll: true, filter: true}
      else
        {:count => 50, :since_id => stream['meta']['max_id'], scroll: true}
      end
    end

    def show(stream, options, niceranks)
      if options[:raw]
        jj stream
      else
        @view.show_posts(stream['data'], options, niceranks)
      end
    end

    def canceled
      Status.new.canceled
      exit
    end
  end
end
