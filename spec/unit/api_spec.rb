require 'spec_helper'

describe Ayadn::API do
	before do
    Ayadn::Settings.stub(:options).and_return(
      Ayadn::Preferences.new(
        {
        timeline: {
          directed: true,
          source: true,
          symbols: true,
          name: true,
          date: true,
          debug: false,
          compact: false
        },
        marker: {
          messages: true
        },
        counts: {
          default: 50,
          unified: 50,
          global: 50,
          checkins: 50,
          conversations: 50,
          photos: 50,
          trending: 50,
          mentions: 50,
          convo: 50,
          posts: 50,
          messages: 20,
          search: 200,
          whoreposted: 20,
          whostarred: 20,
          whatstarred: 100,
          files: 50
        },
        formats: {
          table: {
            width: 75,
            borders: true
          },
          list: {
            reverse: true
          }
        },
        channels: {
          links: true
        },
        colors: {
          id: :blue,
          index: :red,
          username: :green,
          name: :magenta,
          date: :cyan,
          link: :yellow,
          dots: :blue,
          hashtags: :cyan,
          mentions: :red,
          source: :cyan,
          symbols: :green,
          unread: :cyan,
          debug: :red,
          excerpt: :green
        },
        backup: {
          posts: false,
          messages: false,
          lists: false
        },
        scroll: {
          spinner: true,
          timer: 3,
          date: false
        },
        nicerank: {
          threshold: 2.1,
          filter: true,
          unranked: false
        },
        nowplaying: {},
        blacklist: {
          active: true
        }
      }))
  end
  describe ".build_query" do
    it 'returns a URL with count=12' do
      expect(Ayadn::API.build_query({count: 12})).to match /count=12/
    end
    it 'returns a URL with directed=0' do
      expect(Ayadn::API.build_query({directed: 0})).to match /directed_posts=0/
    end
    it 'returns a URL with html=0 anyway' do
      expect(Ayadn::API.build_query({html: 1})).to match /html=0/
    end
  end
  describe "#check_response_meta_code" do
    it "returns original response if code is 200" do
      res = {'meta' => { 'code' => 200 }}
      expect(Ayadn::API.new.check_response_meta_code(res)).to eq res
    end
  end
end
