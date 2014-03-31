require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::Post do
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
        version: Ayadn::VERSION
      })
    Ayadn::Settings.stub(:user_token).and_return('XXX')
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
  end

  let(:post) { Ayadn::Post.new }

  describe "#post" do
    it "should raise an error if args are empty" do
      printed = capture_stdout do
        post.post([])
      end
      expect(printed).to include "You should provide some text."
    end
  end

  # let(:rest) {RestClient = double}
  # let(:res) {response = double}
  # let(:db) {Ayadn::Databases = double}

  # describe "#post" do
  #   before do
  #     db.stub(:blacklist) {"x"}
  #     res.stub(:code) {200}
  #     rest.stub(:post) {File.read("spec/mock/posted.json")}
  #   end
  #   # Those 2 tests return a fake response, but this fake
  #   # response wouldn't be returned if the tests failed
  #   # I should intercept what goes into the fake RestClient
  #   # instead, but have no idea how to do it at the moment ¯\(ツ)/¯
  #   #
  #   # As their warning messages are pretty annoying, I disabled
  #   # them but you can uncomment to run the test
  #   it "sends a post" do
  #     a = post.post(["TEST"])
  #     printed = capture_stdout do
  #       Ayadn::View.new.show_posted(a)
  #     end
  #     expect(printed).to include '@aya_tests'
  #     expect(printed).to include 'TEST'
  #   end
  #   it "sends a message" do
  #     a = post.send_message(666, 'TEST')
  #     printed = capture_stdout do
  #       Ayadn::View.new.show_posted(a)
  #     end
  #     expect(printed).to include '@aya_tests'
  #     expect(printed).to include 'TEST'
  #   end
  # end

  describe "#reply" do
    it "formats a reply" do
      new_post = "Hey guys!"
      replied_to = {1=>{:handle => "@test",:username => "test", :mentions => ["user1", "user2"]}}
      post.reply(new_post, replied_to).should eq "@test Hey guys! @user1 @user2"
      replied_to = {1=>{:handle => "@test",:username => "test", :mentions => ["user1", "test"]}}
      post.reply(new_post, replied_to).should eq "@test Hey guys! @user1"
      replied_to = {1=>{:handle => "@yo",:username => "test", :mentions => ["test", "lol"]}}
      post.reply(new_post, replied_to).should eq "@yo Hey guys! @lol"
    end
  end

  describe "#text_is_empty?" do
    it "checks if empty" do
      post.text_is_empty?(["allo"]).should be false
      post.text_is_empty?([""]).should be true
      post.text_is_empty?([]).should be true
    end
  end

  describe "#markdown_extract" do
    it "splits markdown" do
      post.markdown_extract("[ayadn](http://ayadn-app.net)").should eq ["ayadn", "http://ayadn-app.net"]
    end
  end

  describe "#get_markdown_text" do
    it "extracts markdown text" do
      post.get_markdown_text("[ayadn](http://ayadn-app.net)").should eq "ayadn"
    end
  end

  describe "#check_post_length" do
    it "checks normal post length" do
      post.check_post_length(["allo", "wtf"]).should be nil #no error
    end
  end

  describe "#check_message_length" do
    it "checks normal message length" do
      post.check_message_length(["allo", "wtf"]).should be nil #no error
    end
  end

end
