module Ayadn
	class Logs
		class << self
			attr_accessor :rec
		end
		def self.create_logger
			@rec = Logger.new(MyConfig.config[:paths][:log] + "/ayadn.log", 'monthly')
		end
	end
end