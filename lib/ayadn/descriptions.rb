module Ayadn
	class Descriptions
		def self.unified
			%Q{Shows your Unified Stream.\nShortcut: replace 'unified' by 'un' or '-U'.}
		end
		def self.checkins
			%Q{Shows the Checkins Stream.\nShortcut: replace 'checkins' by 'ch' or '-W'}
		end
		def self.global
			%Q{Shows the Global Stream.\nShortcut: replace 'global' by 'gl' or '-G'}
		end
		def self.trending
			%Q{Shows the Trending Stream.\nShortcut: replace 'trending' by 'tr' or '-T'}
		end
		def self.photos
			%Q{Shows the Photos Stream.\nShortcut: replace 'photos' by 'ph' or '-H'}
		end
		def self.conversations
			%Q{Shows the Conversations Stream.\nShortcut: replace 'conversations' by '-Q'}
		end
		def self.mentions
			%Q{Shows posts containing a mention of a @username.\nShortcut: replace 'mentions' by 'mn' or '-M'}
		end
		def self.posts
			%Q{Shows @username's posts.\nShortcut: replace 'posts' by 'ps' or '-P'}
		end
	end
end