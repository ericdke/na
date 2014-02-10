module Ayadn
	class View

		def show_posts_with_index(posts)
			File.open($config.config[:paths][:home] + "/index", "w") { |f| f.write(posts.to_json) }
			puts "\n"
			posts.each do |count, pair|
				k = pair.keys
				#puts ":#{count}".color(:red) + " (#{k[0]})".color(:cyan)
				puts ":#{count}".color(:red)
				puts pair.values
			end
		end

		def show_posts(posts)
			puts "\n"
			posts.each do |count, pair|
				k = pair.keys
				puts "#{k[0]}".color(:red)
				puts pair.values
			end
		end

		def clear_line
			print "\r                                            \n"
		end

	end
end