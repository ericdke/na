module Ayadn
	class Workers

		def build_stream(data)
			posts = {}
			@count = 1
			data.reverse.each do |post|
				view = build_header(post)
				view << "\n"
				view << build_text(post)
				view << "\n\n"
				posts.merge!({ @count => 
					{post['id'].to_i => view}})
				@count += 1
			end
			posts
		end

		def build_header(post)
			header = ""
			header << "@#{post['user']['username']}".color(:green)
			header << " "
			header << ("#{post['user']['name']}".color(:yellow) + " ") if post['user']['name']
			header << parsed_time(post['created_at']).color(:cyan)
			header << "\n"
			header
		end

		def build_text(post)
			post['text'] unless post['text'].nil?
		end

		def parsed_time(string)
			return "#{string[0...10]} #{string[11...19]}"
		end

	end
end