# encoding: utf-8
module Ayadn
  class NiceRank

    def initialize
      @url = 'http://api.nice.social/user/nicerank?ids='
    end

    def get_ranks stream
      user_ids, get_these, table, niceranks = [], [], {}, {}

      stream['data'].each do |post|
        user_ids << post['user']['id'].to_i
        table[post['user']['id'].to_i] = post['user']['username']
      end
      user_ids.uniq!

      db_ranks = Databases.get_niceranks user_ids
      if Settings.options[:nicerank].nil?
        expire = 172800 # 48h
      else
        if Settings.options[:nicerank][:cache].nil?
          Settings.options[:nicerank][:cache] = 48
          expire = 172800
        else
          expire = Settings.options[:nicerank][:cache] * 3600
        end
      end

      db_ranks.each do |id, ranks|
        if ranks.nil? || (Time.now - ranks[:cached]) > expire
          get_these << id
        else
          niceranks[id] = {
            username: ranks[:username],
            rank: ranks[:rank],
            is_human: ranks[:is_human],
            real_person: ranks[:real_person],
            cached: ranks[:cached]
          }
        end
      end

      Debug.how_many_ranks niceranks, get_these

      unless get_these.empty?
        got = CNX.get "#{@url}#{get_these.join(',')}&show_details=Y"
        blank = JSON.parse({'meta' => {'code' => 404}, 'data' => []}.to_json)
        if got.nil? || got == ""
          parsed = blank
        else
          parsed = JSON.parse(got)
        end
        if parsed['meta']['code'] != 200
          resp = blank
        else
          resp = parsed
        end

        if resp['meta']['code'] != 200
          Debug.niceranks_error resp
          Errors.nr "REQUESTED: #{get_these.join(' ')}"
          Errors.nr "RESPONSE: #{resp}"
          if niceranks
            Debug.ranks_pool niceranks
            return niceranks
          else
            return {}
          end
        end

        resp['data'].each do |obj|
          niceranks[obj['user_id']] = {
            username: table[obj['user_id']],
            rank: obj['rank'],
            is_human: obj['is_human'],
            real_person: obj['account']['real_person'],
            cached: Time.now
          }
        end

        Debug.total_ranks niceranks
      end

      Databases.add_niceranks niceranks

      niceranks
    end

  end
end
