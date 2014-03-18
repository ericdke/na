require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::Workers do

  before do
    Ayadn::Settings.load_config
    #Settings.get_token
    Ayadn::Settings.init_config
    Ayadn::Logs.create_logger
    Ayadn::Databases.open_databases
  end

  after do
    Ayadn::Databases.close_all
  end

  let(:data) { JSON.parse(File.read("spec/mock/stream.json")) }

  describe "#build_posts" do
    it "builds posts hash from stream" do
      posts = Ayadn::Workers.new.build_posts(data['data'])
      expect(posts[23187363][:name]).to eq "App.net Staff"
      expect(posts[23184500][:username]).to eq "wired"
      expect(posts[23185033][:handle]).to eq "@hackernews"
      expect(posts[23184500][:links]).to eq ["http://ift.tt/1mtTrU9"]
    end
  end

  let(:list) { {"007"=>["bond", "James Bond", true, true], "666"=>["mrtest", "Mr Test", false, false]} }

  describe "#build_followers_list" do
    it 'builds the followers table list' do
      printed = capture_stdout do
        puts Ayadn::Workers.new.build_followers_list(list, "@test")
      end
      expect(printed).to include "+----"
      expect(printed).to include "@test"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_followings_list" do
    it 'builds the followings table list' do
      printed = capture_stdout do
        puts Ayadn::Workers.new.build_followings_list(list, "@test")
      end
      expect(printed).to include "+----"
      expect(printed).to include "@test"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_muted_list" do
    it 'builds the muted table list' do
      printed = capture_stdout do
        puts Ayadn::Workers.new.build_muted_list(list)
      end
      expect(printed).to include "+----"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_blocked_list" do
    it 'builds the blocked table list' do
      printed = capture_stdout do
        puts Ayadn::Workers.new.build_blocked_list(list)
      end
      expect(printed).to include "+----"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe ".add_arobase_if_missing" do
    it 'adds @ to username' do
      expect(Ayadn::Workers.add_arobase_if_missing(["user"])).to eq "@user"
    end
    it 'does nothing to @username' do
      expect(Ayadn::Workers.add_arobase_if_missing(["@user"])).to eq "@user"
    end
  end

  describe ".remove_arobase_if_present" do
    it "removes @ from username" do
      expect(Ayadn::Workers.remove_arobase_if_present("@user")).to eq "user"
      expect(Ayadn::Workers.remove_arobase_if_present("user")).to eq "user"
    end
  end
end
