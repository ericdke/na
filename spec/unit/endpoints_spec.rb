require 'spec_helper'

describe Ayadn::Endpoints do
	Ayadn::Settings.load_config
  Settings.get_token
  Settings.init_config
	describe ".unified" do
		it 'builds the url' do
			expect(Ayadn::Endpoints.new.unified({})).to include "https://alpha-api.app.net/stream/0/posts/stream/unified?access_token="

			expect(Ayadn::Endpoints.new.unified({})).to include "&count=50&include_html=0&include_directed=1&include_deleted=0&include_annotations=1"
		end
	end
end
