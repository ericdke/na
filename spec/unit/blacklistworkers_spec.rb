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
      k.add(['client', 'IFTTT'])
      expect(Ayadn::Databases.blacklist['ifttt']).to eq :client
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"IFTTT\"]' to blacklist of clients."
    end
    it "adds a client to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['source', 'Zapier'])
      expect(Ayadn::Databases.blacklist['zapier']).to eq :client
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"Zapier\"]' to blacklist of clients."
    end
    it "adds a hashtag to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['hashtag', 'Sports'])
      expect(Ayadn::Databases.blacklist['sports']).to eq :hashtag
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"Sports\"]' to blacklist of hashtags."
    end
    it "adds a hashtag to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['tag', 'tv'])
      expect(Ayadn::Databases.blacklist['tv']).to eq :hashtag
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"tv\"]' to blacklist of hashtags."
    end
    it "adds a mention to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['mention', 'mrTest'])
      expect(Ayadn::Databases.blacklist['@mrtest']).to eq :mention
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"@mrTest\"]' to blacklist of mentions."
    end
    it "adds a mention to the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['mentions', 'yolo'])
      expect(Ayadn::Databases.blacklist['@yolo']).to eq :mention
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"@yolo\"]' to blacklist of mentions."
    end
  end

  describe "remove" do
    it "removes a client from the blacklist" do
      k = Ayadn::BlacklistWorkers.new
      k.add(['client', 'IFTTT'])
      expect(Ayadn::Databases.blacklist['ifttt']).to eq :client
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Added '[\"IFTTT\"]' to blacklist of clients."
      k = Ayadn::BlacklistWorkers.new
      k.remove(['client', 'IFTTT'])
      expect(Ayadn::Databases.blacklist['ifttt']).to eq nil
      #expect(File.read('spec/mock/ayadn.log')).to include "(wee) INFO -- Removed 'client:[\"IFTTT\"]' from blacklist."
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
    Ayadn::Databases.open_databases
    Ayadn::Databases.blacklist.clear
    Ayadn::Databases.users.clear
    Ayadn::Databases.pagination.clear
    Ayadn::Databases.index.clear
    Ayadn::Databases.aliases.clear
    Ayadn::Databases.close_all
  end
end
