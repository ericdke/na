# encoding: utf-8
module Ayadn
  class Errors
    def self.global_error(where, args, error)
      [where, args, error].each do |el|
        self.detokenize(el)
      end
      Logs.rec.error "#{error}"
      unless args.nil?
        Logs.rec.error "LOCATION: #{where}"
        Logs.rec.error "DATA: #{args}"
      else
        Logs.rec.error "LOCATION: #{where}"
      end
      Logs.rec.error "CALLER: #{caller}"
      Logs.rec.error "-----"
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

    private

    def self.detokenize(string)
      string.to_s.gsub!(/token=[a-zA-Z0-9_-]+/, "token=XXX") unless string.nil?
    end
  end
end
