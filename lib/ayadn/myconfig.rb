module Ayadn

	class MyConfig

		AYADN_CLIENT_ID = "hFsCGArAjgJkYBHTHbZnUvzTmL4vaLHL"

		def initialize
			@user_token = IO.read(File.expand_path("../../../token", __FILE__)).chomp
		end

		def build_options(options)
			count = options[:count] || 200
			html = options[:html] || 0
			directed = options[:directed] || 1
			deleted = options[:deleted] || 0
			annotations = options[:annotations] || 1
			"&count=#{count}&include_html=#{html}&include_directed=#{directed}&include_deleted=#{deleted}&include_annotations=#{annotations}"
		end

		def user_token
			@user_token
		end

	end
end