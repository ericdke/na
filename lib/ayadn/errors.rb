# encoding: utf-8
module Ayadn
  class Errors
    def self.global_error(where, args, error)
      [where, args, error].each do |el|
        self.detokenize(el)
      end
      Logs.rec.error "--BEGIN--"
      Logs.rec.error "#{error}"
      Logs.rec.debug "LOCATION: #{where}"
      Logs.rec.debug "DATA: #{args}" unless args.nil?
      Logs.rec.debug "STACK: #{caller}"
      Logs.rec.error "--END--"
      puts "\n(error logged in #{Settings.config[:paths][:log]}/ayadn.log)\n".color(:blue)
      #raise error
      exit
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

    private

    def self.detokenize(string)
      string.to_s.gsub!(/token=[a-zA-Z0-9_-]+/, "token=XXX") unless string.nil?
    end
  end
end
