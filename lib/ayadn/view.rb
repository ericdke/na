module Ayadn
	class View

		def view_stream(data)
			view = ""
			data.each do |post|
				view << "\n"
				view << build_header(post)
				view << build_text(post)
				view << "\n"
			end
			view << "\n"
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

	end
end