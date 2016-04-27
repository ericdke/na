require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::NiceRank do
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
      })
    )
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
