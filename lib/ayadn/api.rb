module Ayadn
	class API

		def get_unified(options)
			resp = get_parsed_response(Endpoints.unified(options))
			check_error(resp)
			resp
		end

		def get_checkins(options)
			resp = get_parsed_response(Endpoints.checkins(options))
			check_error(resp)
			resp
		end

		def get_global(options)
			resp = get_parsed_response(Endpoints.global(options))
			check_error(resp)
			resp
		end

		def get_trending(options)
			get_explore(:trending, options)
		end
		def get_photos(options)
			get_explore(:photos, options)
		end
		def get_conversations(options)
			get_explore(:conversations, options)
		end

		def get_explore(explore, options)
			url = Endpoints.trending(options) if explore == :trending
			url = Endpoints.photos(options) if explore == :photos
			url = Endpoints.conversations(options) if explore == :conversations
			resp = get_parsed_response(url)
			check_error(resp)
			resp
		end

		def get_mentions(username, options)
			resp = get_parsed_response(Endpoints.mentions(username, options))
			check_error(resp)
			resp
		end

		def get_posts(username, options)
			resp = get_parsed_response(Endpoints.posts(username, options))
			check_error(resp)
			resp
		end

		def get_whatstarred(username, options)
			resp = get_parsed_response(Endpoints.whatstarred(username, options))
			check_error(resp)
			resp
		end

		def get_interactions
			resp = get_parsed_response(Endpoints.interactions)
			check_error(resp)
			resp
		end

		def get_whoreposted(post_id)
			resp = get_parsed_response(Endpoints.whoreposted(post_id))
			check_error(resp)
			resp
		end

		def get_whostarred(post_id)
			resp = get_parsed_response(Endpoints.whostarred(post_id))
			check_error(resp)
			resp
		end

		def get_convo(post_id, options)
			resp = get_parsed_response(Endpoints.convo(post_id, options))
			check_error(resp)
			resp
		end

		def get_hashtag(hashtag)
			resp = get_parsed_response(Endpoints.hashtag(hashtag))
			check_error(resp)
			resp
		end

		def get_search(words, options)
			resp = get_parsed_response(Endpoints.search(words, options))
			check_error(resp)
			resp
		end

		def get_followings(username)
			build_list(username, :followings)
		end

		def get_followers(username)
			build_list(username, :followers)
		end

		def get_muted
			build_list(nil, :muted)
		end

		def get_blocked
			build_list(nil, :blocked)
		end

		def get_raw_list(username, target)
			options = {:count => 200, :before_id => nil}
			big = []
			loop do
				case target
				when :followings
					url = Endpoints.followings(username, options)
				when :followers
					url = Endpoints.followers(username, options)
				when :muted
					url = Endpoints.muted(options)
				when :blocked
					url = Endpoints.blocked(options)
				end
				resp = get_parsed_response(url)
				check_error(resp)
				big << resp
				break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
				options = {:count => 200, :before_id => resp['meta']['min_id']}
			end
			big
		end

		def build_list(username, target)
			options = {:count => 200, :before_id => nil}
			big_hash = {}
			loop do
				case target
				when :followings
					url = Endpoints.followings(username, options)
				when :followers
					url = Endpoints.followers(username, options)
				when :muted
					url = Endpoints.muted(options)
				when :blocked
					url = Endpoints.blocked(options)
				end

				resp = get_parsed_response(url)
				check_error(resp)

				users_hash = {}
				resp['data'].each do |item|
					users_hash[item['id']] = [item['username'], item['name'], item['you_follow'], item['follows_you']]
				end
				big_hash.merge!(users_hash)
				break if resp['meta']['min_id'] == nil
				options = {:count => 200, :before_id => resp['meta']['min_id']}
			end
			big_hash
		end

		def get_user(username)
			resp = get_parsed_response(Endpoints.user(username))
			check_error(resp)
			resp
		end

		def get_details(post_id, options)
			resp = get_parsed_response(Endpoints.single_post(post_id, options))
			check_error(resp)
			resp
		end

		def get_files_list(options)
			resp = get_parsed_response(Endpoints.files_list(options))
			check_error(resp)
			resp
		end

		def star(post_id)
			JSON.parse(CNX.post(Endpoints.star(post_id)))
		end

		def follow(post_id)
			JSON.parse(CNX.post(Endpoints.follow(post_id)))
		end

		def mute(post_id)
			JSON.parse(CNX.post(Endpoints.mute(post_id)))
		end

		def block(username)
			JSON.parse(CNX.post(Endpoints.block(username)))
		end

		def repost(post_id)
			JSON.parse(CNX.post(Endpoints.repost(post_id)))
		end

		def delete_post(post_id)
			JSON.parse(CNX.delete(Endpoints.delete_post(post_id)))
		end

		def unstar(post_id)
			JSON.parse(CNX.delete(Endpoints.star(post_id)))
		end

		def unfollow(username)
			JSON.parse(CNX.delete(Endpoints.follow(username)))
		end

		def unmute(username)
			JSON.parse(CNX.delete(Endpoints.mute(username)))
		end

		def unblock(username)
			JSON.parse(CNX.delete(Endpoints.block(username)))
		end

		def unrepost(post_id)
			resp = JSON.parse(CNX.delete(Endpoints.repost(post_id)))
			check_error(resp)
			if resp['data']['repost_of']
				JSON.parse(CNX.delete(Endpoints.repost(resp['data']['repost_of']['id'])))
			else
				resp
			end
		end

		def get_channels
			options = {:count => 200, :recent_message => 1, :annotations => 1, :before_id => nil}
			get_parsed_response(Endpoints.channels(options))
			# big = []
			# loop do
			# 	resp = get_parsed_response(Endpoints.channels(options))
			# 	check_error(resp)
			# 	big << resp
			# 	break if resp['meta']['min_id'] == nil || resp['meta']['more'] == false
			# 	options = {:count => 200, :before_id => resp['meta']['min_id']}
			# end
			# big
		end

		def get_messages(channel_id, options)
			get_parsed_response(Endpoints.messages(channel_id, options))
		end

		def self.check_http_error(resp)
			unless resp.code == 200
				raise "#{resp}"
			end
		end

		def check_error(res)
			if res['meta']['code'] == 200
				res
			else
				Logs.rec.error "From api/check http response"
				# if res['meta']['code'] == 404
				# 	puts Status.not_found
				# end
				raise("#{res}")
			end
		end

		def empty_data
			puts "\e[H\e[2J"
			#puts Status.empty_list
			raise Status.empty_list
		end

		def get_raw_response(url)
			CNX.get_response_from(url)
		end

		def get_parsed_response(url)
			JSON.parse(CNX.get_response_from(url))
		end

	end
end
