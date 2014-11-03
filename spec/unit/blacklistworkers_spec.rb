require 'spec_helper'
require 'helpers'

describe Ayadn::BlacklistWorkers do
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
          link: :magenta
        },
        timeline: {
          show_real_name: true,
          show_date: true,
          show_symbols: true,
          show_source: true
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
        paths: {
          db: 'spec/mock/',
          pagination: 'spec/mock/',
          log: 'spec/mock'
        }
      })
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
  end

  after do
    File.delete('spec/mock/ayadn.log')
    Ayadn::Databases.open_databases
    Ayadn::Databases.clear_blacklist
    Ayadn::Databases.close_all
  end
end
