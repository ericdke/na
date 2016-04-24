require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::View do

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
    Ayadn::Settings.stub(:global).and_return({
        scrolling: false
      })
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::Databases.stub(:blacklist).and_return("blacklist")
    Ayadn::Databases.stub(:save_indexed_posts).and_return("indexed")
    Ayadn::Databases.stub(:is_in_blacklist?).and_return(false)
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
  let(:rest) {Ayadn::CNX}
  let(:users) { {"007"=>["bond", "James Bond", true, true], "666"=>["mrtest", "Mr Test", false, false]} }

  describe "#show_list_reposted" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the reposters list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_reposted(list[0]['data'], 123456)
      end
      expect(printed).to include *['Joel Timmins', 'Donny Davis', 'reposted post', '123456']
    end
  end

  describe "#show_list_starred" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the starred list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_starred(list[0]['data'], 123456)
      end
      expect(printed).to include *['Joel Timmins', 'Donny Davis', 'starred post', '123456']
    end
  end

  describe "#show_list_followings" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the followings list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_followings(users, '@bond')
      end
      expect(printed).to include *['List of users', 'is following', '@bond']
    end
  end

  describe "#show_list_followers" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the followers list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_followers(users, '@bond')
      end
      expect(printed).to include *['List of users following', '@bond']
    end
  end

  describe "#show_list_muted" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the muted list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_muted(users)
      end
      expect(printed).to include *['List of users you muted', '@mrtest', '@bond', 'Mr Test']
    end
  end

  describe "#show_list_blocked" do
    before  do
      Ayadn::NiceRank.stub(:from_ids).and_return([{}])
      rest.stub(:get)
    end
    it "outputs the blocked list" do
      printed = capture_stdout do
        Ayadn::View.new.show_list_blocked(users)
      end
      expect(printed).to include *['List of users you blocked', '@mrtest', '@bond', 'Mr Test']
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
        Ayadn::View.new.show_posts(Ayadn::StreamObject.new(stream))
      end
      expect(printed).to include "23184500"
      expect(printed).to include "Backer of the Day"
      expect(printed).to include '23184932'
      expect(printed).to include '20:11:14'
      expect(printed).to include 'too big for humans to check'
      expect(printed).to include 'https://app.net/b/m6bk3'
    end
  end

  describe "#show_raw" do
    it 'outputs the raw stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_raw(Ayadn::StreamObject.new(stream))
      end
      expect(printed).to include '"created_at": "2013-05-19T22:33:57Z"'
    end
  end

  describe "#show_simple_post" do
    it 'outputs one post' do
      printed = capture_stdout do
        Ayadn::View.new.show_simple_post([Ayadn::StreamObject.new(stream).posts[0]])
      end
      expect(printed).to include "23187443"
      expect(printed).to include "Julia Cory"
    end
  end

  describe "#show_posts_with_index" do
    it 'outputs the indexed stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts_with_index(Ayadn::StreamObject.new(stream))
      end
      expect(printed).to include "001"
      expect(printed).to include "Backer of the Day"
    end
  end

  describe "#show_userinfos" do
    before do
      rest.stub(:get_response_from)
    end
    it "outputs user info" do
      printed = capture_stdout do
        Ayadn::View.new.show_userinfos(Ayadn::UserObject.new(user_e['data']), "")
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
