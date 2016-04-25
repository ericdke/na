# encoding: utf-8
module Ayadn
  class FilteredPost

  	attr_accessor :input, :is_human, :name, :count, :id, :thread_id, :username, :user_id, :nicerank, :handle, :type, :date, :date_short, :you_starred, :source_name, :source_link, :canonical_url, :tags, :links, :mentions, :directed_to, :checkins, :has_checkins, :is_repost, :repost_of, :original_poster, :raw_text, :text, :is_starred, :num_stars, :num_replies, :is_reply, :reply_to, :num_reposts

  	def initialize post
  		@input = post
  	end
  end
end