module Ayadn
	class API

		def initialize
			@endpoints = Endpoints.new
			@cnx = CNX.new
		end
		
		def get_unified(options)
			url = @endpoints.unified(options)
			get_parsed_response(url)
		end

		def get_checkins(options)
			url = @endpoints.checkins(options)
			get_parsed_response(url)
		end

		def get_global(options)
			url = @endpoints.global(options)
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
			url = @endpoints.trending(options) if explore == :trending
			url = @endpoints.photos(options) if explore == :photos
			url = @endpoints.conversations(options) if explore == :conversations
			get_parsed_response(url)
		end

		def get_mentions(username, options)
			url = @endpoints.mentions(username, options)
			get_parsed_response(url)
		end

		def get_posts(username, options)
			url = @endpoints.posts(username, options)
			get_parsed_response(url)
		end

		def get_whatstarred(username, options)
			url = @endpoints.whatstarred(username, options)
			get_parsed_response(url)
		end

		def get_interactions
			url = @endpoints.interactions
			get_parsed_response(url)
		end

		def get_whoreposted(post_id)
			url = @endpoints.whoreposted(post_id)
			get_parsed_response(url)
		end

		def get_whostarred(post_id)
			url = @endpoints.whostarred(post_id)
			get_parsed_response(url)
		end

		def get_convo(post_id, options)
			url = @endpoints.convo(post_id, options)
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

		def build_list(username, target)
			options = {:count => 200, :before_id => nil}
			big_hash = {}
			loop do
				if target == :followings
					url = @endpoints.followings(username, options)
				elsif target == :followers
					url = @endpoints.followers(username, options)
				elsif target == :muted
					url = @endpoints.muted(options)
				end
				resp = get_parsed_response(url)
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

		private

		def get_raw_response(url)
			@cnx.get_response_from(url)
		end

		def get_parsed_response(url)
			r = JSON.parse(@cnx.get_response_from(url))
			@cnx.check_errors(r['meta'])
			return r
		end

	end
end