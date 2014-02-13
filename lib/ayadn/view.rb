module Ayadn
	class View

		def initialize
			@workers = Workers.new
		end

		def show_posts_with_index(data)
			posts, view = @workers.build_stream_with_index(data)
			#puts "\n"
			puts view
			File.open($config.config[:paths][:home] + "/index", "w") { |f| f.write(posts.to_json) }
		end

		def show_posts(data)
			view = @workers.build_stream_without_index(data)
			#puts "\n"
			puts view
		end

		def show_simple_stream(stream)
			puts stream
		end

		def show_list_reposted(list, target)
			#puts "List of users who reposted post ".color(:cyan) + "#{target}\n".color(:red)
			puts @workers.build_reposted_list(list, target)
			puts "\n"
		end

		def show_list_starred(list, target)
			#puts "List of users who starred post ".color(:cyan) + "#{target}\n".color(:red)
			puts @workers.build_starred_list(list, target)
			puts "\n"
		end

		def show_interactions(stream)
			#puts "\n"
			puts @workers.build_interactions_stream(stream)
		end

		def clear_line
			print "\r                                            \n"
		end

		def clear_screen
			puts "\e[H\e[2J"
		end

	end
end