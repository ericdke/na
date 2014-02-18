module Ayadn
	class Workers

		def build_stream_with_index(data) #expects an array
			@view = ""
			posts = build_posts(data.reverse)
			posts.each do |id,content|
				count = "%03d" % content[:count]
				@view << count.color($config.options[:colors][:index])
				@view << ": ".color($config.options[:colors][:index])
				@view << build_content(content)
			end
			return posts, @view
		end
		def build_stream_without_index(data) #expects an array
			@view = ""
			posts = build_posts(data.reverse)
			posts.each do |id,content|
				@view << content[:id].to_s.color($config.options[:colors][:id]) + " "
				@view << build_content(content)
			end
			# xxx = ap posts
			# exit
			@view
		end


		def build_interactions_stream(data)
			inter = ""
			data.reverse.each do |event|
				users_array = []
				inter << "#{parsed_time(event['event_date'])}".color($config.options[:colors][:date])
				inter << " => "
				event['users'].each do |u|
					users_array << "@" + u['username']
				end
				case event['action']
					when "follow", "unfollow"
						inter << "#{users_array.join(", ")} ".color(:magenta)
						inter << "#{event['action']}ed you".color(:green)
					when "mute", "unmute"
						inter << "#{users_array.join(", ")} ".color(:magenta)
						inter << "#{event['action']}d you".color(:green)
					when "star", "unstar"
						inter << "#{users_array.join(", ")} ".color(:magenta)
						inter << "#{event['action']}red post #{event['objects'][0]['id']}".color(:green)
					when "repost", "unrepost"
						inter << "#{users_array.join(", ")} ".color(:magenta)
						inter << "#{event['action']}ed post ".color(:green)
						inter << "#{event['objects'][0]['id']}".color(:red)
					when "reply"
						inter << "#{users_array.join(", ")} ".color(:magenta)
						inter << "replied to post ".color(:green)
						inter << "#{event['objects'][0]['id']}".color(:red)
					when "welcome"
						inter << "App.net ".color(:cyan)
						inter << "welcomed ".color(:green)
						inter << "you!".color(:yellow)
				end
				inter << "\n\n"
			end
			inter
		end

		def build_reposted_list(list, target)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "List of users who reposted post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
			end
			build_users_list(list, table)
		end

		def build_starred_list(list, target)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "List of users who starred post ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
			end
			build_users_list(list, table)
		end

		def build_followings_list(list, target)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				if target == "me"
					t.title = "List of users you're following".color(:cyan) + "".color(:white)
				else
					t.title = "List of users ".color(:cyan) + "#{target}".color(:red) + " is following ".color(:cyan) + "".color(:white)
				end
			end
			users_list = build_users_hash(list)
			build_users_list(users_list, table)
		end

		def build_followers_list(list, target)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				if target == "me"
					t.title = "List of your followers".color(:cyan) + "".color(:white)
				else
					t.title = "List of users following ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
				end
			end
			users_list = build_users_hash(list)
			build_users_list(users_list, table)
		end

		def build_muted_list(list)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "List of users you muted".color(:cyan) + "".color(:white)
			end
			users_list = build_users_hash(list)
			build_users_list(users_list, table)
		end

		def build_blocked_list(list)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "List of users you blocked".color(:cyan) + "".color(:white)
			end
			users_list = build_users_hash(list)
			build_users_list(users_list, table)
		end

		def build_users_hash(list)
			users_list = []
			list.each do |key, value|
				users_list << {:username => value[0], :name => value[1], :you_follow => value[2], :follows_you => value[3]}
			end
			users_list
		end

		def save_indexed_posts(posts)
			begin
				File.open($config.config[:paths][:pagination] + "/index", "w") { |f| f.write(posts.to_json) }	
			rescue => e
				$logger.error "From workers/save_indexed_posts: #{e}"
			end
		end

		#private

		def build_users_list(list, table)
			list.each_with_index do |obj, index|
				table << [ "@#{obj[:username]} ".color($config.options[:colors][:username]), "#{obj[:name]}" ]
				table << :separator unless index + 1 == list.length
			end
			table
		end

		def build_posts(data)
			# builds a hash of hashes, each hash is a normalized post with post id as a key
			posts = {}
			@count = 1
			data.each do |post|
				name = post['user']['name'] || "(no name)"
				unless post['text'].nil? || post['text'].empty?
					text = colorize_text(post['text'])
				else
					text = "(no text)"
				end
				
				thread_id = post['thread_id']
				
				username = post['user']['username']
				handle = "@" + username
				date = parsed_time(post['created_at'])

				if post['source']['name']
					source = post['source']['name']
				else
					source = "(unknown)"
				end

				if post['you_starred']
					you_starred = true
				else
					you_starred = false
				end
				unless post['num_stars'].nil? || post['num_stars'] == 0
					is_starred = true
					num_stars = post['num_stars']
				else
					is_starred = false
					num_stars = 0
				end
				if post['repost_of']
					is_repost = true
					repost_of = post['repost_of']['id']
					num_reposts = post['repost_of']['num_reposts']
				else
					is_repost = false
					repost_of = nil
					num_reposts = 0
				end
				if post['reply_to']
					is_reply = true
					reply_to = post['reply_to']
					num_replies = post['num_replies']
				else
					is_reply = false
					reply_to = nil
					num_replies = 0
				end
				mentions = []
				post['entities']['mentions'].each do |m|
					mentions << m['name']
				end
				directed_to = mentions.first || false
				tags = []
				post['entities']['hashtags'].each do |h|
					tags << h['name']
				end
				links = []
				post['entities']['links'].each do |l|
					links << l['url']
				end
				annotations_list = post['annotations']
				@has_checkins = false
				@checkins = {}
				unless annotations_list.nil?
					xxx = 0
					annotations_list.each do
						annotation_type = annotations_list[xxx]['type']
						annotation_value = annotations_list[xxx]['value']
						case annotation_type
						when "net.app.core.checkin", "net.app.ohai.location"
							@has_checkins = true
							@checkins = {
								name: annotation_value['name'],
								address: annotation_value['address'],
								address_extended: annotation_value['address_extended'],
								locality: annotation_value['locality'],
								postcode: annotation_value['postcode'],
								country_code: annotation_value['country_code'],
								website: annotation_value['website'],
								telephone: annotation_value['telephone']
							}
							unless annotation_value['categories'].nil?
								unless annotation_value['categories'][0].nil?
						 			@checkins.merge!({
						 				categories: annotation_value['categories'][0]['labels'].join(", ")
						 				})
						 		end
							end
							unless annotation_value['factual_id'].nil?
								@checkins.merge!({
						 			factual_id: annotation_value['factual_id']
						 			})
							end
							unless annotation_value['longitude'].nil?
								@checkins.merge!({
						 			longitude: annotation_value['longitude'],
						 			latitude: annotation_value['latitude']
						 			})
							end
						when "net.app.core.oembed"
							@checkins.merge!({
						 			embeddable_url: annotation_value['embeddable_url']
						 			})
				 		end

				 		xxx += 1
					end
				end
				
				posts.merge!(
					post['id'].to_i => {
						count: @count,
						id: post['id'].to_i,
						name: name,
						username: username,
						handle: handle,
						date: date,
						text: text,
						thread_id: thread_id,
						directed_to: directed_to,
						mentions: mentions,
						tags: tags,
						links: links,
						is_repost: is_repost,
						repost_of: repost_of,
						num_reposts: num_reposts,
						is_reply: is_reply,
						reply_to: reply_to,
						num_replies: num_replies,
						is_starred: is_starred,
						you_starred: you_starred,
						num_stars: num_stars,
						source_name: source,
						has_checkins: @has_checkins,
						checkins: @checkins
					}
				)

				@count += 1
			end
			posts
		end

		def build_checkins(content)
			unless content[:checkins][:name].nil?
				num_dots = content[:checkins][:name].length
			else
				num_dots = 10
			end
			hd = (".".color($config.options[:colors][:dots])) * num_dots
			hd << "\n"
			formatted = { header: hd }
			content[:checkins].each do |key, val|
				unless val.nil? || !val
					case key
					when :name
						formatted.merge!({
							name: "#{val}"
						})
					when :address
						formatted.merge!({
							address: "#{val}"
						})
					when :address_extended
						formatted.merge!({
							address_extended: "#{val}"
						})
					when :postcode
						formatted.merge!({
							postcode: "#{val}"
						})
					when :locality
						formatted.merge!({
							locality: "#{val}"
						})
					when :country_code
						formatted.merge!({
							country_code: "#{val}"
						})
					when :website
						formatted.merge!({
							website: "#{val}"
						})
					when :telephone
						formatted.merge!({
							telephone: "#{val}"
						})
					when :categories
						formatted.merge!({
							categories: "#{val}"
						})

					end
				end
			end
			
			chk = formatted[:header]
			unless formatted[:name].nil?
				chk << formatted[:name].color($config.options[:colors][:dots])
				chk << "\n"
			end
			unless formatted[:address].nil?
				chk << formatted[:address]
				chk << "\n"
			end
			if formatted.has_key?(:address_extended)
				unless formatted[:address_extended].nil?
					chk << formatted[:address_extended]
					chk << "\n"
				end
			end
			if formatted.has_key?(:country_code)
				cc = "(#{formatted[:country_code]})".upcase
			else
				cc = ""
			end
			if formatted.has_key?(:postcode)
				if formatted.has_key?(:locality)
					chk << "#{formatted[:postcode]}, #{formatted[:locality]} #{cc}"
					chk << "\n"
				end
			else
				if formatted.has_key?(:locality)
					chk << "#{formatted[:locality]} #{cc}"
					chk << "\n"
				end
			end
			if formatted.has_key?(:website)
				chk << "#{formatted[:website]}"
				chk << "\n"
			end
			if formatted.has_key?(:telephone)
				chk << formatted[:telephone]
				chk << "\n"
			end
			if formatted.has_key?(:categories)
				chk << formatted[:categories]
				chk << "\n"
			end

			chk.chomp
		end

		def build_content(content)
			view = ""
			view << build_header(content)
			view << "\n"
			view << content[:text]
			view << "\n"
			if content[:has_checkins]
				view << build_checkins(content) 
				view << "\n"
			end
			unless content[:links].empty?
				view << "\n"
				content[:links].each do |link|
					view << link.color($config.options[:colors][:link])
					view << "\n"
				end
			end
			view << "\n\n"
		end

		def build_header(content)
			header = ""
			header << content[:handle].color($config.options[:colors][:username])
			if $config.options[:timeline][:show_real_name]
				header << " "
				header << content[:name].color($config.options[:colors][:name])
			end
			if $config.options[:timeline][:show_date]
				header << " "
				header << content[:date].color($config.options[:colors][:date])
			end
			if $config.options[:timeline][:show_source]
				header << " "
				header << "[#{content[:source_name]}]".color($config.options[:colors][:source])
			end
			if $config.options[:timeline][:show_symbols]
				header << " <".color($config.options[:colors][:symbols]) if content[:is_reply]
				header << " #{content[:num_stars]}*".color($config.options[:colors][:symbols]) if content[:is_starred]
				header << " >".color($config.options[:colors][:symbols]) if content[:num_replies] > 0
				header << " #{content[:num_reposts]}x".color($config.options[:colors][:symbols]) if content[:is_repost]
			end
			header << "\n"
		end

		

		def parsed_time(string)
			"#{string[0...10]} #{string[11...19]}"
		end

		def colorize_text(text)
			content = Array.new
			@hashtag_color = $config.options[:colors][:hashtags]
			@mention_color = $config.options[:colors][:mentions]
			#for word in text.split(" ") do
			#for word in text.split(/(\?|\!)/) do
			for word in text.scan(/^.+[\r\n]*/) do
				if word =~ /#\w+/
                    content.push(word.gsub(/#([A-Za-z0-9_]{1,255})(?![\w+])/, '#\1'.color(@hashtag_color)))
				elsif word =~ /@\w+/ 
                    content.push(word.gsub(/@([A-Za-z0-9_]{1,20})(?![\w+])/, '@\1'.color(@mention_color)))
				else
					content.push(word)
				end
			end
			content.join()
		end

	end
end