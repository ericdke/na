# encoding: utf-8
module Ayadn

  class PostSourceObject

    attr_reader :input, :link, :name, :client_id

    def initialize hash
      @input = hash["source"]
      @link = @input["link"]
      @name = @input["name"]
      @client_id = @input["client_id"]
    end
  end

  class PostLinkObject

    attr_reader :input, :url, :text, :pos, :len, :amended_len

    def initialize hash
      @input = hash
      @url = @input["url"]
      @text = @input["text"]
      @pos = @input["pos"]
      @len = @input["len"]
      @amended_len = @input["amended_len"]
    end
  end

  class PostMentionObject

    attr_reader :input, :is_leading, :pos, :id, :len, :name, :amended_len

    def initialize hash
      @input = hash
      @is_leading = @input["is_leading"]
      @pos = @input["pos"]
      @id = @input["id"]
      @len = @input["len"]
      @name = @input["name"]
      @amended_len = @input["amended_len"]
    end
  end

  class PostHashtagObject

    attr_reader :input, :name, :len, :pos, :amended_len

    def initialize hash
      @input = hash
      @name = @input["name"]
      @len = @input["len"]
      @pos = @input["pos"]
      @amended_len = @input["amended_len"]
    end
  end
  
  class EntitiesObject

    attr_reader :input, :mentions, :hashtags, :links

    def initialize hash
      @input = hash["entities"].nil? ? {} : hash["entities"]
      mentions = @input["mentions"].nil? ? [] : @input["mentions"]
      @mentions = mentions.map { |hash| PostMentionObject.new(hash) }
      hashtags = @input["hashtags"].nil? ? [] : @input["hashtags"]
      @hashtags = hashtags.map { |hash| PostHashtagObject.new(hash) }
      links = @input["links"].nil? ? [] : @input["links"]
      @links = links.map { |hash| PostLinkObject.new(hash) }
    end
  end

  class PostAnnotationObject

    attr_reader :input, :type, :value

    def initialize hash
      @input = hash
      @type = @input["type"]
      @value = @input["value"]
    end
  end

	class PostObject # also works for messages

    attr_reader :input, :num_stars, :num_reposts, :num_replies, :text, :created_at, :id, :canonical_url, :machine_only, :you_reposted, :you_starred, :thread_id, :pagination_id, :source, :user, :annotations, :entities, :repost_of, :reply_to, :is_deleted, :channel_id
    attr_accessor :view

    def initialize hash
      @input = hash
      @num_stars = @input["num_stars"]
      @num_reposts = @input["num_reposts"]
      @num_replies = @input["num_replies"]
      @text = @input["text"]
      @created_at = @input["created_at"]
      @id = @input["id"]
      @canonical_url = @input["canonical_url"]
      @machine_only = @input["machine_only"]
      @you_reposted = @input["you_reposted"]
      @you_starred = @input["you_starred"]
      @thread_id = @input["thread_id"]
      @pagination_id = @input["pagination_id"]
      @source = PostSourceObject.new(@input)
      @entities = EntitiesObject.new(@input)
      @user = UserObject.new(@input["user"])
      @annotations = @input["annotations"].map { |hash| PostAnnotationObject.new(hash) }
      @repost_of = PostObject.new(@input["repost_of"]) if !@input["repost_of"].blank?
      @reply_to = @input["reply_to"]
      @is_deleted = @input["is_deleted"]
      @channel_id = @input["channel_id"]
    end
	end

end