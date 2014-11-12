require 'spec_helper'
require 'helpers'

def init_stubs
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
        link: :magenta,
        excerpt: :green
      },
      timeline: {
        directed: 1,
        html: 0,
        annotations: 1,
        source: true,
        symbols: true,
        real_name: true,
        date: true,
        spinner: true,
        debug: false
      },
      formats: {
        table: {width: 75},
        list: {reverse: true}
      },
      counts: {
        default: 50,
        unified: 100,
        global: 100,
        checkins: 100,
        conversations: 50,
        photos: 50,
        trending: 100,
        mentions: 100,
        convo: 100,
        posts: 100,
        messages: 50,
        search: 200,
        whoreposted: 50,
        whostarred: 50,
        whatstarred: 100,
        files: 100
      },
      scroll: {
        timer: 3
      },
      movie: {
        hashtag: 'nowwatching'
      },
      tvshow: {
        hashtag: 'nowwatching'
      },
      nicerank: {
        threshold: 2.1,
        cache: 48,
        filter: true,
        unranked: false
      },
      backup: {
        posts: false,
        messages: false,
        lists: false
      },
      marker: {
        messages: true
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
        log: 'spec/mock'
      }
    })
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
      expect(Ayadn::Settings.options[:scroll][:timer]).to eq 3
      Ayadn::SetScroll.new.timer('2')
      expect(Ayadn::Settings.options[:scroll][:timer]).to eq 2
      Ayadn::SetScroll.new.timer('4.2')
      expect(Ayadn::Settings.options[:scroll][:timer]).to eq 4
      Ayadn::SetScroll.new.timer('0')
      expect(Ayadn::Settings.options[:scroll][:timer]).to eq 3
      Ayadn::SetScroll.new.timer('johnson')
      expect(Ayadn::Settings.options[:scroll][:timer]).to eq 3
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetColor do
  before do
    init_stubs
  end

  describe "#" do
    it "creates a default value" do
      colors_list = %w{red green magenta cyan yellow blue white black}
      %w{id index username name date link dots hashtags mentions source symbols debug}.each do |meth|
        command = meth.to_sym
        color = colors_list.sample
        Ayadn::SetColor.new.send(command, color)
        expect(Ayadn::Settings.options[:colors][command]).to eq color.to_sym
      end
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
      expect(Ayadn::Settings.options[:formats][:table][:width]).to eq 80
    end
    it "creates a default table width" do
      Ayadn::SetFormats.new.send(:table, ['width', '33'])
      expect(Ayadn::Settings.options[:formats][:table][:width]).to eq 75
    end
    it "creates a default table width" do
      Ayadn::SetFormats.new.send(:table, ['width', 'yolo'])
      expect(Ayadn::Settings.options[:formats][:table][:width]).to eq 75
    end
  end

  describe "#list" do
    it "creates a default list order" do
      Ayadn::SetFormats.new.send(:list, ['reverse', 'false'])
      expect(Ayadn::Settings.options[:formats][:list][:reverse]).to eq false
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

describe Ayadn::SetTimeline do
  before do
    init_stubs
  end

  describe "#" do
    it "creates a default value" do
      %w{directed source symbols real_name date spinner debug compact}.each do |meth|
        command = meth.to_sym
        Ayadn::SetTimeline.new.send(command, 'true')
        expect(Ayadn::Settings.options[:timeline][command]).to eq true
        printed = capture_stdout do
          expect(lambda {Ayadn::SetTimeline.new.send(command, 'yolo')}).to raise_error(SystemExit)
        end
      end
    end
  end

  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetCounts do
  before do
    init_stubs
  end

  describe "#" do
    it "creates a default value" do
      %w{default unified global checkins conversations photos trending mentions convo posts messages search whoreposted whostarred whatstarred files}.each do |meth|
        command = meth.to_sym
        Ayadn::SetCounts.new.send(command, '199')
        expect(Ayadn::Settings.options[:counts][command]).to eq 199
        printed = capture_stdout do
          Ayadn::SetCounts.new.send(command, '333')
        end
      end
    end
  end
end

describe Ayadn::SetMarker do
  before do
    init_stubs
  end

  describe "#messages" do
    it "creates a default value" do
      expect(Ayadn::Settings.options[:marker][:messages]).to eq true
      Ayadn::SetMarker.new.messages('0')
      expect(Ayadn::Settings.options[:marker][:messages]).to eq false
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
      expect(Ayadn::Settings.options[:backup][:posts]).to eq false
      Ayadn::SetBackup.new.posts('1')
      expect(Ayadn::Settings.options[:backup][:posts]).to eq true
    end
  end
  describe "#messages" do
    it "creates a default value" do
      expect(Ayadn::Settings.options[:backup][:messages]).to eq false
      Ayadn::SetBackup.new.messages('True')
      expect(Ayadn::Settings.options[:backup][:messages]).to eq true
    end
  end
  describe "#lists" do
    it "creates a default value" do
      expect(Ayadn::Settings.options[:backup][:lists]).to eq false
      Ayadn::SetBackup.new.lists('YES')
      expect(Ayadn::Settings.options[:backup][:lists]).to eq true
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

describe Ayadn::SetMovie do
  before do
    init_stubs
  end
  describe "#hashtag" do
    it "creates a new hashtag default" do
      expect(Ayadn::Settings.options[:movie][:hashtag]).to eq 'nowwatching'
      Ayadn::SetMovie.new.hashtag('yolo')
      expect(Ayadn::Settings.options[:movie][:hashtag]).to eq 'yolo'
    end
  end
  after do
    File.delete('spec/mock/ayadn.log')
  end
end

describe Ayadn::SetTVShow do
  before do
    init_stubs
  end
  describe "#hashtag" do
    it "creates a new hashtag default" do
      expect(Ayadn::Settings.options[:tvshow][:hashtag]).to eq 'nowwatching'
      Ayadn::SetTVShow.new.hashtag('yolo')
      expect(Ayadn::Settings.options[:tvshow][:hashtag]).to eq 'yolo'
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
      expect(Ayadn::Settings.options[:nicerank][:threshold]).to eq 2.1
      Ayadn::SetNiceRank.new.threshold('3')
      expect(Ayadn::Settings.options[:nicerank][:threshold]).to eq 3
      Ayadn::SetNiceRank.new.threshold('3.2')
      expect(Ayadn::Settings.options[:nicerank][:threshold]).to eq 3.2
    end
  end
  describe "#filter" do
    it "creates a new filter default" do
      expect(Ayadn::Settings.options[:nicerank][:filter]).to eq true
      Ayadn::SetNiceRank.new.filter('false')
      expect(Ayadn::Settings.options[:nicerank][:filter]).to eq false
      Ayadn::SetNiceRank.new.filter('1')
      expect(Ayadn::Settings.options[:nicerank][:filter]).to eq true
      printed = capture_stdout do
        expect(lambda {Ayadn::SetNiceRank.new.filter('6')}).to raise_error(SystemExit)
      end
    end
  end
  describe "#unranked" do
    it "creates a new unranked default" do
      expect(Ayadn::Settings.options[:nicerank][:unranked]).to eq false
      Ayadn::SetNiceRank.new.unranked('true')
      expect(Ayadn::Settings.options[:nicerank][:unranked]).to eq true
      Ayadn::SetNiceRank.new.unranked('0')
      expect(Ayadn::Settings.options[:nicerank][:unranked]).to eq false
      printed = capture_stdout do
        expect(lambda {Ayadn::SetNiceRank.new.unranked('yolo')}).to raise_error(SystemExit)
      end
    end
  end
  after do
    File.delete('spec/mock/ayadn.log')
  end
end
