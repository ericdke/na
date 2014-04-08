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

  describe "#show_posts" do
    it 'outputs the stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts(stream['data'], {})
      end
      expect(printed).to include "23184500"
      expect(printed).to include "Backer of the Day"
    end
  end

  describe "#show_simple_post" do
    it 'outputs one post' do
      printed = capture_stdout do
        Ayadn::View.new.show_simple_post([stream['data'][0]], {})
      end
      expect(printed).to include "23187443"
      expect(printed).to include "Julia Cory"
    end
  end

  describe "#show_posts_with_index" do
    it 'outputs the indexed stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts_with_index(stream['data'], {})
      end
      expect(printed).to include "001"
      expect(printed).to include "Backer of the Day"
    end
  end

  let(:user_e) { JSON.parse(File.read("spec/mock/@ericd.json")) }

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

  let(:followers) { JSON.parse(File.read("spec/mock/fwr_@ayadn.json")) }

  describe "#show_list_followers" do
    it "outputs the list of followers" do
      list = Ayadn::Workers.extract_users(followers[0])
      printed = capture_stdout do
        Ayadn::View.new.show_list_followers(list, '@ayadn')
      end
      expect(printed).to include "@ericd"
      expect(printed).to include "Nicolas Maumont"
    end
  end




end
