module Ayadn
	class Status
		def self.downloading
			"Downloading from ADN...".inverse
		end
		def self.error_missing_username
			"\nYou have to specify a username.\n".color(:red)
		end
		def self.error_missing_post_id
			"\nYou have to specify a post id.\n".color(:red)
		end
		def self.empty_list
			"\n\nThe list is empty.\n\n".color(:red)
		end
	end
end