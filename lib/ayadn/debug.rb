# encoding: utf-8
module Ayadn
  class Debug

    def self.http response, url
      if Settings.options[:timeline][:show_debug] == true
        deb = ":::::\n"
        deb << "Url:\t\t#{url}\n\n"
        deb << "Headers:\t#{response.headers}\n"
        deb << ":::::\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

    def self.db dbs
      if Settings.options[:timeline][:show_debug] == true
        puts "/////\nSETTINGS\n"
        jj JSON.parse((Settings.config).to_json)
        jj JSON.parse((Settings.options).to_json)
        puts "/////\n\n"

        puts ">>>>>\nDATABASES\n"
        dbs.each do |db|
          puts "Path:\t#{db.file}\nLength:\t#{db.size}\nSize:\t#{db.bytesize / 1024}KB"
        end
        puts ">>>>>\n\n"

        puts "^^^^^\nTOKEN\n"
        puts Settings.user_token
        puts "^^^^^\n\n"
      end
    end

    def self.err error
      if Settings.options[:timeline][:show_debug] == true
        puts "--*--\nTRACE:\n"
        raise error
        puts "\n--*--\n\n"
      end
    end

    def self.how_many_ranks niceranks, get_these
      if Settings.options[:timeline][:show_debug] == true
        deb = "=====\n"
        deb << "NR from DB:\t#{niceranks}\n\n"
        deb << "NR to get:\t#{get_these}\n"
        deb << "=====\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

    def self.ranks_pool niceranks
      if Settings.options[:timeline][:show_debug] == true
        deb = "=====\n"
        deb << "NR in pool:\t#{niceranks}\n"
        deb << "=====\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

    def self.niceranks_error resp
      if Settings.options[:timeline][:show_debug] == true
        deb = "=====\n"
        deb << "NR Error:\t#{resp}\n"
        deb << "=====\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

    def self.total_ranks niceranks
      if Settings.options[:timeline][:show_debug] == true
        deb = "=====\n"
        deb << "NiceRanks:\t#{niceranks}\n\n"
        deb << "DB size:\t#{Databases.nicerank.size}\n"
        deb << "=====\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

    def self.stream stream, options, target
      if Settings.options[:timeline][:show_debug] == true
        deb = "+++++\nStream meta:\t#{stream['meta']}\n\n"
        deb << "Options:\t#{options.inspect}\n\n"
        deb << "Target:\t\t#{target.inspect}\n\n"
        deb << "Posts:\t\t#{stream['data'].length}\n+++++\n"
        puts deb.color(Settings.options[:colors][:debug])
      end
    end

  end
end
