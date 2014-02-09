module Ayadn
	class API
		USER_TOKEN = IO.read(File.expand_path("../../../token", __FILE__))
	end
end