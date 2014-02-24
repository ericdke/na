module Ayadn
	class View

		def initialize
			@workers = Workers.new
		end

		def show_posts_with_index(data)
			posts, view = @workers.build_stream_with_index(data)
			#puts "\n"
			puts view
			FileOps.save_indexed_posts(posts)
		end

		def show_posts(data)
			view = @workers.build_stream_without_index(data)
			#puts "\n"
			puts view
		end

		def show_raw(stream)
			puts stream
		end

		def show_simple_post(post)
			view = @workers.build_stream_without_index(post)
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

		def show_files_list(list)
			puts @workers.build_files_list(list)
		end

		def settings			
			table = Terminal::Table.new do |t|
				t.style = { :width => MyConfig.options[:formats][:table][:width] }
				t.title = "Current Ayadn settings".color(:cyan)
				t.headings = [ "Category".color(:red), "Parameter".color(:red), "Value(s)".color(:red) ]
				@iter = 0
				MyConfig.options.each do |k,v|
					v.each do |x,y|
						t << :separator if @iter >= 1
						unless y.is_a?(Hash)
							t << [ k.to_s.color(:cyan), x.to_s.color(:yellow), y.to_s.color(:green) ]
						else
							y.each do |c|
								t << [ k.to_s.color(:cyan), x.to_s.color(:yellow), "#{c[0]} = #{c[1]}".color(:green) ]
							end
						end
						@iter += 1
					end
				end
			end
			puts table
		end

		def show_userinfos(content)
			view = "Real name\t\t".color(:cyan) + content['name'].color(MyConfig.options[:colors][:name])
			
			view << "\n\nUsername\t\t".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])
			
			view << "\n\nID\t\t\t".color(:cyan) + content['id'].color(:yellow)
			view << "\nURL\t\t\t".color(:cyan) + content['canonical_url'].color(:yellow)

			unless content['verified_domain'].nil?
				if content['verified_domain'] =~ (/http/ || /https/)
					 domain = content['verified_domain']
				else
					domain = "http://#{content['verified_domain']}"
				end
				view << "\nVerified domain\t\t".color(:cyan) + domain.color(:yellow)
			end

			
			view << "\nAccount creation\t".color(:cyan) + @workers.parsed_time(content['created_at']).color(:yellow)
			view << "\nTimeZone\t\t".color(:cyan) + content['timezone'].color(:yellow)
			view << "\nLocale\t\t\t".color(:cyan) + content['locale'].color(:yellow)

			view << "\n\nPosts\t\t\t".color(:cyan) + content['counts']['posts'].to_s.color(:yellow)

			view << "\n\nFollowing\t\t".color(:cyan) + content['counts']['following'].to_s.color(:yellow)
			view << "\nFollowers\t\t".color(:cyan) + content['counts']['followers'].to_s.color(:yellow)
			
			#view << "\nStars\t\t\t".color(:cyan) + content['counts']['stars'].to_s.color(:yellow)

			if content['you_follow']
				view << "\n\nYou follow ".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])
			else
				view << "\n\nYou don't follow ".color(:cyan) + "@#{content['username']}".color(MyConfig.options[:colors][:username])
			end
			if content['follows_you']
				view << "\n" + "@#{content['username']}".color(MyConfig.options[:colors][:username]) + " follows you".color(:cyan)
			else
				view << "\n" + "@#{content['username']}".color(MyConfig.options[:colors][:username]) + " doesn't follow you".color(:cyan)
			end
			if content['you_muted']
				view << "\nYou muted " + "@#{content['username']}".color(MyConfig.options[:colors][:username])
			end
			if content['you_blocked']
				view << "\nYou blocked " + "@#{content['username']}".color(MyConfig.options[:colors][:username])
			end

			#view << "\n\nAvatar URL\t\t".color(:cyan) + content['avatar_image']['url']

			view << "\n\n#{content['description']['text']}\n".color(:magenta) + "\n\n"

			puts view
		end




		def clear_line
			print "\r                                            \n"
		end

		def clear_screen
			puts "\e[H\e[2J"
		end

	end
end