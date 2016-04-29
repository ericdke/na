# encoding: utf-8
module Ayadn

	class StreamMarkerObject

		attr_reader :input, :name, :updated_at, :version, :last_read_id, :percentage, :id

		def initialize hash
			@input = hash["marker"].nil? ? {} : hash["marker"]
			@name = @input["name"]
			@updated_at = @input["updated_at"]
			@version = @input["version"]
			@last_read_id = @input["last_read_id"]
			@percentage = @input["percentage"]
			@id = @input["id"]
		end
	end

	class StreamMetaObject

		attr_reader :input, :marker, :min_id, :code, :max_id, :more

		def initialize hash
			@input = hash["meta"].nil? ? {} : hash["meta"]
			@marker = hash["meta"].nil? ? nil : StreamMarkerObject.new(@input)
			@min_id = @input["min_id"]
			@code = @input["code"]
			@max_id = @input["max_id"]
			@more = @input["more"]
		end
	end

	class StreamDataObject

		attr_reader :input, :posts

		def initialize hash
			@input = hash["data"]
      		@posts = @input.blank? ? [] : @input.map { |post| PostObject.new(post) }
		end
	end

  class StreamObject

  	attr_reader :input, :meta, :data, :posts
    attr_accessor :view

  	def initialize hash
  		@input = hash
  		@meta = StreamMetaObject.new(@input)
  		@data = StreamDataObject.new(@input)
      @posts = @data.posts
  	end
  end

end