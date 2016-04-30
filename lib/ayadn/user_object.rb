# encoding: utf-8
module Ayadn

  class UserMetaObject

    attr_reader :input, :code

    def initialize hash, username = nil
      @input = hash["meta"].nil? ? {} : hash["meta"]
      @code = @input["code"]
      if code == 404
        Status.new.user_404(username)
        Errors.info("User #{username} doesn't exist")
        exit
      end
    end
  end

  class UserCountsObject 

    attr_reader :input, :following, :posts, :followers, :stars

    def initialize hash
      @input = hash["counts"]
      @following = @input["following"]
      @posts = @input["posts"]
      @followers = @input["followers"]
      @stars = @input["stars"]
    end
  end

  class UserAnnotationObject

    attr_reader :input, :type, :value

    def initialize hash
      @input = hash
      @type = @input["type"]
      @value = @input["value"]
    end
  end

  class AvatarImageObject

    attr_reader :input, :url, :width, :is_default, :height

    def initialize hash
      @input = hash["avatar_image"]
      @url = @input["url"]
      @width = @input["width"]
      @is_default = @input["is_default"]
      @height = @input["height"]
    end
  end

  class CoverImageObject

    attr_reader :input, :url, :width, :is_default, :height

    def initialize hash
      @input = hash["cover_image"]
      @url = @input["url"]
      @width = @input["width"]
      @is_default = @input["is_default"]
      @height = @input["height"]
    end
  end

  class UserDescriptionObject

    attr_reader :input, :text, :entities

    def initialize hash
      @input = hash["description"].nil? ? {} : hash["description"]
      @text = @input["text"].nil? ? "" : @input["text"]
      @entities = EntitiesObject.new(@input)
    end
  end

  class UserObject

    attr_accessor :input, :you_muted, :you_can_subscribe, :is_following, :is_follower, :timezone, :you_follow, :counts, :canonical_url, :id, :locale, :type, :annotations, :username, :avatar_image, :description, :is_muted, :follows_you, :you_can_follow, :name, :created_at, :you_blocked, :cover_image, :verified_domain, :meta

    def initialize hash, username = nil
      @input = hash['data'].nil? ? hash : hash['data']
      @meta = UserMetaObject.new(hash, username)
      @you_muted = @input["you_muted"]
      @you_can_subscribe = @input["you_can_subscribe"]
      @is_follower = @input["is_follower"]
      @is_following = @input["is_following"]
      @timezone = @input["timezone"]
      @you_follow = @input["you_follow"]
      @counts = UserCountsObject.new(@input) unless @input.empty?
      @canonical_url = @input["canonical_url"]
      @id = @input["id"]
      @locale = @input["locale"]
      @type = @input["type"]
      if !@input["annotations"].nil?
        @annotations = @input["annotations"].map { |hash| UserAnnotationObject.new(hash) }
      else
        @annotations = []
      end
      @username = @input["username"]
      @avatar_image = AvatarImageObject.new(@input) unless @input.empty?
      @description = UserDescriptionObject.new(@input) unless @input.empty?
      @is_muted = @input["is_muted"]
      @follows_you = @input["follows_you"]
      @you_can_follow = @input["you_can_follow"]
      @name = @input["name"].to_s.force_encoding("UTF-8")
      @created_at = @input["created_at"]
      @you_blocked = @input["you_blocked"]
      @cover_image = CoverImageObject.new(@input) unless @input.empty?
      @verified_domain = @input["verified_domain"]
    end
  end
end