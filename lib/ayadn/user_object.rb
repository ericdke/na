# encoding: utf-8
module Ayadn

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

    attr_reader :input, :you_muted, :you_can_subscribe, :is_following, :is_follower, :timezone, :you_follow, :counts, :canonical_url, :id, :locale, :type, :annotations, :username, :avatar_image, :description, :is_muted, :follows_you, :you_can_follow, :name, :created_at, :you_blocked, :cover_image

    def initialize hash
      @input = hash["user"]
      @you_muted = @input["you_muted"]
      @you_can_subscribe = @input["you_can_subscribe"]
      @is_follower = @input["is_follower"]
      @is_following = @input["is_following"]
      @timezone = @input["timezone"]
      @you_follow = @input["you_follow"]
      @counts = UserCountsObject.new(@input)
      @canonical_url = @input["canonical_url"]
      @id = @input["id"]
      @locale = @input["locale"]
      @type = @input["type"]
      @annotations = @input["annotations"].map { |hash| UserAnnotationObject.new(hash) }
      @username = @input["username"]
      @avatar_image = AvatarImageObject.new(@input)
      @description = UserDescriptionObject.new(@input)
      @is_muted = @input["is_muted"]
      @follows_you = @input["follows_you"]
      @you_can_follow = @input["you_can_follow"]
      @name = @input["name"]
      @created_at = @input["created_at"]
      @you_blocked = @input["you_blocked"]
      @cover_image = CoverImageObject.new(@input)
    end
  end
end