module Ayadn
	class Stream

		# Depending on context, Stream is a "stream" factory/launcher or an "action" launcher

		def initialize
			@api = API.new
			@view = View.new
			$config = MyConfig.new
			$logger = Logger.new($config.config[:paths][:log] + "/ayadn.log", 'monthly')
			$db = Databases.new
		end

		def unified(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_unified(options))
				get_view(stream, options)
			rescue => e
				$logger.error "From stream/unified"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		def checkins(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_checkins(options))
				get_view(stream, options)
			rescue => e
				$logger.error "From stream/checkins"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		def global(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_global(options))
				get_view(stream, options)
			rescue => e
				$logger.error "From stream/global"
				$logger.error "#{e}"
				global_error(e)
			ensure
				$db.close_all
			end
		end

		def trending(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_trending(options))
			get_view(stream, options)
		end

		def photos(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_photos(options))
			get_view(stream, options)
		end

		def conversations(options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_conversations(options))
			get_view(stream, options)
		end

		def mentions(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_mentions(username, options))
			get_view(stream, options)
		end

		def posts(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_posts(username, options))
			get_view(stream, options)
		end

		def whatstarred(username, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_whatstarred(username, options))
			get_view(stream, options)
		end

		def interactions
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_interactions)
			@view.clear_screen
			@view.show_interactions(stream)
		end

		def whoreposted(post_id)
			@view.clear_screen
			print Status.downloading
			list = get_data_from_response(@api.get_whoreposted(post_id))
			get_list(:whoreposted, list, post_id)
			add_to_users_db_from_list(list)
		end

		def whostarred(post_id)
			@view.clear_screen
			print Status.downloading
			list = get_data_from_response(@api.get_whostarred(post_id))
			get_list(:whostarred, list, post_id)
			add_to_users_db_from_list(list)
		end

		def convo(post_id, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_convo(post_id, options))
			get_view(stream, options)
		end

		def hashtag(hashtag)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_hashtag(hashtag))
			get_view(stream)
		end

		def search(words, options)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_search(words, options))
			get_view(stream, options)
		end

		def followings(username)
			@view.clear_screen
			print Status.downloading
			list = @api.get_followings(username)
			get_list(:followings, list, username)
			add_to_users_db_from_list(list)
		end

		def followers(username)
			@view.clear_screen
			print Status.downloading
			list = @api.get_followers(username)
			get_list(:followers, list, username)
			add_to_users_db_from_list(list)
		end

		def muted
			@view.clear_screen
			print Status.downloading
			list = @api.get_muted
			get_list(:muted, list, nil)
			add_to_users_db_from_list(list)
		end

		def blocked
			@view.clear_screen
			print Status.downloading
			list = @api.get_blocked
			get_list(:blocked, list, nil)
			add_to_users_db_from_list(list)
		end

		def view_settings
			@view.clear_screen
			@view.settings
		end

		def user(username)
			@view.clear_screen
			print Status.downloading
			stream = get_data_from_response(@api.get_user(username))
			get_infos(stream)
		end

		def details(post_id)
			@view.clear_screen
			print Status.downloading
			@view.clear_screen
			resp = get_data_from_response(@api.get_details(post_id))
			stream = get_data_from_response(@api.get_user("@#{resp['user']['username']}"))
			puts "POST:\n".inverse
			@view.show_simple_post([resp])
			puts "AUTHOR:\n".inverse
			@view.show_user_infos(stream)
		end

		def files(options)
			@view.clear_screen
			print Status.downloading
			list = @api.get_files_list(options)
			@view.clear_screen
			@view.show_files_list(list)
		end



		private

		def get_data_from_response(response)
			response['data']
		end

		def get_view(stream, options = {})
			@view.clear_screen
			if options[:index]
				@view.show_posts_with_index(stream)
			else
				@view.show_posts(stream)
			end
		end

		def get_simple_view(stream)
			@view.clear_screen
			@view.show_simple_stream(stream)
		end

		def get_infos(stream)
			@view.clear_screen
			@view.show_user_infos(stream)
		end

		def get_list(what, list, target)
			@view.clear_screen
			case what
			when :whoreposted
				@view.show_list_reposted(list, target)
			when :whostarred
				@view.show_list_starred(list, target)
			when :followings
				@view.show_list_followings(list, target)
			when :followers
				@view.show_list_followers(list, target)
			when :muted
				@view.show_list_muted(list)
			when :blocked
				@view.show_list_blocked(list)
			end
		end

		def add_to_users_db_from_list(list)
			list.each do |id, content_array|
				$db.users[id] = {content_array[0] => content_array[1]}
			end
		end

		def global_error(e)
			puts "\n\nERROR (see #{$config.config[:paths][:log]}/ayadn.log)\n".color(:red)
		end

		def add_arobase_if_absent(username)
			unless username.first == "me"
				username = username.first.chars.to_a
				username.unshift("@") unless username.first == "@"
			else
				username = "me".chars.to_a
			end
			username
		end

	end
end