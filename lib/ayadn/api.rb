module Ayadn
	class API
		def initialize
			@endpoints = Endpoints.new
			@cnx = CNX.new
		end
		def get_unified(options)
			@url = @endpoints.unified(options)
			response = @cnx.get_response_from(@url)
			# TODO: parse json response and put every post in a hash
			# {post_id => {:text => "", :user_name => "", etc}, {post_id => {:text => "", :user_name => "", etc}}
			puts response.inspect
		end
	end
end