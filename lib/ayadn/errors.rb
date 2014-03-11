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
      puts "\e[H\e[2J"
      puts "\n\nERROR (see #{Settings.config[:paths][:log]}/ayadn.log)\n".color(:red)
      raise error
    end
    def self.warn(warning)
      Logs.rec.warn warning
    end
  end
end
