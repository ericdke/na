require 'spec_helper'
require 'helpers'
require 'json'

describe Ayadn::Workers do

  before do
    Ayadn::Settings.stub(:options).and_return({
        colors: {
          hashtags: :cyan,
          mentions: :red,
          username: :green
        },
        timeline: {compact: false},
        formats: {table: {width: 75}, list: {reverse: true}}
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
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::Databases.stub(:blacklist).and_return("blacklist")
    Ayadn::Databases.stub(:users).and_return("users")
    Ayadn::Databases.stub(:get_index_length).and_return(50)
    Ayadn::Databases.stub(:is_in_blacklist?).and_return(false)
    Dir.stub(:home).and_return("spec/mock")
    @workers = Ayadn::Workers.new
    Ayadn::Databases.open_databases
  end

  let(:data) { JSON.parse(File.read("spec/mock/stream.json")) }
  let(:checkins) { JSON.parse(File.read("spec/mock/checkins.json")) }
  let(:regex_post) { JSON.parse(File.read("spec/mock/regex.json")) }
  let(:users_list) { JSON.parse(File.read("spec/mock/fwr_@ayadn.json")) }
  #let(:rest) {Ayadn::CNX = double} #verbose in RSpec output, but useful
  let(:rest) {Ayadn::CNX}
  let(:list) { {"007"=>["bond", "James Bond", true, true], "666"=>["mrtest", "Mr Test", false, false]} }

  describe "#build_posts" do
    it "builds posts hash from stream" do
      posts = @workers.build_posts(data['data'])
      expect(posts.length).to eq 10
      expect(posts[23187363][:name]).to eq 'App.net Staff'
      expect(posts[23184500][:username]).to eq 'wired'
      expect(posts[23185033][:handle]).to eq '@hackernews'
      expect(posts[23184500][:links]).to eq ['http://ift.tt/1mtTrU9']
      expect(posts[23187443][:source_name]).to eq 'IFTTT'
      expect(posts[23187443][:thread_id]).to eq '23187443'
      expect(posts[23187443][:text]).to include 'Jagulsan. by Julia Cory'
      expect(posts[23187443][:is_starred]).to be false
      expect(posts[23187443][:is_repost]).to be false
      expect(posts[23187443][:is_reply]).to be false
      expect(posts[23187443][:directed_to]).to be false
      expect(posts[23187443][:has_checkins]).to be false
      expect(posts[23187443][:mentions]).to eq []
      expect(posts[23187443][:checkins]).to be_empty
      expect(posts[23187443].length).to eq 33
    end
    it "gets oembed link from checkins post" do
      posts = @workers.build_posts(checkins['data'])
      expect(posts[27101186][:links]).to eq ["https://photos.app.net/27101186/1"]
      expect(posts[27080492][:links]).to eq ["http://sprintr.co/27080492"]
      expect(posts[27073989][:links]).to eq ["http://pic.favd.net/27073989", "https://photos.app.net/27073989/1"]
    end
  end

  describe "#all_but_me" do
    it "gets rid of 'me' and adds arobase if needed to other usernames" do
      names = @workers.all_but_me(['yolo', '@james', 'me'])
      expect(names).to eq ['@yolo', '@james']
    end
  end

  describe "#links_from_posts" do
    it "extract links" do
      links = @workers.links_from_posts(data)
      expect(links).to eq ["http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259", "https://app.net/b/m6bk3", "http://bit.ly/1cr16vM", "http://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745", "http://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M", "http://news.ycombinator.com/item?id=7264886", "http://ift.tt/1d0TA7I", "http://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427", "http://Experiment.com", "http://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/", "http://news.ycombinator.com/item?id=7265540", "http://feeds.popsci.com/c/34567/f/632419/s/374c6496/sc/38/l/0L0Spopsci0N0Carticle0Cscience0Ccat0Ebites0Eare0Elinked0Edepression/story01.htm?utm_medium=App.net&utm_source=PourOver", "http://ift.tt/1mtTrU9"]
    end
  end

  describe "#extract_hashtags" do
    it "extracts hashtags" do
      tags = @workers.extract_hashtags(data['data'][0])
      expect(tags).to eq ['photography']
    end
  end

  describe "#extract_links" do
    it "extracts links" do
      links = @workers.extract_links(data['data'][0])
      expect(links).to eq ['http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259']
    end
  end

  describe "#extract_users" do
    it "extracts users" do
      usr = @workers.extract_users(users_list[0])
      expect(usr["52985"]).to eq ["schmidt_fu", "Florian Schmidt", false, false]
      expect(usr["185581"]).to eq ["aya_tests", "@ericd's tests account", nil, nil]
      expect(usr["69904"]).to eq ["ericd", "Eric Dejonckheere", true, true]
    end
  end

  describe "#extract_checkins" do
    it "extracts checkins" do
      posts = @workers.build_posts(checkins['data'])
      expect(posts.length).to eq 10
      expect(posts[27101186][:has_checkins]).to be true
      expect(posts[27101186][:checkins][:name]).to eq "Hobbs State Park"
      expect(posts[27101186][:checkins][:address]).to eq "21392 E Highway 12"
      expect(posts[27101186][:checkins][:address_extended]).to be nil
      expect(posts[27101186][:checkins][:locality]).to eq "Rogers"
      expect(posts[26947690][:has_checkins]).to be true
      expect(posts[26947690][:checkins][:categories]).to eq "Landmarks"
      expect(posts[26947690][:checkins][:country_code]).to eq "us"
      expect(posts[26947690][:mentions]).to eq ["tuaw"]
    end
  end

  describe "#build_followers_list" do
    before do
      rest.stub(:get)
    end
    it 'builds the followers table list' do
      printed = capture_stdout do
        puts @workers.build_followers_list(list, "@test")
      end
      expect(printed).to include "@test"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_followings_list" do
    before do
      rest.stub(:get)
    end
    it 'builds the followings table list' do
      printed = capture_stdout do
        puts @workers.build_followings_list(list, "@test")
      end
      expect(printed).to include "@test"
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_muted_list" do
    before do
      rest.stub(:get)
    end
    it 'builds the muted table list' do
      printed = capture_stdout do
        puts @workers.build_muted_list(list)
      end
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#build_blocked_list" do
    before do
      rest.stub(:get)
    end
    it 'builds the blocked table list' do
      printed = capture_stdout do
        puts @workers.build_blocked_list(list)
      end
      expect(printed).to include "@bond"
      expect(printed).to include "Mr Test"
    end
  end

  describe "#add_arobase_if_missing" do
    it 'adds @ to username' do
      expect(@workers.add_arobase_if_missing(["user"])).to eq "@user"
    end
    it 'does nothing to @username' do
      expect(@workers.add_arobase_if_missing(["@user"])).to eq "@user"
    end
  end

  describe "#remove_arobase_if_present" do
    it "removes @ from username" do
      expect(@workers.remove_arobase_if_present(["@user"])).to eq ["user"]
      expect(@workers.remove_arobase_if_present(["user"])).to eq ["user"]
    end
  end

  describe "#colorize_text" do
    it "colorizes mentions and hashtags" do
      text = regex_post['data']['text']
      mentions = regex_post['data']['entities']['mentions']
      expect(@workers.colorize_text(text, mentions, ['false', 'true', 'test', 'regex'])).to eq "\e[36m#test\e[0m \e[36m#regex\e[0m\n@aya_tests's \e[36m#true\e[0m\n(@aya_tests) \e[36m#true\e[0m\n@AyA_TeSts \e[36m#true\e[0m\n@aya_test \e[36m#false\e[0m\naya@aya_tests.yolo \e[36m#false\e[0m\n-@aya_tests:ohai! \e[36m#true\e[0m\ntext,@aya_tests,txt \e[36m#true\e[0m"
    end
  end

end
