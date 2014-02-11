module Ayadn
	class Status
		def self.downloading
			"Downloading from ADN...".inverse
		end
		def self.error_missing_username
			"\nYou have to specify a username.\n".color(:red)
		end
	end
end