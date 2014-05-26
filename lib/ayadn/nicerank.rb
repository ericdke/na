# encoding: utf-8
module Ayadn
  class NiceRank

    def initialize
      @url = 'http://api.search-adn.net/user/nicerank?ids='
      @show_debug = Settings.options[:timeline][:show_debug]
    end

    def get_ranks stream
      user_ids, get_these, table, niceranks = [], [], {}, {}

      stream['data'].each do |post|
        user_ids << post['user']['id'].to_i
        table[post['user']['id'].to_i] = post['user']['username']
      end
      user_ids.uniq!

      db_ranks = Databases.get_niceranks user_ids
      if Settings.options[:nicerank][:cache].nil?
        expire = 86400 # 24h
      else
        expire = Settings.options[:nicerank][:cache] * 3600
      end
      db_ranks.each do |id, ranks|
        if ranks.nil? || (Time.now - ranks[:cached]) > expire
          get_these << id
        else
          niceranks[id] = {
            username: ranks[:username],
            rank: ranks[:rank],
            is_human: ranks[:is_human],
            cached: ranks[:cached]
          }
        end
      end

      how_many(niceranks, get_these) if @show_debug == true

      unless get_these.empty?
        resp = JSON.parse(CNX.get "#{@url}#{get_these.join(',')}")

        if resp['meta']['code'] != 200
          nr_error(resp) if @show_debug == true
          Errors.nr "REQUESTED: #{get_these.join(' ')}"
          Errors.nr "RESPONSE: #{resp}"
          if niceranks
            in_pool(niceranks) if @show_debug == true
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
            cached: Time.now
          }
        end

        got(niceranks) if @show_debug == true
      end

      Databases.add_niceranks niceranks

      niceranks
    end

    private

    def how_many niceranks, get_these
      deb = "=====\n"
      deb << "NR from DB:\t#{niceranks}\n\n"
      deb << "NR to get:\t#{get_these}\n"
      deb << "=====\n"
      puts deb.color(Settings.options[:colors][:debug])
    end

    def in_pool niceranks
      deb = "=====\n"
      deb << "NR in pool:\t#{niceranks}\n"
      deb << "=====\n"
      puts deb.color(Settings.options[:colors][:debug])
    end

    def nr_error resp
      deb = "=====\n"
      deb << "NR Error:\t#{resp['meta']}"
      deb << "=====\n"
      puts deb.color(Settings.options[:colors][:debug])
    end

    def got niceranks
      deb = "=====\n"
      deb << "NiceRanks:\t#{niceranks}\n\n"
      deb << "=====\n"
      puts deb.color(Settings.options[:colors][:debug])
    end
  end
end
