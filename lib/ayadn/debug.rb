# encoding: utf-8
module Ayadn
  class Debug

    def self.skipped dic
      if Settings.options[:timeline][:show_debug] == true
        Logs.rec.debug "SKIPPED: #{dic.keys.first.to_s.capitalize} => #{dic.values.first}"
      end
    end

    def self.http response, url
      if Settings.options[:timeline][:show_debug] == true
        # deb = ":::::\n"
        # deb << "Url:\t\t#{url}\n\n"
        # deb << "Headers:\t#{response.headers}\n"
        # deb << ":::::\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "HTTP/URL: #{url}"
        Logs.rec.debug "HTTP/HEADERS: #{response.headers}"
      end
    end

    def self.err error, stack
      Logs.rec.debug "+DEBUG STACK: #{stack}"
      if Settings.options[:timeline][:show_debug] == true
        puts "\n--*--\nERROR:\n"
        raise error
        puts "\n--*--\nSTACK:\n"
        puts stack
        puts "\n--*--\n\n"
      end
    end

    def self.niceranks
      if Settings.options[:timeline][:show_debug] == true
        deb = "\n\n"
        deb << "+ NICERANK"
        deb << "* t#{Time.now.to_i}"
        deb << "Posts:\t\t#{stream['data'].size}"
        deb << "Requested NR:\t#{user_ids.size}"
        deb << "* TOTALS"
        deb << "Posts:\t\t#{@posts}"
        deb << "Requested NR:\t#{@ids}"
        deb << "Hits DB:\t#{@hits}"
        deb << "Uniques:\t#{@store.count}"
        deb << "\n\n"
        puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "NICERANK/STREAM LEN: #{@posts}"
        Logs.rec.debug "NICERANK/REQUESTS: #{@ids}"
        Logs.rec.debug "NICERANK/CACHE HITS: #{@hits}"
        Logs.rec.debug "NICERANK/CACHED IDS: #{@store.count}"
      end
    end

    def self.stream stream, options, target
      if Settings.options[:timeline][:show_debug] == true
        deb = "\n\n"
        deb << "+ STREAM"
        deb << "* t#{Time.now.to_i}"
        deb << "Meta:\t\t#{stream['meta']}"
        deb << "Options:\t#{options.inspect}"
        deb << "Target:\t\t#{target.inspect}"
        deb << "Posts:\t\t#{stream['data'].length}"
        deb << "\n\n"
        puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "STREAM/META: #{stream['meta']}"
        Logs.rec.debug "STREAM/OPTIONS: #{options.inspect}"
        Logs.rec.debug "STREAM/TARGET: #{target.inspect}"
        Logs.rec.debug "STREAM/POSTS: #{stream['data'].length}"
      end
    end

  end
end
