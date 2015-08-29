# encoding: utf-8
module Ayadn
  class NiceRank

    attr_reader :store

    def initialize
      @url = 'http://api.nice.social/user/nicerank?ids='
      @store = FastCache::Cache.new(5_000, 120*60) # 5000 items with 2 hours TTL each
      @hits = 0
      @ids = 0
      @posts = 0
    end

    # Get posts
    # Get unique posters
    # Get NR response
    # Fetch IDs from store
    # if absent, decode + save to dic + cache in store
    # if present, save to dic from store (and count hits for debug) 
    def get_ranks stream
      begin
        user_ids, niceranks = [], {}
        stream['data'].each do |post|
          id = post['user']['id']
          user_ids << id if @store[id].nil?
        end
        user_ids.uniq!
        got = CNX.get "#{@url}#{user_ids.join(',')}" unless user_ids.empty?
        if got.nil? || got == ""
          parsed = {'meta' => {'code' => 404}, 'data' => []}
        else

          begin
            parsed = JSON.parse(got)
          rescue
            parsed = {'meta' => {'code' => 404}, 'data' => []}
          end

          unless parsed['data'].is_a?(Array)
            parsed = {'meta' => {'code' => 404}, 'data' => []}
          end

        end
        parsed['data'].each do |obj|
          res = @store[obj['user_id']]
          if res.nil?
            obj['is_human'] == true ? is_human = 1 : is_human = 0
            content = {
              rank: obj['rank'],
              is_human: is_human
            }
            @store[obj['user_id']] = content
            niceranks[obj['user_id']] = content
          else
            @hits += 1
            niceranks[obj['user_id']] = res
          end
        end


        @posts += stream['data'].size
        @ids += user_ids.size

        if Settings.options[:timeline][:debug] == true
          deb = "\n"
          deb << "+ NICERANK\n"
          deb << "* t#{Time.now.to_i}\n"
          deb << "Posts:\t\t#{stream['data'].size}\n"
          deb << "Requested NR:\t#{user_ids.size}\n"
          deb << "* TOTALS\n"
          deb << "Posts:\t\t#{@posts}\n"
          deb << "Fetched ranks:\t#{@ids}\n"
          deb << "DB hits:\t#{@hits}\n"
          deb << "Uniques:\t#{@store.count}\n"
          deb << "\n"
          puts deb.color(Settings.options[:colors][:debug])
          Logs.rec.debug "NICERANK/POSTS: #{@posts}"
          Logs.rec.debug "NICERANK/NR CALLS: #{@ids}"
          Logs.rec.debug "NICERANK/CACHE HITS: #{@hits}"
          Logs.rec.debug "NICERANK/CACHED IDS: #{@store.count}"
        end
        return niceranks
      rescue => e
        Errors.global_error({error: e, caller: caller, data: [user_ids, niceranks, parsed]})
      end
    end

    # This is for user lists, no scrolling: no need to cache
    # Even with a lot of requests, it's within the NR limits
    # because of the slicing (upto 200 objects / call)
    def from_ids ids
      blocs, ranks = [], []
      blank = JSON.parse({'meta' => {'code' => 404}, 'data' => []}.to_json)
      until ids.empty?
        blocs << ids.shift(200)
      end
      blocs.each do |bloc|
        got = CNX.get("#{@url}#{bloc.join(',')}")
        if got.nil? || got.empty?
          ranks << [{}]
        else
          resps = JSON.parse(got)
          ranks << resps['data']
        end
      end
      return ranks.flatten!
    end

  end
end
