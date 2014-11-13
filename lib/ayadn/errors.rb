# encoding: utf-8
module Ayadn
  class Errors

    def self.global_error(args)
      if Logs.nil? || Logs.rec.nil?
        Status.new.wtf
        exit
      end
      thor = Thor::Shell::Color.new
      Logs.rec.error "--BEGIN--"
      Logs.rec.error "CAUSE: #{args[:error]}"
      Logs.rec.debug "DATA: #{args[:data]}"
      stack = args[:caller].map do |path|
        splitted = path.split('/')
        file = splitted.pop
        dir = splitted.pop
        "#{dir}/#{file}"
      end
      Logs.rec.debug "STACK: #{stack}"
      Logs.rec.error "--END--"
      thor.say_status :log, "#{Settings.config[:paths][:log]}/ayadn.log", :red
      puts "\n"
      Debug.err(args[:error], stack)
      exit
    end

    def self.error(status)
      Logs.rec.error status
    end

    def self.warn(warning)
      Logs.rec.warn warning
    end

    def self.info(msg)
      Logs.rec.info msg
    end

    def self.repost(repost, original)
      Logs.rec.info "Post #{repost} is a repost. Using original: #{original}."
    end

    def self.nr msg
      Logs.nr.warn msg
    end

    def self.no_data(where)
      self.warn "In action/#{where}: no data"
      Status.new.empty_list
      exit
    end

  end
end
