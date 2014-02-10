module Ayadn
	class View

		def show_posts_with_index(posts_array)
			@count = 1
			puts "\n"
			posts_array.each do |post|
				print ("%03d" % @count).to_s.color(:red) + " " + post
				@count += 1
			end
		end

		def show_posts(posts_array)
			puts "\n"
			posts_array.each { |post| puts post }
		end

		def clear_line
			print "\r                                            \n"
		end

	end
end