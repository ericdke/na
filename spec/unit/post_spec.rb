require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::Post do
  before do
    Ayadn::Settings.stub(:options).and_return({
        colors: {
          hashtags: :cyan,
          mentions: :red,
          username: :green,
          id: :blue,
          name: :yellow,
          source: :blue,
          symbols: :green,
          index: :blue,
          date: :cyan,
          link: :magenta,
          excerpt: :green
        },
        timeline: {
          real_name: true,
          date: true,
          symbols: true,
          source: true
        },
        formats: {table: {width: 75}},
        counts: {
          default: 33
        }
      })
    Ayadn::Settings.stub(:config).and_return({
        identity: {
          username: 'test',
          handle: '@test'
        },
        post_max_length: 256,
        message_max_length: 2048,
        version: 'wee',
        ruby: '0',
        locale: 'gibberish',
        platform: 'shoes'
      })
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
      expect(rest).to receive(:post).with("https://api.app.net/posts/?include_annotations=1&access_token=XYZ", {"text"=>"YOLO", "entities"=>{"parse_markdown_links"=>true, "parse_links"=>true}, "annotations"=>[{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>"shoes", "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}]})
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
      expect(post.markdown_extract("[ayadn](http://ayadn-app.net)")).to eq ["ayadn", "http://ayadn-app.net"]
    end
  end

  describe "#get_markdown_text" do
    it "extracts markdown text" do
      expect(post.get_markdown_text("[ayadn](http://ayadn-app.net)")).to eq "ayadn"
    end
  end

  describe "#post_size_ok?" do
    it "checks excessive post length" do
      expect(post.post_size_ok?(["1" * 257].join())).to eq false
    end
    it "checks empty post length" do
      expect(post.post_size_ok?("")).to eq false
    end
    it "checks normal post length" do
      expect(post.post_size_ok?(["1" * 256].join())).to eq true
    end
  end

  describe "#message_size_ok?" do
    it "checks normal message length" do
      expect(post.message_size_ok?(["1" * 2048].join())).to eq true
    end
    it "checks empty message length" do
      expect(post.message_size_ok?("")).to eq false
    end
    it "checks excessive message length" do
      expect(post.message_size_ok?(["1" * 2049].join())).to eq false
    end
  end
end
