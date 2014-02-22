module Ayadn
	class FileOps

		def self.save_indexed_posts(posts)
			begin
				Databases.index.clear
				posts.each do |id, hash|
					Databases.index[id] = hash
				end
			rescue => e
				Logs.rec.error "From fileops/save_indexed_posts"
				Logs.rec.error "#{e}"
			end
		end

		def self.get_post_from_index(number)
			begin
				unless number > Databases.index.length || number <= 0
					Databases.index.to_h.each do |id, values|
						return values if values[:count] == number
					end
				else
					raise #temp
				end
			rescue => e
				Logs.rec.error "From workers/get_post_from_index"
				Logs.rec.error "#{e}"
			end
		end

	end
end