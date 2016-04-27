require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::Post do
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
    require 'json'
    require 'ostruct'
    obj =
      {
        identity: {
          username: 'test',
          handle: '@test'
        },
        post_max_length: 256,
        message_max_length: 2048,
        version: 'wee',
        paths: {
          db: 'spec/mock/',
          log: 'spec/mock'
        },
        platform: 'shoes',
        ruby: '0',
        locale: 'gibberish'
      }
    Ayadn::Settings.stub(:config).and_return(
      JSON.parse(obj.to_json, object_class: OpenStruct)
    )
    global_hash = {
      scrolling: false,
      force: false
    }
    Ayadn::Settings.stub(:global).and_return(
      JSON.parse(global_hash.to_json, object_class: OpenStruct)
    )
    Ayadn::Settings.stub(:user_token).and_return('XYZ')
    Ayadn::Settings.stub(:check_for_accounts)
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
  end

  let(:post) { Ayadn::Post.new }
  #let(:rest) {Ayadn::CNX = double} #verbose in RSpec output, but useful
  let(:rest) {Ayadn::CNX}

  describe "#post" do
    before do
      rest.stub(:post).and_return(File.read("spec/mock/posted.json"))
    end
    it "posts a post" do
      expect(rest).to receive(:post).with("https://api.app.net/posts/?include_annotations=1&access_token=XYZ", {"text"=>"YOLO", "entities"=>{"parse_markdown_links"=>true, "parse_links"=>true}, "annotations"=>[{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>"shoes", "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}]})
      x = post.post({text: 'YOLO'})
    end
    it "posts a post" do
      x = post.post({text: 'YOLO'})
    end
    it "returns the posted post" do
      x = post.post({text: 'whatever'})
      expect(x['data']['text']).to eq 'TEST'
    end
  end

  describe "#markdown_extract" do
    it "splits markdown" do
      expect(post.markdown_extract("[ayadn](https://github.com/ericdke/na)")).to eq ["ayadn", "https://github.com/ericdke/na"]
    end
  end

  describe "#keep_text_from_markdown_links" do
    it "extracts markdown text" do
      expect(post.keep_text_from_markdown_links("[ayadn](https://github.com/ericdke/na)")).to eq "ayadn"
    end
  end

  describe "#post_size_ok?" do
    it "checks excessive post length" do
      expect(post.post_size_ok?(["1" * 257].join())).to eq false
    end
    it "checks excessive post length with markdown" do
      expect(post.post_size_ok?(["1" * 251, "[aya.io](http://aya.io)"].join())).to eq false
    end
    it "checks empty post length" do
      expect(post.post_size_ok?("")).to eq false
    end
    it "checks full post length" do
      expect(post.post_size_ok?(["1" * 256].join())).to eq true
    end
    it "checks full post length" do
      expect(post.post_size_ok?(["Y😈" * 128].join())).to eq true
    end
    it "checks excessive post length" do
      expect(post.post_size_ok?(["😈" * 257].join())).to eq false
    end
    it "checks post length" do
      expect(post.post_size_ok?(["."].join())).to eq true
    end
    it "checks full post length" do
      expect(post.post_size_ok?(["1\n" * 128].join())).to eq true
    end
    it "checks excessive post length" do
      expect(post.post_size_ok?(["1\n" * 128, "\n"].join())).to eq false
    end
    it "checks full post length with markdown" do
      expect(post.post_size_ok?(["1" * 250, "[aya.io](http://aya.io)"].join())).to eq true
    end
  end

  describe "#message_size_ok?" do
    it "checks normal message length" do
      expect(post.message_size_ok?(["1" * 2048].join())).to eq true
    end
    it "checks normal message length with markdown" do
      expect(post.message_size_ok?(["1" * 2042, "[aya.io](http://aya.io)"].join())).to eq true
    end
    it "checks empty message length" do
      expect(post.message_size_ok?("")).to eq false
    end
    it "checks excessive message length" do
      expect(post.message_size_ok?(["1" * 2049].join())).to eq false
    end
    it "checks excessive message length with markdown" do
      expect(post.message_size_ok?(["1" * 2043, "[aya.io](http://aya.io)"].join())).to eq false
    end
  end
end
