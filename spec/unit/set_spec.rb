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
      },
      scroll: {
        timer: 5
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
  Ayadn::Settings.stub(:load_config)
  Ayadn::Settings.stub(:get_token)
  Ayadn::Settings.stub(:init_config)
  Dir.stub(:home).and_return('spec/mock/')
end

describe Ayadn::SetScroll do
  before do
    init_stubs
  end
  describe "#validate" do
    it "validates a correct timer value" do
      timer = Ayadn::SetScroll.new.validate(3)
      expect(timer).to eq 3
    end
    it "validates a correct timer value" do
      timer = Ayadn::SetScroll.new.validate(1)
      expect(timer).to eq 1
    end
    it "validates a correct timer value" do
      timer = Ayadn::SetScroll.new.validate(2)
      expect(timer).to eq 2
    end
    it "validates a correct timer value" do
      timer = Ayadn::SetScroll.new.validate(10.2)
      expect(timer).to eq 10
    end
    it "validates a correct timer value" do
      timer = Ayadn::SetScroll.new.validate(1.1)
      expect(timer).to eq 1
    end
    it "sets a default if incorrect timer value" do
      timer = Ayadn::SetScroll.new.validate(0)
      expect(timer).to eq 3
    end
    it "sets a default if incorrect timer value" do
      timer = Ayadn::SetScroll.new.validate('johnson')
      expect(timer).to eq 3
    end
    it "sets a default if incorrect timer value" do
      timer = Ayadn::SetScroll.new.validate(-666)
      expect(timer).to eq 3
    end
    it "sets a default if incorrect timer value" do
      timer = Ayadn::SetScroll.new.validate(0.5)
      expect(timer).to eq 3
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
  describe "#validate" do
    it "validates a correct count value" do
      count = Ayadn::SetCounts.new.validate('1')
      expect(count).to eq 1
    end
    it "validates a correct count value" do
      count = Ayadn::SetCounts.new.validate('200')
      expect(count).to eq 200
    end
    it "raises error if incorrect count value" do
      printed = capture_stderr do
        expect(lambda {Ayadn::SetCounts.new.validate('201')}).to raise_error(SystemExit)
      end
      expect(printed).to include 'This paramater must be an integer between 1 and 200'
    end
    it "raises error if incorrect count value" do
      printed = capture_stderr do
        expect(lambda {Ayadn::SetCounts.new.validate('0')}).to raise_error(SystemExit)
      end
      expect(printed).to include 'This paramater must be an integer between 1 and 200'
    end
    it "raises error if incorrect count value" do
      printed = capture_stderr do
        expect(lambda {Ayadn::SetCounts.new.validate('yolo')}).to raise_error(SystemExit)
      end
      expect(printed).to include 'This paramater must be an integer between 1 and 200'
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
  describe "#validate" do
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('1')
      expect(value).to eq true
    end
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('true')
      expect(value).to eq true
    end
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('TrUe')
      expect(value).to eq true
    end
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('false')
      expect(value).to eq false
    end
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('fAlsE')
      expect(value).to eq false
    end
    it "validates a correct boolean" do
      value = Ayadn::SetBackup.new.validate('0')
      expect(value).to eq false
    end
    it "raises error if incorrect boolean" do
      printed = capture_stderr do
        expect(lambda {Ayadn::SetBackup.new.validate('yolo')}).to raise_error(SystemExit)
      end
      expect(printed).to include "You have to submit valid items. See 'ayadn -sg' for a list of valid parameters and values"
    end
  end
  after do
    File.delete('spec/mock/ayadn.log')
  end
end
