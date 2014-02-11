module Ayadn
	class Workers

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
				tags = []
				post['entities']['hashtags'].each do |h|
					tags << h['name']
				end
				
				posts.merge!(
					{ 
						post['id'].to_i => {
							count: @count,
							id: post['id'].to_i,
							thread_id: thread_id,
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
							mentions: mentions,
							tags: tags
						}
					}
				)

				@count += 1
			end
			posts
		end

		# def build_stream(data)

		# 	view = build_header(post)
		# 	view << "\n"
		# 	view << text
		# 	view << "\n\n"
			
			
		# end

		def build_header(post)
			header = ""
			header << "@#{post['user']['username']}".color(:green)
			header << " "
			header << ("#{post['user']['name']}".color(:yellow) + " ") if post['user']['name']
			header << parsed_time(post['created_at']).color(:cyan)
			header << "\n"
			header
		end

		def parsed_time(string)
			return "#{string[0...10]} #{string[11...19]}"
		end

	end
end