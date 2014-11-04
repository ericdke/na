# encoding: utf-8
module Ayadn
  class NiceRank

    attr_reader :store

    def initialize
      @url = 'http://api.nice.social/user/nicerank?ids='
      @store = {}
    end

    def get_posts_day ids
      resp = JSON.parse(CNX.get("#{@url}#{ids.join(',')}&show_details=Y"))
      if resp.nil? || resp['meta']['code'] != 200
        []
      else
        resp['data'].map do |obj|
          pday = obj['user']['posts_day'] == -1 ? 0 : obj['user']['posts_day']
          {
            id: obj['user_id'],
            posts_day:pday.round(2)
          }
        end
      end
    end

    def from_ids ids
      blocs, ranks = [], []
      blank = JSON.parse({'meta' => {'code' => 404}, 'data' => []}.to_json)
      until ids.empty?
        blocs << ids.shift(200)
      end
      blocs.each do |bloc|
        got = CNX.get("#{@url}#{bloc.join(',')}&show_details=Y")
        if got.nil? || got.empty?
          ranks << [{}]
        else
          resps = JSON.parse(got)
          ranks << resps['data']
        end
      end
      return ranks.flatten!
    end

    def get_ranks stream
      user_ids, niceranks = [], {}

      stream['data'].each do |post|
        user_ids << post['user']['id']
      end
      user_ids.uniq!

      got = CNX.get "#{@url}#{user_ids.join(',')}&show_details=Y"
      if got.nil? || got == ""
        parsed = {'meta' => {'code' => 404}, 'data' => []}
      else
        parsed = JSON.parse(got)
      end

      parsed['data'].each do |obj|
        obj['account']['is_human'] == true ? is_human = 1 : is_human = 0
        obj['account']['real_person'] == true ? real_person = 1 : real_person = 0
        niceranks[obj['user_id']] = {
          username: obj['user']['username'],
          rank: obj['rank'],
          is_human: is_human,
          real_person: real_person,
          cached: Time.now.to_i
        }
      end
# puts niceranks.inspect
      niceranks
    end

  end
end
