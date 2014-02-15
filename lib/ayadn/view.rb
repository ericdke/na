module Ayadn
	class View

		def initialize
			@workers = Workers.new
		end

		def show_posts_with_index(data)
			posts, view = @workers.build_stream_with_index(data)
			#puts "\n"
			puts view
			@workers.save_indexed_posts(posts)
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
			puts @workers.build_reposted_list(list, target)
			puts "\n"
		end

		def show_list_starred(list, target)
			puts @workers.build_starred_list(list, target)
			puts "\n"
		end

		def show_list_followings(list, target)
			puts @workers.build_followings_list(list, target)
			puts "\n"
		end

		def show_list_followers(list, target)
			puts @workers.build_followers_list(list, target)
			puts "\n"
		end

		def show_list_muted(list)
			puts @workers.build_muted_list(list)
			puts "\n"
		end

		def show_list_blocked(list)
			puts @workers.build_blocked_list(list)
			puts "\n"
		end

		def show_interactions(stream)
			#puts "\n"
			puts @workers.build_interactions_stream(stream)
		end

		def settings			
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "Current Ayadn settings"
				t.headings = [ "Category", "Parameter", "Value(s)" ]
				@iter = 0
				$config.options.each do |k,v|
					v.each do |x,y|
						t << :separator if @iter >= 1
						unless y.is_a?(Hash)
							t << [ k, x, y ]
						else
							y.each do |c|
								t << [ k, x, "#{c[0]} = #{c[1]}" ]
							end
						end
						@iter += 1
					end
				end
			end
			puts table
		end

		def clear_line
			print "\r                                            \n"
		end

		def clear_screen
			puts "\e[H\e[2J"
		end

	end
end