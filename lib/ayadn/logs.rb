module Ayadn
  class Logs
    class << self
      attr_accessor :rec
    end
    def self.create_logger
      @rec = Logger.new(Settings.config[:paths][:log] + "/ayadn.log", 'monthly')
      @rec.formatter = proc do |severity, datetime, progname, msg|
        "#{Settings.config[:version]} #{datetime} -- #{msg}\n"
      end
    end
  end
end
