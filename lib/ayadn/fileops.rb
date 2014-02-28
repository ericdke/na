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
				raise e
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
				Logs.rec.error "From fileops/get_post_from_index"
				Logs.rec.error "#{e}"
				raise e
			end
		end

		def self.add_to_users_db_from_list(list)
			list.each do |id, content_array|
				Databases.users[id] = {content_array[0] => content_array[1]}
			end
		end

	end
end
