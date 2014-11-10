# encoding: utf-8
module Ayadn

  class NowPlaying

    require 'rss'

    def initialize api, view, workers
      @api = api
      @view = view
      @workers = workers
      @status = Status.new
    end

    def lastfm options
      begin
        user = Settings.options[:nowplaying][:lastfm] || create_lastfm_user()
        @status.fetching_from('Last.fm')
        artist, track = get_lastfm_track_infos(user)
        @status.itunes_store
        store = []
        unless options['no_url']
          store = lastfm_istore_request(artist, track)
          if store['code'] == 404 && artist =~ /(and)/
            artist.gsub!('and', '&')
            store = lastfm_istore_request(artist, track)
          end
        end
        text_to_post = "#nowplaying\n \nTitle: ‘#{track}’\nArtist: #{artist}"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        @status.wtf
        Errors.global_error({error: e, caller: caller, data: [store, options]})
      end
    end

    def itunes options
      begin
        unless Settings.config[:platform] =~ /darwin/
          @status.error_only_osx
          exit
        end
        @status.fetching_from('iTunes')
        itunes = get_itunes_track_infos()
        itunes.each do |el|
          if el.length == 0
            @status.empty_fields
            exit
          end
        end
        @status.itunes_store
        store = []
        unless options['no_url']
          store = itunes_istore_request(itunes)
          if store['code'] == 404 && itunes.artist =~ /(and)/
            itunes.artist.gsub!('and', '&')
            store = itunes_istore_request(itunes)
          end
        end
        text_to_post = "#nowplaying\n \nTitle: ‘#{itunes.track}’\nArtist: #{itunes.artist}\nfrom ‘#{itunes.album}’"
        post_nowplaying(text_to_post, store, options)
      rescue => e
        @status.wtf
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
        @status.canceled
        exit
      end
    end

    def post_nowplaying text_to_post, store, options
      begin
        @view.clear_screen
        @status.writing
        show_nowplaying("\n#{text_to_post}", options, store)
        unless options[:no_url] || store.nil?
          text_to_post += "\n \n[iTunes Store](#{store['link']})"
        end
        unless STDIN.getch == ("y" || "Y")
          @status.canceled
          exit
        end
        @view.clear_screen
        @status.yourpost
        puts "\n\n"
        if store.nil? || options[:no_url]
          visible, track, artwork, artwork_thumb, link, artist = false
        else
          if store['link'].nil?
            visible, track, artwork, artwork_thumb, link, artist = false
          end
          visible, track, artwork, artwork_thumb, link, artist = true, store['track'], store['artwork'], store['artwork_thumb'], store['link'], store['artist']
        end
        options = options.dup
        options[:nowplaying] = true
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
        resp = Post.new.post(dic)
        FileOps.save_post(resp) if Settings.options[:backup][:sent_posts]
        @view.show_posted(resp)
      rescue => e
        @status.wtf
        Errors.global_error({error: e, caller: caller, data: [dic, store, options]})
      end
    end

    def ask_lastfm_user
      @status.info("please", "enter your Last.fm username", "yellow")
      print "> "
      begin
        STDIN.gets.chomp!
      rescue Interrupt
        @status.canceled
        exit
      end
    end

    def create_lastfm_user
      Settings.options[:nowplaying][:lastfm] = ask_lastfm_user()
      Settings.save_config
      return Settings.options[:nowplaying][:lastfm]
    end

    def itunes_istore_request itunes
      # infos = itunes_reg([itunes.artist, itunes.track, itunes.album])
      # itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&term=#{infos[2]}&media=music&entity=musicTrack"
      itunes_url = "https://itunes.apple.com/search?term=#{itunes.artist}&term=#{itunes.track}&term=#{itunes.album}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, itunes.artist, itunes.track)
    end

    def lastfm_istore_request artist, track
      # infos = itunes_reg([artist, track])
      # itunes_url = "https://itunes.apple.com/search?term=#{infos[0]}&term=#{infos[1]}&media=music&entity=musicTrack"
      itunes_url = "https://itunes.apple.com/search?term=#{artist}&term=#{track}&media=music&entity=musicTrack"
      get_itunes_store(itunes_url, artist, track)
    end

    def get_itunes_store url, artist, track
      results = JSON.load(CNX.download(URI.escape(url)))['results']
# puts results.inspect
# exit
      unless results.empty? || results.nil?

        # results.delete_if {|obj| obj['trackName'].nil?}
        # results.delete_if {|obj| obj['collectionArtistName'].nil?}

# results.each {|obj| puts obj['trackName']}
# puts "-"
# puts track
# exit

        one = results.select do |obj|
          next if obj['trackName'].nil?
          obj['trackName'].downcase == track.downcase
        end
# puts one.inspect
# exit
        if one.empty?
          by_artist = results.select do |obj|
            next if obj['artistName'].nil?
            obj['artistName'].downcase == artist.downcase
          end
# puts by_artist
# exit
          by_exact_track = by_artist.select do |obj|
            next if obj['trackName'].nil?
            obj['trackName'].downcase == track.downcase
          end
# puts by_exact_track
# exit
          if by_exact_track.empty?
            splitted = track.split(" ").first.downcase
            by_artist.select! do |obj|
              next if obj['trackName'].nil?
              obj['trackName'].split(" ").first.downcase == splitted
            end
          end
# puts by_artist
# exit
          results = by_artist

        else
          results = one
        end

        if results.empty?
          return {
            'code' => 404,
            'request' => url
          }
        end

        candidate = results[0]

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
      regex_exotics = /[~:-;,?!\'&`^=+<>()*%\/"“”’°£$€.…]/
      arr_of_itunes.map do |itune|
        itune.gsub(regex_exotics, ' ').split(' ').join('+')
      end
    end

    def get_itunes_track_infos
      track = `osascript -e 'tell application "iTunes"' -e 'set trackName to name of current track' -e 'return trackName' -e 'end tell'`
      if track.empty?
        @status.no_itunes
        Errors.warn "Nowplaying canceled: unable to get info from iTunes."
        exit
      end
      album = `osascript -e 'tell application "iTunes"' -e 'set trackAlbum to album of current track' -e 'return trackAlbum' -e 'end tell'`
      artist = `osascript -e 'tell application "iTunes"' -e 'set trackArtist to artist of current track' -e 'return trackArtist' -e 'end tell'`
      maker = Struct.new(:artist, :album, :track)
      maker.new(artist.chomp!, album.chomp!, track.chomp!)
    end

    def show_nowplaying(text, options, store)
      @status.to_be_posted
      thor = Thor::Shell::Basic.new
      text.split("\n").each do |line|
        thor.say_status(nil, line.color(Settings.options[:colors][:excerpt]))
      end
      puts "\n"
      unless options['no_url'] || store['code'] != 200
        # lcol = Settings.options[:colors][:link]
        thor.say_status(nil, "[iTunes link](#1)")
        thor.say_status(nil, "[album art](#2)")
        puts "\n"
        thor.say_status(:'#1', store['link'])
        thor.say_status(:'#2', store['artwork'])
        puts "\n"
        @status.itunes_store_track(store)
      end
      @status.ok?
    end

  end

end
