module Ayadn
	class API
		
		def get_unified(options)
			url = Endpoints.unified(options)
			get_parsed_response(url)
		end

		def get_checkins(options)
			url = Endpoints.checkins(options)
			get_parsed_response(url)
		end

		def get_global(options)
			url = Endpoints.global(options)
			get_parsed_response(url)
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
			get_parsed_response(url)
		end

		def get_mentions(username, options)
			url = Endpoints.mentions(username, options)
			get_parsed_response(url)
		end

		def get_posts(username, options)
			url = Endpoints.posts(username, options)
			get_parsed_response(url)
		end

		def get_whatstarred(username, options)
			url = Endpoints.whatstarred(username, options)
			get_parsed_response(url)
		end

		def get_interactions
			url = Endpoints.interactions
			get_parsed_response(url)
		end

		def get_whoreposted(post_id)
			url = Endpoints.whoreposted(post_id)
			get_parsed_response(url)
		end

		def get_whostarred(post_id)
			url = Endpoints.whostarred(post_id)
			get_parsed_response(url)
		end

		def get_convo(post_id, options)
			url = Endpoints.convo(post_id, options)
			get_parsed_response(url)
		end

		def get_hashtag(hashtag)
			url = Endpoints.hashtag(hashtag)
			get_parsed_response(url)
		end

		def get_search(words, options)
			url = Endpoints.search(words, options)
			get_parsed_response(url)
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

				#empty_data if resp['data'].empty?

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
			url = Endpoints.user(username)
			get_parsed_response(url)
		end

		def get_details(post_id)
			url = Endpoints.single_post(post_id)
			get_parsed_response(url)
		end

		def get_files_list(options)
			url = Endpoints.files_list(options)
			get_parsed_response(url)
		end

		#private

		def get_raw_response(url)
			CNX.get_response_from(url)
		end

		def get_parsed_response(url)
			JSON.parse(CNX.get_response_from(url))
		end

	end
end