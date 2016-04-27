require 'spec_helper'
require 'helpers'
require 'json'

describe Ayadn::Workers do

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
    global_hash = {
      scrolling: false,
      force: false
    }
    Ayadn::Settings.stub(:global).and_return(
      JSON.parse(global_hash.to_json, object_class: OpenStruct)
    )
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::Databases.stub(:blacklist).and_return("blacklist")
    Ayadn::Databases.stub(:users).and_return("users")
    Ayadn::Databases.stub(:get_index_length).and_return(50)
    Ayadn::Databases.stub(:get_post_from_index).and_return(30000)
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
  let(:list) { {"007"=>["bond", "James Bond", true, true, 7], "666"=>["mrtest", "Mr Test", false, false, 33012]} }

  describe "#build_posts" do
    it "builds posts hash from stream" do
      posts = @workers.build_posts(Ayadn::StreamObject.new(data).posts)
      p1 = posts.select { |post| post.id == 23187363 }.first
      p2 = posts.select { |post| post.id == 23184500 }.first
      p3 = posts.select { |post| post.id == 23185033 }.first
      p4 = posts.select { |post| post.id == 23187443 }.first
      expect(posts.length).to eq 10
      expect(p1.name).to eq 'App.net Staff'
      expect(p2.username).to eq 'wired'
      expect(p3.handle).to eq '@hackernews'
      expect(p2.links).to eq ['http://ift.tt/1mtTrU9']
      expect(p4.source_name).to eq 'IFTTT'
      expect(p4.thread_id).to eq '23187443'
      expect(p4.text).to include 'Jagulsan. by Julia Cory'
      expect(p4.is_starred).to be false
      expect(p4.is_repost).to be false
      expect(p4.is_reply).to be false
      expect(p4.directed_to).to be false
      expect(p4.has_checkins).to be false
      expect(p4.mentions).to eq []
      expect(p4.checkins).to be_empty
    end
    it "gets oembed link from checkins post" do
      posts = @workers.build_posts(Ayadn::StreamObject.new(checkins).posts)
      p1 = posts.select { |post| post.id == 27101186 }.first
      p2 = posts.select { |post| post.id == 27080492 }.first
      p3 = posts.select { |post| post.id == 27073989 }.first
      expect(p1.links).to eq ["https://photos.app.net/27101186/1"]
      expect(p2.links).to eq ["http://sprintr.co/27080492"]
      expect(p3.links).to eq ["http://pic.favd.net/27073989", "https://photos.app.net/27073989/1"]
    end
  end

  describe "#all_but_me" do
    it "gets rid of 'me' and adds arobase if needed to other usernames" do
      names = @workers.all_but_me(['yolo', '@james', 'me'])
      expect(names).to eq ['@yolo', '@james']
    end
  end

  describe "#get_post_from_index" do
    it "returns the true post id if number is not in index" do
      expect(@workers.get_post_from_index("30000")).to eq 30000
    end
  end

  describe "#links_from_posts" do
    it "extract links" do
      links = @workers.links_from_posts(Ayadn::StreamObject.new(data))
      expect(links).to eq ["http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259", "https://app.net/b/m6bk3", "http://bit.ly/1cr16vM", "http://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745", "http://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M", "http://news.ycombinator.com/item?id=7264886", "http://ift.tt/1d0TA7I", "http://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427", "http://Experiment.com", "http://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/", "http://news.ycombinator.com/item?id=7265540", "http://feeds.popsci.com/c/34567/f/632419/s/374c6496/sc/38/l/0L0Spopsci0N0Carticle0Cscience0Ccat0Ebites0Eare0Elinked0Edepression/story01.htm?utm_medium=App.net&utm_source=PourOver", "http://ift.tt/1mtTrU9"]
    end
  end

  describe "#extract_hashtags" do
    it "extracts hashtags" do
      tags = @workers.extract_hashtags(Ayadn::StreamObject.new(data).posts[0])
      expect(tags).to eq ['photography']
    end
  end

  describe "#extract_links" do
    it "extracts links" do
      links = @workers.extract_links(Ayadn::StreamObject.new(data).posts[0])
      expect(links).to eq ['http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259']
    end
  end

  describe "#extract_users" do
    it "extracts users" do
      usr = @workers.extract_users(users_list[0])
      expect(usr["52985"]).to eq ["schmidt_fu", "Florian Schmidt", true, true, 11087]
      expect(usr["185581"]).to eq ["aya_tests", "Big Jim", true, true, 1414]
      expect(usr["69904"]).to eq ["ericd", "Eric Dejonckheere", nil, nil, 7030]
    end
  end

  describe "#extract_checkins" do
    it "extracts checkins" do
      posts = @workers.build_posts(Ayadn::StreamObject.new(checkins).posts)
      p1 = posts.select { |post| post.id == 27101186 }.first
      p2 = posts.select { |post| post.id == 26947690 }.first
      expect(posts.length).to eq 10
      expect(p1.has_checkins).to be true
      expect(p1.checkins[:name]).to eq "Hobbs State Park"
      expect(p1.checkins[:address]).to eq "21392 E Highway 12"
      expect(p1.checkins[:address_extended]).to be nil
      expect(p1.checkins[:locality]).to eq "Rogers"
      expect(p2.has_checkins).to be true
      expect(p2.checkins[:categories]).to eq "Landmarks"
      expect(p2.checkins[:country_code]).to eq "us"
      expect(p2.mentions).to eq ["tuaw"]
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
      expect(printed).to include "33012"
      expect(printed).to include "7"
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
      expect(printed).to include "33012"
      expect(printed).to include "7"
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
      expect(printed).to include "33012"
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
      expect(printed).to include "33012"
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
