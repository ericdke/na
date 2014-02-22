module Ayadn

	class Databases

		class << self
			attr_accessor :users, :index
		end

		def self.close_all
			@users.flush
			@users.close
			@index.flush
			@index.close
		end

	end

end