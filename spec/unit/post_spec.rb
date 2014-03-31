require 'spec_helper'
require 'helpers'
require 'json'
require 'io/console'

describe Ayadn::Post do
  before do
    Ayadn::Settings.stub(:config).and_return({
        identity: {
          username: 'test'
        },
        post_max_length: 256,
        message_max_length: 2048
      })
    Ayadn::Settings.stub(:user_token).and_return("XXX")
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::CNX.stub(:get_response_from).and_return(JSON.parse(File.read("spec/mock/stream.json")))
    Ayadn::CNX.stub(:post).and_return({meta:{code:'200'},data:{}})
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

  describe "#post" do
    it "should post" do
      printed = capture_stdout do
        post.post(["Hello from RSpec!","It rocks!"])
      end
      expect(printed).to include "Hello from RSpec"
    end
  end

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
