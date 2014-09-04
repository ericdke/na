require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::View do

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
          username: 'test'
        }
      })
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::Databases.stub(:blacklist).and_return("blacklist")
    Ayadn::Databases.stub(:save_indexed_posts).and_return("indexed")
  end

  describe "#settings" do
    it 'outputs the settings' do
      printed = capture_stdout do
        Ayadn::View.new.show_settings
      end
      expect(printed).to include "Ayadn settings"
      expect(printed).to include "colors"
    end
  end

  let(:stream) { JSON.parse(File.read("spec/mock/stream.json")) }
  let(:list) { JSON.parse(File.read("spec/mock/fwr_@ayadn.json")) }
  let(:int) { JSON.parse(File.read("spec/mock/int.json")) }
  let(:files) { JSON.parse(File.read("spec/mock/files.json")) }
  let(:user_e) { JSON.parse(File.read("spec/mock/@ericd.json")) }
  let(:users) { {"007"=>["bond", "James Bond", true, true], "666"=>["mrtest", "Mr Test", false, false]} }

  describe "#show_list_reposted" do
    it "outputs the reposters list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_reposted(list[0]['data'], 123456)
      end
      expect(printed).to include *['Joel Timmins', 'Donny Davis', 'Nicolas Maumont', '95.41', 'reposted post']
    end
  end

  describe "#show_list_starred" do
    it "outputs the starred list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_starred(list[0]['data'], 123456)
      end
      expect(printed).to include *['Joel Timmins', 'Donny Davis', 'Nicolas Maumont', '95.41', 'starred post']
    end
  end

  describe "#show_list_followings" do
    it "outputs the followings list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_followings(users, '@bond')
      end
      expect(printed).to include *['List of users', 'is following', '0.83']
    end
  end

  describe "#show_list_followers" do
    it "outputs the followers list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_followers(users, '@bond')
      end
      expect(printed).to include *['List of users following', '0.83']
    end
  end

  describe "#show_list_muted" do
    it "outputs the muted list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_muted(users)
      end
      expect(printed).to include *['List of users you muted', '0.83']
    end
  end

  describe "#show_list_blocked" do
    it "outputs the blocked list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_blocked(users)
      end
      expect(printed).to include *['List of users you blocked', '0.83']
    end
  end

  describe "#show_interactions" do
    it "outputs the interactions list" do
      printed = capture_stdout do
        Ayadn::View.new.show_interactions(int['data'])
      end
      expect(printed).to include *['2013-11-02 17:15:08', 'followed you']
    end
  end

  describe "#show_files_list" do
    it "outputs the files list" do
      printed = capture_stdout do
        Ayadn::View.new.show_files_list(files)
      end
      expect(printed).to include *['2014-08-31 15:41:41', 'png', '969', '512', 'w2xvwKNf2']
    end
  end

  describe "#show_posts" do
    it 'outputs the stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts(stream['data'])
      end
      expect(printed).to include "23184500"
      expect(printed).to include "Backer of the Day"
    end
  end

  describe "#show_raw" do
    it 'outputs the raw stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_raw(stream['data'][0])
      end
      expect(printed).to include '"created_at": "2013-05-19T22:33:57Z"'
    end
  end

  describe "#show_simple_post" do
    it 'outputs one post' do
      printed = capture_stdout do
        Ayadn::View.new.show_simple_post([stream['data'][0]])
      end
      expect(printed).to include "23187443"
      expect(printed).to include "Julia Cory"
    end
  end

  describe "#show_posts_with_index" do
    it 'outputs the indexed stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts_with_index(stream['data'])
      end
      expect(printed).to include "001"
      expect(printed).to include "Backer of the Day"
    end
  end

  describe "#show_userinfos" do
    it "outputs user info" do
      printed = capture_stdout do
        Ayadn::View.new.show_userinfos(user_e['data'], "")
      end
      expect(printed).to include "Sound engineer"
      expect(printed).to include "aya.io"
      expect(printed).to include "69904"
      expect(printed).to include "Eric"
      expect(printed).to include "2013"
      expect(printed).to include "fr_FR"
      expect(printed).to include "ritsz"
      expect(printed).to include "1973"
    end
  end

end
