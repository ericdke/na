require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::NiceRank do
  before do
    Ayadn::Settings.stub(:options).and_return(
      {
        timeline: {
          directed: 1,
          html: 0,
          annotations: 1,
          source: true,
          symbols: true,
          name: true,
          date: true,
          spinner: true,
          debug: false
        },
        counts: {
          default: 50,
          unified: 100,
          global: 100,
          checkins: 100,
          conversations: 50,
          photos: 50,
          trending: 100,
          mentions: 100,
          convo: 100,
          posts: 100,
          messages: 50,
          search: 200,
          whoreposted: 50,
          whostarred: 50,
          whatstarred: 100,
          files: 100
        },
        formats: {
          table: {
            width: 75
          }
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
          debug: :red,
          excerpt: :green
        },
        backup: {
          posts: false,
          messages: false,
          lists: false
        },
        scroll: {
          timer: 3
        },
        nicerank: {
          threshold: 2.1,
          filter: true,
          unranked: false
        },
        nowplaying: {}
      }
    )
    Ayadn::Settings.stub(:config).and_return({
        identity: {
          username: 'test',
          handle: '@test'
        },
        post_max_length: 256,
        message_max_length: 2048,
        version: 'wee'
      })
    Ayadn::Settings.stub(:user_token).and_return('XYZ')
    Ayadn::Settings.stub(:check_for_accounts)
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
  end

  #let(:rest) {Ayadn::CNX = double} #verbose in RSpec output, but useful
  let(:rest) {Ayadn::CNX}
  # let(:nicerank) { JSON.parse(File.read("spec/mock/nicerank.json")) }

  describe "#from_ids" do
    before do
      rest.stub(:get).and_return(File.read("spec/mock/nicerank.json"))
    end
    it "get niceranks from user ids" do
      expect(rest).to receive(:get).with("http://api.nice.social/user/nicerank?ids=69904")
      x = Ayadn::NiceRank.new.from_ids(['69904'])
      expect(x).to eq [{"user_id"=>69904,"rank"=>3.816259,"is_human"=>true}]
    end
  end
end
