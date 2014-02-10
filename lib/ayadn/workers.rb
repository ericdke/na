module Ayadn
	class Workers

		def build_stream(data)
			posts = {}
			@count = 1
			data.reverse.each do |post|
				view = build_header(post)
				view << build_text(post)
				view << "\n\n"
				posts.merge!({ @count => {post['id'].to_i => view} })
				@count += 1
			end
			posts
		end

		def build_header(post)
			header = ""
			header << post['id'] + " "
			header << "@#{post['user']['username']}".color(:green)
			header << " "
			header << "\n"
			header
		end

		def build_text(post)
			post['text'] unless post['text'].nil?
		end

	end
end