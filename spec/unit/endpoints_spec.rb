require 'spec_helper'

describe Ayadn::Endpoints do
  before do
    Ayadn::Settings.stub(:user_token).and_return('XXX')
    Ayadn::Settings.stub(:options).and_return({
        counts: {
          unified: 33,
          default: 100,
          conversations: 12
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
  end
  describe '#global' do
    it "returns the Global url" do
      expect(Ayadn::Endpoints.new.global({since_id: 336699})).to eq 'https://api.app.net/posts/stream/global?access_token=XXX&count=100&include_html=0&include_directed=1&include_deleted=0&include_annotations=1&since_id=336699'
    end
  end
  describe "#checkins" do
    it "returns the Checkins url" do
      expect(Ayadn::Endpoints.new.checkins({count: 66, html: 1})).to eq 'https://api.app.net/posts/stream/explore/checkins?access_token=XXX&count=66&include_html=1&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#trending' do
    it "returns the trending url" do
      expect(Ayadn::Endpoints.new.trending({deleted: 1})).to eq 'https://api.app.net/posts/stream/explore/trending?access_token=XXX&count=100&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#photos' do
    it "returns the photos url" do
      expect(Ayadn::Endpoints.new.photos({count: 33})).to eq "https://api.app.net/posts/stream/explore/photos?access_token=XXX&count=33&include_html=0&include_directed=1&include_deleted=0&include_annotations=1"
    end
  end
  describe '#conversations' do
    it "returns the conversations url" do
      expect(Ayadn::Endpoints.new.conversations({})).to eq "https://api.app.net/posts/stream/explore/conversations?access_token=XXX&count=12&include_html=0&include_directed=1&include_deleted=0&include_annotations=1"
    end
  end
  describe '#mentions' do
    it "returns the mentions url" do
      expect(Ayadn::Endpoints.new.mentions('@test', {count: 33})).to eq 'https://api.app.net/users/@test/mentions/?access_token=XXX&count=33&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#posts' do
    it "returns the posts url" do
      expect(Ayadn::Endpoints.new.posts('@test', {count: 8})).to eq 'https://api.app.net/users/@test/posts/?access_token=XXX&count=8&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#whatstarred' do
    it "returns the whatstarred url" do
      expect(Ayadn::Endpoints.new.whatstarred('@test', {count: 16})).to eq 'https://api.app.net/users/@test/stars/?access_token=XXX&count=16&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#channel' do
    it "returns the channel url" do
      expect(Ayadn::Endpoints.new.channel([56789, 12345])).to eq 'https://api.app.net/channels/56789,12345?access_token=XXX&count=100&include_html=0&include_directed=1&include_deleted=0&include_annotations=1'
    end
  end
  describe '#messages' do
    it "returns the messages url" do
      expect(Ayadn::Endpoints.new.messages(56789)).to eq 'https://api.app.net/channels/56789/messages?access_token=XXX&count=100&include_html=0&include_directed=1&include_deleted=0&include_annotations=1&include_machine=1'
    end
  end
  describe '#file' do
    it "returns the file url" do
      expect(Ayadn::Endpoints.new.file(56789)).to eq 'https://api.app.net/files/56789?access_token=XXX'
    end
  end
end
