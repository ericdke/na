# encoding: utf-8
module Ayadn
  class Scroll

    def initialize(api, view)
      @api = api
      @view = view
    end

    def global(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_global(options)
          show_if_new(stream, options, 'global')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def unified(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_unified(options)
          show_if_new(stream, options, 'unified')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def mentions(username, options)
      options = check_raw(options)
      user = @api.get_user(username)
      id = user['data']['id']
      loop do
        begin
          stream = @api.get_mentions(username, options)
          show_if_new(stream, options, "mentions:#{id}")
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def posts(username, options)
      options = check_raw(options)
      user = @api.get_user(username)
      id = user['data']['id']
      loop do
        begin
          stream = @api.get_posts(username, options)
          show_if_new(stream, options, "posts:#{id}")
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def convo(post_id, options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_convo(post_id, options)
          show_if_new(stream, options, "replies:#{post_id}")
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def conversations(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_conversations(options)
          show_if_new(stream, options, 'explore:replies')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def trending(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_trending(options)
          show_if_new(stream, options, 'explore:trending')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def checkins(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_checkins(options)
          show_if_new(stream, options, 'explore:checkins')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def photos(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_photos(options)
          show_if_new(stream, options, 'explore:photos')
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def messages(channel_id, options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_messages(channel_id, options)
          show_if_new(stream, options, "channel:#{channel_id}")
          options = save_then_return(stream, options)
          pause
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    private

    def pause
      sleep Settings.options[:scroll][:timer]
    end

    def show_if_new(stream, options, target)
      show(stream, options) if Databases.has_new?(stream, target)
    end

    def save_then_return(stream, options)
      unless stream['meta']['max_id'].nil?
        Databases.save_max_id(stream)
        return options_hash(stream)
      end
      options
    end

    def check_raw(options)
      if options[:raw]
        {count: 200, since_id: nil, raw: true, scroll: true}
      else
        {count: 200, since_id: nil, scroll: true}
      end
    end

    def options_hash(stream)
      {:count => 50, :since_id => stream['meta']['max_id'], scroll: true}
    end

    def show(stream, options)
      unless options[:raw]
        @view.show_posts(stream['data'], options)
      else
        jj stream
      end
    end

    def canceled
      puts Status.canceled
      exit
    end
  end
end
