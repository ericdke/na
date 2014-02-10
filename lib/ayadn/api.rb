module Ayadn
	class API
		def initialize
			@endpoints = Endpoints.new
		end
		USER_TOKEN = IO.read(File.expand_path("../../../token", __FILE__))
		def get_unified
			@url = @endpoints.unified
			return @url, USER_TOKEN
		end
	end
end