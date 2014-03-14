require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::View do

  before do
    Ayadn::Settings.load_config
    Ayadn::Settings.get_token
    Ayadn::Settings.init_config
    Ayadn::Logs.create_logger
    Ayadn::Databases.open_databases
  end

  after do
    Ayadn::Databases.close_all
  end

  describe "#settings" do
    it 'outputs the settings' do
      printed = capture_stdout do
        Ayadn::View.new.show_settings
      end
      expect(printed).to include "Ayadn settings"
      expect(printed).to include "timeline"
      expect(printed).to include "counts"
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
      expect(printed).to include "\e[0m\n\nBacker of the Day"
    end
  end

  describe "#show_posts_with_index" do
    it 'outputs the indexed stream' do
      printed = capture_stdout do
        Ayadn::View.new.show_posts_with_index(stream['data'], {})
      end
      expect(printed).to include "001"
      expect(printed).to include "\e[0m\n\nBacker of the Day"
    end
  end

  let(:user_m) { JSON.parse(File.read("spec/mock/@m.json")) }

  describe "#show_userinfos" do
    it "outputs user info" do
      printed = capture_stdout do
        Ayadn::View.new.show_userinfos(user_m['data'])
      end
      expect(printed).to include "Real name\t\t\e[0m\e[35mMartin Jopson"
      expect(printed).to include "Username\t\t\e[0m\e[32m@m"
    end
  end

  let(:user_e) { JSON.parse(File.read("spec/mock/@ericd.json")) }

  describe "#show_userinfos" do
    it "outputs user info" do
      printed = capture_stdout do
        Ayadn::View.new.show_userinfos(user_e['data'])
      end
      expect(printed).to include "Sound engineer"
      expect(printed).to include "aya.io"
    end
  end








end
