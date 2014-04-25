require 'spec_helper'

describe Ayadn::Endpoints do
  before do
    Ayadn::Settings.stub(:user_token).and_return('XXX')
    Ayadn::Settings.stub(:options).and_return({
        counts: {
          unified: 33,
          default: 100
        },
        timeline: {
          directed: 1,
          deleted: 0,
          html: 0,
          annotations: 1
        }
      })
  end
  describe '#token_info' do
    it "returns the Token url" do
      expect(Ayadn::Endpoints.new.token_info).to eq 'https://api.app.net/token/?access_token=XXX'
    end
  end
  describe '#unified' do
    it "returns the Unified url" do
      expect(Ayadn::Endpoints.new.unified({})).to eq 'https://api.app.net/posts/stream/unified?access_token=XXX&count=33&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
    it "returns the Unified url" do
      expect(Ayadn::Endpoints.new.unified({count: 66, html: 1})).to eq 'https://api.app.net/posts/stream/unified?access_token=XXX&count=66&include_html=1&include_directed=1&include_deleted=0&include_annotations=1'
    end
    it "returns the Unified url" do
      expect(Ayadn::Endpoints.new.unified({since_id: 336699})).to eq 'https://api.app.net/posts/stream/unified?access_token=XXX&count=100&include_html=0&include_directed=1&include_deleted=0&include_annotations=1&since_id=336699'
    end
  end
end
