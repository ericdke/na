# encoding: utf-8
module Ayadn

  class ChannelReadersObject

    attr_reader :input, :you, :any_user, :public, :immutable

    def initialize hash
      @input = hash
      @you = @input["you"]
      @any_user = @input["any_user"]
      @public = @input["public"]
      @immutable = @input["immutable"]
    end
  end

  class ChannelEditorsObject

    attr_reader :input, :you, :any_user, :public, :immutable, :user_ids

    def initialize hash
      @input = hash
      @you = @input["you"]
      @any_user = @input["any_user"]
      @public = @input["public"]
      @immutable = @input["immutable"]
      @user_ids = @input["user_ids"]
    end
  end

  class ChannelCountsObject

    attr_reader :input, :messages, :subscribers

    def initialize hash
      @input = hash
      @messages = @input["messages"]
      @subscribers = @input["subscribers"]
    end

  end

  class ChannelObject

  	attr_reader :input, :pagination_id, :is_inactive, :readers, :you_muted, :you_can_edit, :has_unread, :editors, :annotations, :recent_message_id, :writers, :you_subscribed, :owner, :type, :id, :counts, :recent_message

    def initialize hash
      @input = hash
      @pagination_id = @input["pagination_id"]
      @is_inactive = @input["is_inactive"]
      @readers = ChannelReadersObject.new(@input["readers"])
      @you_muted = @input["you_muted"]
      @you_can_edit = @input["you_can_edit"]
      @has_unread = @input["has_unread"]
      @editors = ChannelEditorsObject.new(@input["editors"])
      @annotations = @input["annotations"].map { |ann| PostAnnotationObject.new(ann) }
      @recent_message_id = @input["recent_message_id"]
      @writers = ChannelEditorsObject.new(@input["writers"])
      @you_subscribed = @input["you_subscribed"]
      @owner = @input["owner"].nil? ? nil : UserObject.new(@input["owner"])
      @type = @input["type"]
      @id = @input["id"]
      @counts = ChannelCountsObject.new(@input["counts"])
      @recent_message = @input["recent_message"].nil? ? nil : PostObject.new(@input["recent_message"]["data"])
    end

  end
end







