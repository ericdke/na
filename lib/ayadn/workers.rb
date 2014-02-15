module Ayadn
	class Workers

		def build_stream_with_index(data)
			@view = ""
			posts = build_posts(data)
			posts.each do |id,content|
				count = "%03d" % content[:count]
				@view << count.color($config.options[:colors][:index])
				@view << ": ".color($config.options[:colors][:index])
				@view << build_content(content)
			end
			return posts, @view
		end
		def build_stream_without_index(data)
			@view = ""
			posts = build_posts(data)
			posts.each do |id,content|
				@view << content[:id].to_s.color($config.options[:colors][:id]) + " "
				@view << build_content(content)
			end
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
				t.title = "List of users ".color(:cyan) + "#{target}".color(:red) + " is following ".color(:cyan) + "".color(:white)
			end
			users_list = build_users_hash(list)
			build_users_list(users_list, table)
		end

		def build_followers_list(list, target)
			table = Terminal::Table.new do |t|
				t.style = { :width => $config.options[:formats][:table][:width] }
				t.title = "List of users following ".color(:cyan) + "#{target}".color(:red) + "".color(:white)
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
			File.open($config.config[:paths][:home] + "/index", "w") { |f| f.write(posts.to_json) }
		end

		private

		def build_users_list(list, table)
			list.each_with_index do |obj, index|
				# if obj['follows_you']
				# 	fy = "follows back".color(:blue)
				# else
				# 	fy = nil
				# end
				table << [ "@#{obj[:username]} ".color($config.options[:colors][:username]), "#{obj[:name]}" ]
				table << :separator unless index + 1 == list.length
			end
			table
		end

		def build_posts(data)
			posts = {}
			@count = 1
			data.reverse.each do |post|
				name = post['user']['name'] || "(no name)".color(:blue)
				unless post['text'].nil? || post['text'].empty?
					text = colorize_text(post['text'])
				else
					text = "(no text)".color(:blue)
				end
				
				thread_id = post['thread_id']
				
				username = post['user']['username']
				handle = "@" + username
				date = parsed_time(post['created_at'])


				# if post['repost_of']
				# 	is_repost = true
				# 	repost_of = post['repost_of']['id']
				# 	num_reposts = post['repost_of']['num_reposts']
				# else
				# 	is_repost = false
				# end
				# if post['reply_to']
				# 	is_reply = true
				# 	reply_to = post['reply_to']
				# 	num_replies = post['num_replies']
				# else
				# 	is_reply = false
				# 	reply_to = nil
				# 	num_replies = 0
				# end
				mentions = []
				post['entities']['mentions'].each do |m|
					mentions << m['name']
				end
				directed_to = mentions.first
				tags = []
				post['entities']['hashtags'].each do |h|
					tags << h['name']
				end
				links = []
				post['entities']['links'].each do |l|
					links << l['url']
				end
				# annotations_list = post['annotations']
				# unless annotations_list.empty?
				# 	xxx = 0
				# 	annotations_list.each do
				# 		annotation_type = annotations_list[xxx]['type']
				# 		annotation_value = annotations_list[xxx]['value']
				# 		if annotation_type == "net.app.core.checkin" || annotation_type == "net.app.ohai.location"
				# 			# @checkins = true
				# 			# @checkins_name = annotation_value['name']
				# 			# @checkins_address = annotation_value['address']
				# 			# @checkins_address_extended = annotation_value['address_extended'] || ""
				# 			# @checkins_locality = annotation_value['locality'] || ""
				# 			# @checkins_region = annotation_value['region'] || ""
				# 			# @checkins_postcode = annotation_value['postcode'] || ""
				# 			# @checkins_country_code = annotation_value['country_code'] || ""
				# 			# @checkins_website = annotation_value['website'] || ""
				# 			# @checkins_phone = annotation_value['telephone'] || ""
				# 			# if annotation_value['categories']
				# 			# 	unless annotation_value['categories'].empty?
				# 			# 		#@checkins_labels = annotation_value['categories']['labels']
				# 			# 		$logger.debug annotation_value['categories']
				# 			# 	end
				# 			# end
				# 			# @factual_id = annotation_value['factual_id'] || ""
				# 			# @checkins_id = annotation_value['id'] || ""
				# 			# @longitude = annotation_value['longitude'] || ""
				# 			# @latitude = annotation_value['latitude'] || ""
				# 		end
				# 		# if annotation_type == "net.app.core.oembed"
				# 		# 	@checkins_link = annotation_value['embeddable_url']
				# 		# end
				# 		xxx += 1
				# 	end
				# end
				
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
						links: links
					}
				)

				# posts.merge!(
				# 	{ 
				# 		post['id'].to_i => {
				# 			count: @count,
				# 			id: post['id'].to_i,
				# 			thread_id: thread_id.to_i,
				# 			username: post['user']['username'],
				# 			handle: "@" + post['user']['username'],
				# 			name: name,
				# 			date: parsed_time(post['created_at']),
				# 			is_repost: is_repost,
				# 			repost_of: repost_of,
				# 			num_reposts: num_reposts,
				# 			is_reply: is_reply,
				# 			reply_to: reply_to,
				# 			num_replies: num_replies,
				# 			text: text,
				# 			num_stars: post['num_stars'],
				# 			source_name: post['source']['name'],
				# 			has_mentions: has_mentions,
				# 			mentions: mentions,
				# 			directed_to: directed_to,
				# 			tags: tags,
				# 			links: links
				# 			# checkins: {
				# 			# 	checkins_name: @checkins_name,
				# 			# 	checkins_address: @checkins_address,
				# 			# 	checkins_address_extended: @checkins_address_extended,
				# 			# 	checkins_locality: @checkins_locality,
				# 			# 	checkins_region: @checkins_region,
				# 			# 	checkins_postcode: @checkins_postcode,
				# 			# 	checkins_country_code: @checkins_country_code,
				# 			# 	checkins_link: @checkins_link,
				# 			# 	checkins_website: @checkins_website,
				# 			# 	checkins_phone: @checkins_phone,
				# 			# 	checkins_labels: @checkins_labels,
				# 			# 	checkins_id: @checkins_id,
				# 			# 	longitude: @longitude,
				# 			# 	latitude: @latitude,
				# 			# 	factual_id: @factual_id
				# 			# }
				# 		}
				# 	}
				# )

				@count += 1
			end
			posts
		end

		def build_checkins(content)

			#chk = (".".color($config.options[:colors][:dots])) * (content[:checkins][:checkins_name].length || 10)
			#chk << "\n"

			#puts content.inspect

			# content[:checkins].each do |k,v|
			# 	unless v.nil?
			# 		puts v.inspect
			# 		# chk << "#{v}"
			# 		# chk << "\n" 
			# 	end
			# end

			# unless content[:checkins][:checkins_name].nil?
			# 	chk << content[:checkins][:checkins_name]
			# 	chk << "\n"
			# end
			# unless content[:checkins][:checkins_address].nil?
			# 	chk << content[:checkins][:checkins_address]
			# 	chk << "\n"
			# end
			# begin
			# 	unless content[:checkins][:checkins_address_extended].nil?
			# 		chk << content[:checkins][:checkins_address_extended]
			# 		chk << "\n"
			# 	end
			# rescue => e
			# 	$logger.error "No ext. address in checkin post #{content[:id]}\nERROR: #{e.inspect}"
			# end
			# unless content[:checkins][:checkins_locality].nil?
			# 	chk << content[:checkins][:checkins_locality]
			# 	chk << " \n"
			# end
			# unless content[:checkins][:checkins_postcode].nil?
			# 	chk << content[:checkins][:checkins_postcode]
			# 	chk << "\n"
			# end
			# unless content[:checkins][:checkins_region].nil?
			# 	chk << content[:checkins][:checkins_region]
			# 	chk << " \n"
			# end
			# unless content[:checkins][:checkins_country_code].nil?
			# 	chk << content[:checkins][:checkins_country_code]
			# 	#chk << "\n"
			# end
			# begin
			# 	unless content[:checkins][:checkins_phone].nil?
			# 		chk << content[:checkins][:checkins_phone]
			# 		chk << "\n"
			# 	end
			# rescue => e
			# 	$logger.error "No phone in checkin post #{content[:id]}\nERROR: #{e.inspect}"
			# end
			# begin
			# 	unless content[:checkins][:checkins_website].nil?
			# 		chk << content[:checkins][:checkins_website]
			# 		chk << "\n"
			# 	end
			# rescue => e
			# 	$logger.error "No website in checkin post #{content[:id]}\nERROR: #{e.inspect}"
			# end
		end

		def build_content(content)
			view = ""
			view << build_header(content)
			view << "\n"
			view << content[:text]
			view << "\n"
			# view << build_checkins(content) 
			# view << "\n"
			unless content[:links].nil?
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
			header << " "
			header << content[:name].color($config.options[:colors][:name])
			header << " "
			header << content[:date].color($config.options[:colors][:date])
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