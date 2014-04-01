# encoding: utf-8
module Ayadn
  class Logs
    class << self
      attr_accessor :rec
    end
    def self.create_logger
      @rec = Logger.new(Settings.config[:paths][:log] + "/ayadn.log", 'monthly')
      @rec.formatter = proc do |severity, datetime, progname, msg|
        "#{datetime} (#{Settings.config[:version]}) #{severity} -- #{msg}\n"
      end
    end

    # unused (experiment)
    def self.send_log(from, args, content)
      begin
        log = {
          "platform" => "#{Settings.config[:platform]}",
          "date" => Time.now,
          "version" => "#{Settings.config[:version]}",
          "source" => from,
          "args" => args,
          "content" => content
        }
        Post.new.send_log(log)
      rescue
        @rec.warn("Unable to send log.")
      end
    end

  end
end
