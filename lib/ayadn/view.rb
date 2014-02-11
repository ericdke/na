module Ayadn
	class View

		def initialize
			@workers = Workers.new
		end

		def show_posts_with_index(data)
			# puts "\n"
			posts, view = @workers.build_stream_with_index(data)
			puts view
			File.open($config.config[:paths][:home] + "/index", "w") { |f| f.write(posts.to_json) }
		end



		def show_posts(data)
			puts "\n"
			# TODO
		end

		def clear_line
			print "\r                                            \n"
		end

	end
end