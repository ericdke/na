require 'spec_helper'

describe Ayadn::Endpoints do
  before do
	 Ayadn::Settings.load_config
  end
  #Settings.get_token
  #Settings.init_config
	describe "unified" do
		it 'builds the url' do
			expect(Ayadn::Endpoints.new.unified({})).to include "https://alpha-api.app.net/stream/0/posts/stream/unified?access_token=&count=50"
			expect(Ayadn::Endpoints.new.unified({count: 33, since_id: 34455667})).to include "&count=33&include_html=0&include_directed=1&include_deleted=0&include_annotations=1&since_id=34455667"
		end
	end
end
