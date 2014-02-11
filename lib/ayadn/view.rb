module Ayadn
	class View

		def show_posts_with_index(posts)
			File.open($config.config[:paths][:home] + "/index", "w") { |f| f.write(posts.to_json) }
			jj posts
			# puts "\n"
			# posts.each do |count, pair|
			# 	k = pair.keys
			# 	puts "#{count}:".color(:red)
			# 	puts pair.values
			# end
		end


# AMELIORE TOUT CA
# FAIS UN VRAI TABLEAU AVEC LES TRUCS DEDANS
# SEPARE HEADERS/CORPS/LINKS/ETC


		def show_posts(posts)
			puts "\n"
			posts.each do |count, pair|
				k = pair.keys
				puts "#{k[0]}:".color(:red)
				puts pair.values
			end
		end

		def clear_line
			print "\r                                            \n"
		end

	end
end