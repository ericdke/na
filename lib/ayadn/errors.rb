# encoding: utf-8
module Ayadn
  class Errors
    def self.global_error(where, args, error)
      #elems = []
      #args.each {|arg| elems << self.detokenize(arg)} #TODO: make it work
      Logs.rec.error "--BEGIN--"
      Logs.rec.error "#{error}"
      Logs.rec.debug "LOCATION: #{where}"
      Logs.rec.debug "DATA: #{args}"
      Logs.rec.debug "STACK: #{caller}"
      Logs.rec.error "--END--"
      puts "\n(error logged in #{Settings.config[:paths][:log]}/ayadn.log)\n".color(:blue)
      if Settings.options[:timeline][:show_debug] == true
        raise error
      end
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

    private

    def self.detokenize(string)
      string.dup.to_s.gsub!(/token=[a-zA-Z0-9_-]+/, "token=XXX") unless string.nil?
    end
  end
end
