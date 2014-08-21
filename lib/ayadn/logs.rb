# encoding: utf-8
module Ayadn
  class Logs

    class << self
      attr_accessor :rec, :nr
    end

    def self.create_logger
      @rec = Logger.new(Settings.config[:paths][:log] + "/ayadn.log", 'monthly')
      @rec.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime} (#{Settings.config[:version]}) #{severity} * #{msg}\n"
      end
      @nr = Logger.new(Settings.config[:paths][:log] + "/nicerank.log", 'monthly')
      @nr.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime} (#{Settings.config[:version]}) #{severity} * #{msg}\n"
      end
    end

  end
end
