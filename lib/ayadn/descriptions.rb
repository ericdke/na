module Ayadn
	class Descriptions
		def self.unified
			%Q{Shows your Unified Stream.\nShortcut: replace 'unified' by 'uni' or '-U'.}
		end
		def self.checkins
			%Q{Shows the Checkins Stream.\nShortcut: replace 'checkins' by 'chk' or '-W'}
		end
		def self.global
			%Q{Shows the Global Stream.\nShortcut: replace 'global' by 'glo' or '-G'}
		end
		def self.trending
			%Q{Shows the Trending Stream.\nShortcut: replace 'trending' by 'tre' or '-T'}
		end
		def self.photos
			%Q{Shows the Photos Stream.\nShortcut: replace 'photos' by 'pho' or '-P'}
		end
		def self.conversations
			%Q{Shows the Conversations Stream.\nShortcut: replace 'conversations' by '-Q'}
		end
		def self.mentions
			%Q{Shows posts containing a mention of a @username.\nShortcut: replace 'mentions' by '-M'}
		end
	end
end