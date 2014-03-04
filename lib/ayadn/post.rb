module Ayadn
	class Post

		def post(args)
			unless text_is_empty?(args)
				send_post(args.join(" "))
			else
				error_text_empty
			end
		end

		def send_post(text)
			url = Endpoints::POSTS_URL + "?include_post_annotations=1&access_token=#{Ayadn::MyConfig.user_token}"
			payload = payload_basic(text)
			resp = CNX.post(url, payload)
			puts resp
		end

		def text_is_empty?(args)
			args.empty? || args[0] == ""
		end

		def reply(post_id)
			# extract mentions
			# post = compose
			# post = mention + post + (other mentions)
			# prepare object
			# send
		end

		def compose
			case MyConfig.config[:platform]
			when /mswin|mingw|mingw32|cygwin/
				post = classic
			else
				require "readline"
				post = readline # later, text should be .join("\n")
			end
			post
		end

		def readline
			puts "\nType your text. [CTRL+D] to validate, [CTRL+C] to cancel.\n\n"
			post = []
			begin
				while buffer = Readline.readline("> ")
				  post << buffer
				end
			rescue Interrupt
				#temp
				Logs.rec.warn "Write post: canceled."
				abort("Canceled.")
			end
			post
		end

		def classic
			#STDIN ...
			#[post]
		end



		def error_text_empty
			puts "\n\nYou must provide some text. See 'ayadn help post' for help.\n\n".color(:red)
			Logs.rec.warn "'ayadn post' invoked without text"
		end

		def annotations
			[
				{
				"type" => "com.ayadn.client",
				"value" => {
    			"+net.app.core.user" => {
	      			"user_id" => "@ayadn",
	      			"format" => "basic"
	    			}
      		}
				},
				{
				"type" => "com.ayadn.client",
				"value" => { "url" => "http://ayadn-app.net" }
				},
				"type" => "com.ayadn.client",
				"value" => { "version" => "#{MyConfig.config[:version]}" }
			]
		end

		def entities
			{
				"parse_markdown_links" => true,
				"parse_links" => true
			}
		end

		def payload_basic(text)
			{
				"text" => text,
				"entities" => entities,
				"annotations" => annotations
			}
		end

		def payload_reply(data) #data should be a struct
			{
				"text" => data.text,
				"reply_to" => data.replyto,
				"entities" => data.entities,
				"annotations" => data.annotations
			}
		end









	end
end
