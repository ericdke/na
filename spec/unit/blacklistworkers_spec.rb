require 'spec_helper'
require 'helpers'

describe Ayadn::BlacklistWorkers do
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
    Ayadn::Settings.stub(:load_config)
    Ayadn::Settings.stub(:get_token)
    Ayadn::Settings.stub(:init_config)
    Dir.stub(:home).and_return('spec/mock/')
  end

  describe "add" do
    it "adds a client to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['source', 'Zapier'])
      expect(Ayadn::Databases.is_in_blacklist?('client', 'zapier')).to eq true
    end
    it "adds a hashtag to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['tag', 'tv'])
      expect(Ayadn::Databases.is_in_blacklist?('hashtag', 'tv')).to eq true
    end
    it "adds a mention to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['mentions', 'yolo'])
      expect(Ayadn::Databases.is_in_blacklist?('mention', 'yolo')).to eq true
    end
    it "adds a word to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['word', 'Instagram'])
      expect(Ayadn::Databases.is_in_blacklist?('word', 'instagram')).to eq true
    end
  end

  describe "remove" do
    it "removes a client from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['client', 'IFTTT'])
      expect(Ayadn::Databases.is_in_blacklist?('client', 'ifttt')).to eq true

      k = Ayadn::BlacklistWorkers.new
      k.remove(['client', 'IFTTT'])
      expect(Ayadn::Databases.is_in_blacklist?('client', 'ifttt')).to eq false
    end
    it "removes a hashtag from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['hashtag', 'Sports'])
      expect(Ayadn::Databases.is_in_blacklist?('hashtag', 'sports')).to eq true

      k = Ayadn::BlacklistWorkers.new
      k.remove(['hashtag', 'Sports'])
      expect(Ayadn::Databases.is_in_blacklist?('hashtag', 'sports')).to eq false
    end
    it "removes a mention from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['mention', 'mrTest'])
      expect(Ayadn::Databases.is_in_blacklist?('mention', 'mrtest')).to eq true

      k = Ayadn::BlacklistWorkers.new
      k.remove(['mention', 'mrTest'])
      expect(Ayadn::Databases.is_in_blacklist?('mention', 'mrtest')).to eq false
    end
    it "removes a user from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['user', 'mrTest'])
      expect(Ayadn::Databases.is_in_blacklist?('user', 'mrtest')).to eq true

      k = Ayadn::BlacklistWorkers.new
      k.remove(['account', 'mrTest'])
      expect(Ayadn::Databases.is_in_blacklist?('user', 'mrtest')).to eq false
    end
    it "removes a word from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['word', 'Instagram'])
      expect(Ayadn::Databases.is_in_blacklist?('word', 'instagram')).to eq true

      k = Ayadn::BlacklistWorkers.new
      k.remove(['word', 'Instagram'])
      expect(Ayadn::Databases.is_in_blacklist?('word', 'instagram')).to eq false
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
    Ayadn::Databases.open_databases
    Ayadn::Databases.clear_blacklist
  end
end
