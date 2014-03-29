# encoding: utf-8
module Ayadn
  class Errors
    def self.global_error(where, args, error)
      unless args.nil?
        Logs.rec.error "In #{where}, args: #{args}"
      else
        Logs.rec.error "In #{where}:"
      end
      Logs.rec.error "#{error}"
      #puts "\e[H\e[2J"
      puts "\n(Error logged in #{Settings.config[:paths][:log]}/ayadn.log)\n".color(:blue)

      raise error
      exit
    end
    def self.warn(warning)
      Logs.rec.warn warning
    end
    def self.info(msg)
      Logs.rec.info msg
    end
  end
end
