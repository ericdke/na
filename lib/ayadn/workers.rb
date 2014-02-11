module Ayadn
	class Workers

		def build_stream_with_index(data)
			@view = ""
			posts = build_posts(data)
			posts.each do |id,content|
				count = "%03d" % content[:count]
				@view << count.color(:red)
				@view << ": ".color(:red)
				#@view << content[:id].to_s.color(:green)
				@view << build_content(content)
			end
			return posts, @view
		end
		def build_stream_without_index(data)
			@view = ""
			posts = build_posts(data)
			posts.each do |id,content|
				@view << content[:id].to_s.color(:red) + " "
				@view << build_content(content)
			end
			@view
		end

		private

		def build_posts(data)
			posts = {}
			@count = 1
			data.reverse.each do |post|
				text = post['text'] || ""
				thread_id = post['thread_id'] || nil
				name = post['user']['name'] || ""
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
				directed_to = mentions.first || nil
				has_mentions = true
				if mentions.empty?
					has_mentions = false
					mentions = nil
				end
				tags = []
				post['entities']['hashtags'].each do |h|
					tags << h['name']
				end
				tags = nil if tags.empty?
				links = []
				post['entities']['links'].each do |l|
					links << l['url']
				end
				links = nil if links.empty?
				annotations_list = post['annotations']
				if annotations_list != nil
					xxx = 0
					annotations_list.each do
						annotation_type = annotations_list[xxx]['type']
						annotation_value = annotations_list[xxx]['value']
						if annotation_type == "net.app.core.checkin" || annotation_type == "net.app.ohai.location"
							@checkins = true
							@checkins_name = annotation_value['name']
							@checkins_address = annotation_value['address']
							@checkins_address_extended = annotation_value['address_extended']
							@checkins_locality = annotation_value['locality']
							@checkins_region = annotation_value['region']
							@checkins_postcode = annotation_value['postcode']
							@checkins_country_code = annotation_value['country_code']
							@checkins_website = annotation_value['website']
							@checkins_phone = annotation_value['telephone']
							@checkins_labels = annotation_value['categories']['labels']
							@factual_id = annotation_value['factual_id']
							@checkins_id = annotation_value['id']
							@longitude = annotation_value['longitude']
							@latitude = annotation_value['latitude']
						end
						if annotation_type == "net.app.core.oembed"
							@checkins_link = annotation_value['embeddable_url']
						end
						xxx += 1
					end
				end
				
				posts.merge!(
					{ 
						post['id'].to_i => {
							count: @count,
							id: post['id'].to_i,
							thread_id: thread_id.to_i,
							username: post['user']['username'],
							handle: "@" + post['user']['username'],
							name: name,
							date: parsed_time(post['created_at']),
							is_repost: is_repost,
							repost_of: repost_of,
							num_reposts: num_reposts,
							is_reply: is_reply,
							reply_to: reply_to,
							num_replies: num_replies,
							text: text,
							num_stars: post['num_stars'],
							source_name: post['source']['name'],
							has_mentions: has_mentions,
							mentions: mentions,
							directed_to: directed_to,
							tags: tags,
							links: links,
							has_checkins: @checkins || false,
							checkins: {
								checkins_name: @checkins_name || nil,
								checkins_address: @checkins_address || nil,
								checkins_address_extended: @checkins_address_extended || nil,
								checkins_locality: @checkins_locality || nil,
								checkins_region: @checkins_region || nil,
								checkins_postcode: @checkins_postcode || nil,
								checkins_country_code: @checkins_country_code || nil,
								checkins_link: @checkins_link || nil,
								checkins_website: @checkins_website || nil,
								checkins_phone: @checkins_phone || nil,
								checkins_labels: @checkins_labels || nil,
								checkins_id: @checkins_id || nil,
								longitude: @longitude || nil,
								latitude: @latitude || nil,
								factual_id: @factual_id || nil
							}
						}
					}
				)

				@count += 1
			end
			posts
		end

		def build_content(content)
			view = ""
			view << build_header(content)
			view << "\n"
			view << content[:text]
			view << "\n"
			view << "\n" if !content[:links].empty?
			content[:links].each do |link|
				view << link.color(:magenta)
				view << "\n"
			end
			view << "\n\n"
			view
		end

		def build_header(content)
			header = ""
			header << content[:handle].color(:green)
			header << " "
			header << content[:name].color(:yellow)
			header << " "
			header << content[:date].color(:cyan)
			header << "\n"
			header
		end

		def parsed_time(string)
			return "#{string[0...10]} #{string[11...19]}"
		end

	end
end