module Ayadn
	class Workers

		def build_stream(data)
			posts = {}
			data.reverse.each do |post|
				view = build_header(post)
				view << build_text(post)
				view << "\n\n"
				posts.merge!({ post['id'].to_i => view })
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