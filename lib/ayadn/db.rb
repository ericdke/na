module Ayadn

	class Databases

		attr_accessor :users, :index

		def initialize
			@users = Daybreak::DB.new "#{$myconfig.config[:paths][:db]}/users.db"
			@index = Daybreak::DB.new "#{$myconfig.config[:paths][:pagination]}/index.db"
		end

		def close_all
			@users.flush
			@users.close
			@index.flush
			@index.close
		end

	end

end