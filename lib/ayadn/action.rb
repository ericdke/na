module Ayadn
	class Action

		def initialize
			@api = API.new
			@view = View.new
			MyConfig.load_config
			Logs.create_logger
			Databases.open_databases
		end

		def unified(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_unified(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/unified"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def checkins(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_checkins(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/checkins"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def global(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_global(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/global"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def trending(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_trending(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/trending"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def photos(options)		
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_photos(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/photos"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def conversations(options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_conversations(options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/conversations"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def mentions(username, options)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					stream = get_data_from_response(@api.get_mentions(username, options))
					get_view(stream, options)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/mentions with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def posts(username, options)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					stream = get_data_from_response(@api.get_posts(username, options))
					get_view(stream, options)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/posts with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def interactions
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_interactions)
				@view.clear_screen
				@view.show_interactions(stream)
			rescue => e
				Logs.rec.error "From action/interactions"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def whatstarred(username, options)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					stream = get_data_from_response(@api.get_whatstarred(username, options))
					get_view(stream, options)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/whatstarred with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def whoreposted(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					print Status.downloading
					list = get_data_from_response(@api.get_whoreposted(post_id))
					get_list(:whoreposted, list, post_id)
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/whoreposted with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def whostarred(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					print Status.downloading
					list = get_data_from_response(@api.get_whostarred(post_id))
					get_list(:whostarred, list, post_id)
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/whostarred with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def convo(post_id, options)
			begin
				if post_id.is_integer?
					@view.clear_screen
					print Status.downloading
					stream = get_data_from_response(@api.get_convo(post_id, options))
					get_view(stream, options)
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/convo with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def delete(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					print Status.deleting_post(post_id)
					resp = @api.delete_post(post_id)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.deleted(post_id)
					else
						puts Status.not_deleted(post_id)
					end
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/delete with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def unfollow(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					puts Status.unfollowing(username)
					resp = @api.unfollow(username)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.unfollowed(username)
					else
						puts Status.not_unfollowed(username)
					end
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/unfollow with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def unmute(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					puts Status.unmuting(username)
					resp = @api.unmute(username)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.unmuted(username)
					else
						puts Status.not_unmuted(username)
					end
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/unmute with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def unblock(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					puts Status.unblocking(username)
					resp = @api.unblock(username)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.unblocked(username)
					else
						puts Status.not_unblocked(username)
					end
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/unblock with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def unrepost(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					puts Status.unreposting(post_id)
					resp = @api.unrepost(post_id)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.unreposted(post_id)
					else
						puts Status.not_unreposted(post_id)
					end
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/unrepost with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def unstar(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					puts Status.unstarring(post_id)
					resp = @api.unstar(post_id)
					@view.clear_screen
					if resp['meta']['code'] == 200
						puts Status.unstarred(post_id)
					else
						puts Status.not_unstarred(post_id)
					end
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/unstar with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def hashtag(hashtag)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_hashtag(hashtag))
				get_view(stream)
			rescue => e
				Logs.rec.error "From action/hashtag with args: #{hashtag}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def search(words, options)
			begin
				@view.clear_screen
				print Status.downloading
				stream = get_data_from_response(@api.get_search(words, options))
				get_view(stream, options)
			rescue => e
				Logs.rec.error "From action/search with args: #{words}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def followings(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					list = @api.get_followings(username)
					get_list(:followings, list, username)
					add_to_users_db_from_list(list)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/followings with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def followers(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					list = @api.get_followers(username)
					get_list(:followers, list, username)
					add_to_users_db_from_list(list)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/followers with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def muted
			begin
				@view.clear_screen
				print Status.downloading
				list = @api.get_muted
				get_list(:muted, list, nil)
				add_to_users_db_from_list(list)
			rescue => e
				Logs.rec.error "From action/muted"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def blocked
			begin
				@view.clear_screen
				print Status.downloading
				list = @api.get_blocked
				get_list(:blocked, list, nil)
				add_to_users_db_from_list(list)
			rescue => e
				Logs.rec.error "From action/blocked"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def view_settings
			begin
				@view.clear_screen
				@view.settings
			rescue => e
				Logs.rec.error "From action/settings"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def user_info(username)
			begin
				unless username.empty?
					username = add_arobase_if_absent(username)
					@view.clear_screen
					print Status.downloading
					stream = get_data_from_response(@api.get_user(username))
					get_infos(stream)
				else
					puts Status.error_missing_username
				end
			rescue => e
				Logs.rec.error "From action/user_info with args: #{username}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def post_info(post_id)
			begin
				if post_id.is_integer?
					@view.clear_screen
					print Status.downloading
					@view.clear_screen
					resp = get_data_from_response(@api.get_details(post_id))
					stream = get_data_from_response(@api.get_user("@#{resp['user']['username']}"))
					puts "POST:\n".inverse
					@view.show_simple_post([resp])
					puts "AUTHOR:\n".inverse
					@view.show_user_infos(stream)
				else
					puts Status.error_missing_post_id
				end
			rescue => e
				Logs.rec.error "From action/post_info with args: #{post_id}"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end

		def files(options)
			begin
				@view.clear_screen
				print Status.downloading
				list = @api.get_files_list(options)
				@view.clear_screen
				@view.show_files_list(list)
			rescue => e
				Logs.rec.error "From action/files"
				Logs.rec.error "#{e}"
				global_error(e)
			ensure
				Databases.close_all
			end
		end



		#private

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
				Databases.users[id] = {content_array[0] => content_array[1]}
			end
		end

		def global_error(e)
			puts "\n\nERROR (see #{MyConfig.config[:paths][:log]}/ayadn.log)\n".color(:red)
		end

		def add_arobase_if_absent(username) # expects an array of username(s) and works on the first one
			unless username.first == "me"
				username = username.first.chars.to_a
				username.unshift("@") unless username.first == "@"
			else
				username = "me".chars.to_a
			end
			username.join
		end

	end
end