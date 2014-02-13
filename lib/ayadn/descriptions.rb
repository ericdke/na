module Ayadn
	class Descriptions
		def self.unified
			%Q{Shows your Unified Stream.\n\nShortcut: replace 'unified' by '-U'.}
		end
		def self.checkins
			%Q{Shows the Checkins Stream.\n\nShortcut: replace 'checkins' by '-K'}
		end
		def self.global
			%Q{Shows the Global Stream.\n\nShortcut: replace 'global' by '-G'}
		end
		def self.trending
			%Q{Shows the Trending Stream.\n\nShortcut: replace 'trending' by '-TR'}
		end
		def self.photos
			%Q{Shows the Photos Stream.\n\nShortcut: replace 'photos' by '-PH'}
		end
		def self.conversations
			%Q{Shows the Conversations Stream.\n\nShortcut: replace 'conversations' by '-CQ'}
		end
		def self.mentions
			%Q{Shows posts containing a mention of a @username.\n\nShortcut: replace 'mentions' by '-M'}
		end
		def self.posts
			%Q{Shows @username's posts.\n\nShortcut: replace 'posts' by '-PO'}
		end
		def self.whatstarred
			%Q{Shows posts starred by @username.\n\nShortcut: replace 'whatstarred' by '-WAS'}
		end
		def self.interactions
			%Q{Shows your recent ADN activity.\n\nShortcut: replace 'interactions' by '-INT'}
		end
		def self.whoreposted
			%Q{Lists users who reposted post n°POST-ID.\n\nShortcut: replace 'whoreposted' by '-WOR'}
		end
		def self.whostarred
			%Q{Lists users who starred post n°POST-ID.\n\nShortcut: replace 'whostarred' by '-WOS'}
		end
	end
end