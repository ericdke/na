# encoding: utf-8
module Ayadn
  class Debug

    def self.skipped dic
      if Settings.options[:timeline][:debug] == true
        Logs.rec.debug "SKIPPED: #{dic.keys.first.to_s.capitalize} => #{dic.values.first}"
      end
    end

    def self.http response, url
      if Settings.options[:timeline][:debug] == true
        deb = "\n"
        deb << "+ HTTP\n"
        deb << "* t#{Time.now.to_i}\n"
        # deb << "Url:\t\t#{url}\n"
        deb << "#{response.headers}\n"
        deb << "\n"
        puts deb.color(Settings.options[:colors][:debug])
        # Logs.rec.debug "HTTP/URL: #{url}"
        Logs.rec.debug "HTTP/HEADERS: #{response.headers}"
      end
    end

    def self.err error, stack
      Logs.rec.debug "+DEBUG STACK: #{stack}"
      if Settings.options[:timeline][:debug] == true
        puts "\n--*--\nERROR:\n"
        raise error
        puts "\n--*--\nSTACK:\n"
        puts stack
        puts "\n--*--\n\n"
      end
    end

    def self.stream(stream, options, target)
      if Settings.options[:timeline][:debug] == true
        deb = "\n"
        deb << "+ STREAM\n"
        deb << "* t#{Time.now.to_i}\n"
        deb << "Options:\t#{options.inspect}\n"
        deb << "Target:\t\t#{target.inspect}\n"
        deb << "Posts:\t\t#{stream['data'].length}\n"
        deb << "Meta:\t\t#{stream['meta']}\n"
        deb << "\n"
        puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "STREAM/META: #{stream['meta']}"
        Logs.rec.debug "STREAM/OPTIONS: #{options.inspect}"
        Logs.rec.debug "STREAM/TARGET: #{target.inspect}"
        Logs.rec.debug "STREAM/POSTS: #{stream['data'].length}"
      end
    end

  end
end
