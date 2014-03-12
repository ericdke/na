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
          if Databases.has_new?(stream, 'global')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
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
          if Databases.has_new?(stream, 'unified')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
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
          if Databases.has_new?(stream, 'explore:replies')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
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
          if Databases.has_new?(stream, 'explore:trending')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
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
          if Databases.has_new?(stream, 'explore:checkins')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
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
          if Databases.has_new?(stream, 'explore:photos')
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    def messages(options)
      options = check_raw(options)
      loop do
        begin
          stream = @api.get_messages(channel_id, options)
          if Databases.has_new?(stream, "channel:#{channel_id}")
            show(stream, options)
          end
          unless stream['meta']['max_id'].nil?
            Databases.save_max_id(stream)
            options = options_hash(stream)
          end
          sleep Settings.options[:scroll][:timer]
        rescue Interrupt
          canceled
        rescue => e
          raise e
        end
      end
    end

    private

    def check_raw(options)
      if options[:raw]
        options = {count: 200, since_id: nil, raw: true, scroll: true}
      else
        options = {count: 200, since_id: nil, scroll: true}
      end
    end

    def options_hash(stream)
      {:count => 50, :since_id => stream['meta']['max_id'], scroll: true}
    end

    def show(stream, options)
      unless options[:raw]
        @view.show_posts(stream['data'], options)
      else
        puts stream
      end
    end

    def canceled
      puts Status.canceled
      exit
    end
  end
end
