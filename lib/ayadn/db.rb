module Ayadn

	class Databases

		attr_accessor :users

		def initialize
			@users = Daybreak::DB.new "#{$config.config[:paths][:db]}/users.db"
		end

		def close_all
			@users.flush
			@users.close
		end

	end

end