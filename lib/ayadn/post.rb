module Ayadn
	class Post
		require "readline"

		def post(args)
			unless text_is_empty?(args)
				send(args.join(" "))
			else
				error_text_empty
			end
		end

		def text_is_empty?(args)
			args.empty? || args[0] == ""
		end

		def send(post)
			# @api...
			puts "test: #{post}"
		end

		def compose
			#test
			post = []
			while buf = Readline.readline("> ", true)
			  post << buf
			end
			puts post.inspect
			puts post.join("\n")
			# ...
			# send(post)
		end

		def error_text_empty
			puts "\n\nYou must provide some text. See 'ayadn help post' for help.\n\n".color(:red)
			Logs.rec.warn "'ayadn post' invoked without text"
		end

	end
end
