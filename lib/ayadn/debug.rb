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

    def self.db dbs
      if Settings.options[:timeline][:show_debug] == true
        puts "/////\nSETTINGS\n"
        jj JSON.parse((Settings.config).to_json)
        jj JSON.parse((Settings.options).to_json)
        Logs.rec.debug "SETTINGS/CONFIG: #{Settings.config}"
        Logs.rec.debug "SETTINGS/OPTIONS: #{Settings.options}"
        puts "/////\n\n"

        #puts ">>>>>\nDATABASES\n"
        dbs.each do |db|
          #puts "Path:\t#{db.file}\nLength:\t#{db.size}\nSize:\t#{db.bytesize / 1024}KB"
          Logs.rec.debug "DB: #{File.basename(db.file)} - Length: #{db.size}, Size: #{db.bytesize / 1024}KB"
        end
        #puts ">>>>>\n\n"

        # puts "^^^^^\nTOKEN\n"
        # puts Settings.user_token
        # puts "^^^^^\n\n"
      end
    end

    def self.err error, stack
      if Settings.options[:timeline][:show_debug] == true
        puts "\n--*--\nERROR:\n"
        raise error
        puts "\n--*--\nSTACK:\n"
        puts stack
        puts "\n--*--\n\n"
      end
    end

    def self.how_many_ranks niceranks, get_these
      if Settings.options[:timeline][:show_debug] == true
        # deb = "=====\n"
        # deb << "NR from DB:\t#{niceranks}\n\n"
        # deb << "NR to get:\t#{get_these}\n"
        # deb << "=====\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "NR/FROM DB: #{niceranks}"
        Logs.rec.debug "NR/TO GET: #{get_these}"
      end
    end

    def self.ranks_pool niceranks
      if Settings.options[:timeline][:show_debug] == true
        # deb = "=====\n"
        # deb << "NR in pool:\t#{niceranks}\n"
        # deb << "=====\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "NR/IN POOL: #{niceranks}"
      end
    end

    def self.niceranks_error resp
      if Settings.options[:timeline][:show_debug] == true
        # deb = "=====\n"
        # deb << "NR Error:\t#{resp}\n"
        # deb << "=====\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.error "NR/ERROR: #{resp}"
      end
    end

    def self.total_ranks niceranks
      if Settings.options[:timeline][:show_debug] == true
        # deb = "=====\n"
        # deb << "NiceRanks:\t#{niceranks}\n\n"
        # deb << "DB size:\t#{Databases.nicerank.size}\n"
        # deb << "=====\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "NR/RANKS: #{niceranks}"
        Logs.rec.debug "NR/DB SIZE: #{Databases.nicerank.size}"
      end
    end

    def self.stream stream, options, target
      if Settings.options[:timeline][:show_debug] == true
        # deb = "+++++\nStream meta:\t#{stream['meta']}\n\n"
        # deb << "Options:\t#{options.inspect}\n\n"
        # deb << "Target:\t\t#{target.inspect}\n\n"
        # deb << "Posts:\t\t#{stream['data'].length}\n+++++\n"
        # puts deb.color(Settings.options[:colors][:debug])
        Logs.rec.debug "STREAM/META: #{stream['meta']}"
        Logs.rec.debug "STREAM/OPTIONS: #{options.inspect}"
        Logs.rec.debug "STREAM/TARGET: #{target.inspect}"
        Logs.rec.debug "STREAM/POSTS: #{stream['data'].length}"
      end
    end

  end
end
