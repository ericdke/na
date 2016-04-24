require 'spec_helper'
require 'helpers'

def init_stubs
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
  Ayadn::Settings.stub(:user_token).and_return('XYZ')
  Ayadn::Settings.stub(:load_config)
  Ayadn::Settings.stub(:get_token)
  Ayadn::Settings.stub(:init_config)
  Dir.stub(:home).and_return('spec/mock/')
end

describe Ayadn::SetScroll do
  before do
    init_stubs
  end

  describe "#timer" do
    it "creates a default value" do
      expect(Ayadn::Settings.options.scroll.timer).to eq 3
      Ayadn::SetScroll.new.timer('2')
      expect(Ayadn::Settings.options.scroll.timer).to eq 2
      Ayadn::SetScroll.new.timer('4.2')
      expect(Ayadn::Settings.options.scroll.timer).to eq 4
      Ayadn::SetScroll.new.timer('0')
      expect(Ayadn::Settings.options.scroll.timer).to eq 3
      Ayadn::SetScroll.new.timer('johnson')
      expect(Ayadn::Settings.options.scroll.timer).to eq 3
    end
  end

  describe "#spinner" do
    it "creates a default value" do
      Ayadn::SetScroll.new.spinner('true')
      expect(Ayadn::Settings.options.scroll.spinner).to eq true
      Ayadn::SetScroll.new.spinner('false')
      expect(Ayadn::Settings.options.scroll.spinner).to eq false
      Ayadn::SetScroll.new.spinner('0')
      expect(Ayadn::Settings.options.scroll.spinner).to eq false
    end
  end

  describe "#date" do
    it "creates a default value" do
      Ayadn::SetScroll.new.date('true')
      expect(Ayadn::Settings.options.scroll.date).to eq true
      Ayadn::SetScroll.new.date('false')
      expect(Ayadn::Settings.options.scroll.date).to eq false
      Ayadn::SetScroll.new.date('0')
      expect(Ayadn::Settings.options.scroll.date).to eq false
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetFormats do
  before do
    init_stubs
  end

  describe "#table" do
    it "creates a default table width" do
      Ayadn::SetFormats.new.send(:table, ['width', '80'])
      expect(Ayadn::Settings.options.formats.table.width).to eq 80
    end
    it "creates a default table width" do
      Ayadn::SetFormats.new.send(:table, ['width', '33'])
      expect(Ayadn::Settings.options.formats.table.width).to eq 75
    end
    it "creates a default table width" do
      Ayadn::SetFormats.new.send(:table, ['width', 'yolo'])
      expect(Ayadn::Settings.options.formats.table.width).to eq 75
    end
  end

  describe "#list" do
    it "creates a default list order" do
      Ayadn::SetFormats.new.send(:list, ['reverse', 'false'])
      expect(Ayadn::Settings.options.formats.list.reverse).to eq false
    end
    it "raises an error" do
      printed = capture_stdout do
        expect(lambda {Ayadn::SetFormats.new.send(:list, ['reverse', 'yolo'])}).to raise_error(SystemExit)
      end
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetMarker do
  before do
    init_stubs
  end

  describe "#messages" do
    it "creates a default value" do
      expect(Ayadn::Settings.options.marker.messages).to eq true
      Ayadn::SetMarker.new.messages('0')
      expect(Ayadn::Settings.options.marker.messages).to eq false
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetBackup do
  before do
    init_stubs
  end

  describe "#posts" do
    it "creates a default value" do
      expect(Ayadn::Settings.options.backup.posts).to eq false
      Ayadn::SetBackup.new.posts('1')
      expect(Ayadn::Settings.options.backup.posts).to eq true
    end
  end
  describe "#messages" do
    it "creates a default value" do
      expect(Ayadn::Settings.options.backup.messages).to eq false
      Ayadn::SetBackup.new.messages('True')
      expect(Ayadn::Settings.options.backup.messages).to eq true
    end
  end
  describe "#lists" do
    it "creates a default value" do
      expect(Ayadn::Settings.options.backup.lists).to eq false
      Ayadn::SetBackup.new.lists('YES')
      expect(Ayadn::Settings.options.backup.lists).to eq true
    end
  end

  describe "#validate" do
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('0')
      expect(value).to eq false
    end
    it "raises error if incorrect boolean" do
      printed = capture_stdout do
        expect(lambda {Ayadn::SetBackup.new.validate('yolo')}).to raise_error(SystemExit)
      end
    end
  end
  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetNiceRank do
  before do
    init_stubs
  end
  describe "#threshold" do
    it "creates a new threshold default" do
      expect(Ayadn::Settings.options.nicerank.threshold).to eq 2.1
      Ayadn::SetNiceRank.new.threshold('3')
      expect(Ayadn::Settings.options.nicerank.threshold).to eq 3
      Ayadn::SetNiceRank.new.threshold('3.2')
      expect(Ayadn::Settings.options.nicerank.threshold).to eq 3.2
    end
  end
  describe "#filter" do
    it "creates a new filter default" do
      expect(Ayadn::Settings.options.nicerank.filter).to eq true
      Ayadn::SetNiceRank.new.filter('false')
      expect(Ayadn::Settings.options.nicerank.filter).to eq false
      Ayadn::SetNiceRank.new.filter('1')
      expect(Ayadn::Settings.options.nicerank.filter).to eq true
      printed = capture_stdout do
        expect(lambda {Ayadn::SetNiceRank.new.filter('6')}).to raise_error(SystemExit)
      end
    end
  end
  describe "#unranked" do
    it "creates a new unranked default" do
      expect(Ayadn::Settings.options.nicerank.unranked).to eq false
      Ayadn::SetNiceRank.new.unranked('true')
      expect(Ayadn::Settings.options.nicerank.unranked).to eq true
      Ayadn::SetNiceRank.new.unranked('0')
      expect(Ayadn::Settings.options.nicerank.unranked).to eq false
      printed = capture_stdout do
        expect(lambda {Ayadn::SetNiceRank.new.unranked('yolo')}).to raise_error(SystemExit)
      end
    end
  end
  after do
    File.delete('spec/mock/ayadn.log')
  end
end
