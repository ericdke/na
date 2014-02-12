module Ayadn
	class Descriptions
		def self.unified
			%Q{Shows your Unified Stream.\nShortcut: replace 'unified' by 'uni' or '-U'.}
		end
		def self.checkins
			%Q{Shows the Checkins Stream.\nShortcut: replace 'checkins' by 'chk' or '-K'}
		end
		def self.global
			%Q{Shows the Global Stream.\nShortcut: replace 'global' by 'glo' or '-G'}
		end
		def self.trending
			%Q{Shows the Trending Stream.\nShortcut: replace 'trending' by 'tre' or '-TR'}
		end
		def self.photos
			%Q{Shows the Photos Stream.\nShortcut: replace 'photos' by 'pho' or '-PH'}
		end
		def self.conversations
			%Q{Shows the Conversations Stream.\nShortcut: replace 'conversations' by '-CQ'}
		end
		def self.mentions
			%Q{Shows posts containing a mention of a @username.\nShortcut: replace 'mentions' by 'men' or '-M'}
		end
		def self.posts
			%Q{Shows @username's posts.\nShortcut: replace 'posts' by '-PO'}
		end
		def self.starred
			%Q{Shows posts starred by @username.\nShortcut: replace 'starred' by '-ST'}
		end
		def self.interactions
			%Q{Shows your recent ADN activity.\nShortcut: replace 'interactions' by '-HIST'}
		end
	end
end