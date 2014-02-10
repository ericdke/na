module Ayadn
	class View

		def view_stream(data)
			posts = []
			data.each do |post|
				view = "\n"
				view << build_header(post)
				view << build_text(post)
				view << "\n"
				posts << view + "\n"
			end
			posts
		end

		def build_header(post)
			header = ""
			header << post['id']
			header << " "
			header << "@#{post['user']['username']}"
			header << " "
			header << "\n"
			header
		end

		def build_text(post)
			post['text'] unless post['text'].nil?
		end

		def show_posts_with_index(posts_array)
			@post_index = 1
			posts_array.each do |post|
				puts @post_index
				puts post
				@post_index += 1
			end
		end

	end
end