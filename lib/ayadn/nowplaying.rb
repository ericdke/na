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
      begin
        abort(Status.error_only_osx) unless Settings.config[:platform] =~ /darwin/
        puts Status.fetching_from('iTunes')
        itunes = get_itunes_track_infos()
        itunes.each {|el| abort(Status.empty_fields) if el.length == 0}
        puts Status.itunes_store
        store = itunes_istore_request(itunes) unless options['no_url']
        text_to_post = "#nowplaying\n \nTitle: ‘#{itunes.track}’\nArtist: #{itunes.artist}\nfrom ‘#{itunes.album}’"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [itunes, store, options]})
      end
    end

    private

    def get_lastfm_track_infos user
      begin
        url = "http://ws.audioscrobbler.com/2.0/user/#{user}/recenttracks.rss"
        feed = RSS::Parser.parse(CNX.download(url))
        lfm = feed.items[0].title.split(' – ')
        return lfm[0], lfm[1]
      rescue Interrupt
        abort(Status.canceled)
      end
    end

    def post_nowplaying text_to_post, store, options
      begin
        @view.clear_screen
        puts Status.writing
        show_nowplaying("\n#{text_to_post}", options, store)
        unless options[:no_url] || store.nil?
          text_to_post += "\n \n[iTunes Store](#{store['link']})"
        end
        abort(Status.canceled) unless STDIN.getch == ("y" || "Y")
        puts "\n#{Status.yourpost}"
        unless store.nil? || options[:no_url]
          visible, track, artwork, artwork_thumb, link, artist = true, store['track'], store['artwork'], store['artwork_thumb'], store['link'], store['artist']
        else
          visible, track, artwork, artwork_thumb, link, artist = false
        end
        if options[:lastfm]
          source = 'Last.fm'
        else
          source = 'iTunes'
        end
        dic = {
          options: options,
          text: text_to_post,
          title: track,
          artist: artist,
          artwork: artwork,
          artwork_thumb: artwork_thumb,
          width: 1200,
          height: 1200,
          width_thumb: 200,
          height_thumb: 200,
          link: link,
          source: source,
          visible: visible
        }
        @view.show_posted(Post.new.post(dic))
      rescue => e
        puts Status.wtf
        Errors.global_error({error: e, caller: caller, data: [dic, store, options]})
      end
    end

    def ask_lastfm_user
      puts "\nPlease enter your Last.fm username:\n".color(:cyan)
      begin
        STDIN.gets.chomp!
      rescue Interrupt
        abort(Status.canceled)
      end
    end

    def create_lastfm_user
      Settings.options[:nowplaying][:lastfm] = ask_lastfm_user()
      Settings.save_config
      return Settings.options[:nowplaying][:lastfm]
    end

    def itunes_istore_request itunes
      infos = itunes_reg([itunes.artist, itunes.track, itunes.album])
      itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&term=#{infos[2]}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, itunes.artist, itunes.track)
    end

    def lastfm_istore_request artist, track
      infos = itunes_reg([artist, track])
      itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, artist, track)
    end

    def get_itunes_store url, artist, track
      results = JSON.load(CNX.download(URI.escape(url)))['results']
      unless results.empty? || results.nil?

        resp = results.select {|obj| obj['artistName'] == artist && obj['trackName'] == track}
        candidate = resp[0] || results[0]

        return {
          'code' => 200,
          'artist' => candidate['artistName'],
          'track' => candidate['trackName'],
          'preview' => candidate['previewUrl'],
          'link' => candidate['collectionViewUrl'],
          'artwork' => candidate['artworkUrl100'].gsub('100x100', '1200x1200'),
          'artwork_thumb' => candidate['artworkUrl100'].gsub('100x100', '600x600'),
          'request' => url,
          'results' => results
        }
      else
        return {
          'code' => 404,
          'request' => url
        }
      end
    end

    def itunes_reg arr_of_itunes
      regex_exotics = /[~:-;,?!\'&`^=+<>*%()\/"“”’°£$€.…]/
      arr_of_itunes.map do |itune|
        itune.gsub(regex_exotics, ' ').split(' ').join('+')
      end
    end

    def get_itunes_track_infos
      track = `osascript -e 'tell application "iTunes"' -e 'set trackName to name of current track' -e 'return trackName' -e 'end tell'`
      if track.empty?
        puts Status.no_itunes
        Errors.warn "Nowplaying canceled: unable to get info from iTunes."
        exit
      end
      album = `osascript -e 'tell application "iTunes"' -e 'set trackAlbum to album of current track' -e 'return trackAlbum' -e 'end tell'`
      artist = `osascript -e 'tell application "iTunes"' -e 'set trackArtist to artist of current track' -e 'return trackArtist' -e 'end tell'`
      maker = Struct.new(:artist, :album, :track)
      maker.new(artist.chomp!, album.chomp!, track.chomp!)
    end

    def show_nowplaying(text, options, store)
      puts "\nYour post:\n".color(:cyan)
      if options['no_url'] || store['code'] != 200
        puts text + "\n\n\n"
      else
        puts text + "\n\n\nThe iTunes Store thinks this track is: ".color(:green) + "'#{store['track']}'".color(:magenta) + " by ".color(:green) + "'#{store['artist']}'".color(:magenta) + ".\n\nAyadn will use these elements to insert album artwork and a link to the track.\n\n".color(:green)
      end
      puts "Is it ok? (y/N) ".color(:yellow)
    end

  end

end
