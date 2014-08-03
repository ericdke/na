# encoding: utf-8
module Ayadn

  class NowPlaying

    require 'rss'

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
    end

    def lastfm options
      begin
        user = Settings.options[:nowplaying][:lastfm] || create_lastfm_user()
        puts Status.fetching_from('Last.fm')
        artist, track = get_lastfm_track_infos(user)
        puts Status.itunes_store
        store = lastfm_istore_request(artist, track) unless options['no_url']
        text_to_post = "#nowplaying\n \nTitle: ‘#{track}’\nArtist: #{artist}"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [store, options]})
      end
    end

    def itunes options

    end






  end

end
