require 'spec_helper'
require 'helpers'

module Ayadn
  class Errors
    def self.global_error(args)
      puts args[:error]
      puts args[:caller]
    end
  end
end

describe Ayadn::Action do
  before do
    Ayadn::Settings.stub(:options).and_return(
      {
        timeline: {
          directed: 1,
          html: 0,
          source: true,
          symbols: true,
          name: true,
          date: true,
          spinner: true,
          debug: false,
          compact: false
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
        formats: {
          table: {
            width: 75
          }
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
          debug: :red,
          excerpt: :green
        },
        backup: {
          posts: false,
          messages: false,
          lists: false
        },
        scroll: {
          timer: 3
        },
        nicerank: {
          threshold: 2.1,
          filter: false,
          unranked: false
        },
        nowplaying: {},
        movie: {
          hashtag: 'nowwatching'
        },
        tvshow: {
          hashtag: 'nowwatching'
        },
        blacklist: {
          active: true
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
    Ayadn::Settings.stub(:global).and_return({
      scrolling: false,
      force: false
    })
    Dir.stub(:home).and_return("spec/mock")
    Ayadn::Settings.stub(:get_token).and_return('XYZ')
    Ayadn::Settings.stub(:user_token).and_return('XYZ')
    Ayadn::Settings.stub(:check_for_accounts).and_return([nil, nil, nil, "spec/mock"])
    Ayadn::Settings.stub(:config_file)
    Ayadn::Settings.stub(:create_api_file)
    Ayadn::Settings.stub(:create_version_file)
    Ayadn::Databases.stub(:blacklist).and_return("blacklist")
    Ayadn::Databases.stub(:users).and_return("users")
    Ayadn::Databases.stub(:get_index_length).and_return(50)
    Ayadn::Databases.stub(:get_post_from_index).and_return(3333333333333)
    Ayadn::Databases.stub(:is_in_blacklist?).and_return(false)
    Ayadn::Databases.stub(:has_new?).and_return(true)
    Ayadn::Databases.stub(:add_to_users_db_from_list)
  end
  let(:stream) { File.read("spec/mock/stream.json") } 
  let(:mentions) { File.read("spec/mock/mentions.json") }
  let(:list) { File.read("spec/mock/fwr_@ayadn.json") }
  let(:ranks) { JSON.parse(File.read("spec/mock/nicerank.json")) }
  let(:cnx) {Ayadn::CNX}
  describe "#Global" do
    before do
      cnx.stub(:get)
      cnx.stub(:get_response_from).and_return(stream)
      Ayadn::NiceRank.stub(:get_ranks).and_return(ranks)
    end
    it "gets Global" do
      printed = capture_stdout do
        puts Ayadn::Action.new.global({})
      end
      expect(printed).to include "\e[H\e[2J\n\e[34m23184500\e[0m \e[32m@wired\e[0m \e[35mWired\e[0m \e[36m2014-02-19 20:04:43\e[0m \e[36m[IFTTT]\e[0m\n\nAn F1 Run Captured in Insane 360-Degree Interactive Video http://ift.tt/1mtTrU9\n\n\e[33mhttp://ift.tt/1mtTrU9\e[0m\n\n\n\e[34m23184932\e[0m \e[32m@popsci\e[0m \e[35mPopular Science\e[0m \e[36m2014-02-19 20:09:03\e[0m \e[36m[PourOver]\e[0m\n\nCat Bites Are Linked To Depression [feeds.popsci.com]\n\n\e[33mhttp://feeds.popsci.com/c/34567/f/632419/s/374c6496/sc/38/l/0L0Spopsci0N0Carticle0Cscience0Ccat0Ebites0Eare0Elinked0Edepression/story01.htm?utm_medium=App.net&utm_source=PourOver\e[0m\n\n\n\e[34m23185033\e[0m \e[32m@hackernews\e[0m \e[35mHacker News\e[0m \e[36m2014-02-19 20:10:23\e[0m \e[36m[Dev Lite]\e[0m\n\nHow Microryza Acquired the Domain Experiment.com\nhttp://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/\n» Comments [news.ycombinator.com]\n\n\e[33mhttp://Experiment.com\e[0m\n\e[33mhttp://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/\e[0m\n\e[33mhttp://news.ycombinator.com/item?id=7265540\e[0m\n\n\n\e[34m23185081\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:11:14\e[0m \e[36m[IFTTT]\e[0m\n\nEntre ciel et terre by Andre Villeneuve http://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427\e[0m\n\n\n\e[34m23185112\e[0m \e[32m@appadvice\e[0m \e[35mAppAdvice.com\e[0m \e[36m2014-02-19 20:11:35\e[0m \e[36m[IFTTT]\e[0m\n\nEnjoy Ghoulish Multiplayer Brawls In Fright Fight http://ift.tt/1d0TA7I\n\n\e[33mhttp://ift.tt/1d0TA7I\e[0m\n\n\n\e[34m23185830\e[0m \e[32m@hackernews\e[0m \e[35mHacker News\e[0m \e[36m2014-02-19 20:20:34\e[0m \e[36m[Dev Lite]\e[0m\n\nWikipedia-size maths proof too big for humans to check\nhttp://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M\n» Comments [news.ycombinator.com]\n\n\e[33mhttp://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M\e[0m\n\e[33mhttp://news.ycombinator.com/item?id=7264886\e[0m\n\n\n\e[34m23186223\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:25:51\e[0m \e[36m[IFTTT]\e[0m\n\nArizona Wildflowers by Lisa Holloway http://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745\e[0m\n\n\n\e[34m23186340\e[0m \e[32m@arstechnica\e[0m \e[35mArs Technica\e[0m \e[36m2014-02-19 20:27:19\e[0m \e[36m[PourOver]\e[0m\n\nFCC thinks it can overturn state laws that restrict public broadband http://bit.ly/1cr16vM\n\n\e[33mhttp://bit.ly/1cr16vM\e[0m\n\n\n\e[34m23187363\e[0m \e[32m@adn\e[0m \e[35mApp.net Staff\e[0m \e[36m2014-02-19 20:39:34\e[0m \e[36m[Alpha]\e[0m\n\nBacker of the Day: Should Thinkful teach a class on Angular? https://app.net/b/m6bk3\n\n\e[33mhttps://app.net/b/m6bk3\e[0m\n\n\n\e[34m23187443\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:40:56\e[0m \e[36m[IFTTT]\e[0m\n\nJagulsan. by Julia Cory ™  http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259\e[0m"
    end
  end
  describe "#Unified" do
    before do
      cnx.stub(:get_response_from).and_return(stream)
    end
    it "gets Unified" do
      printed = capture_stdout do
        puts Ayadn::Action.new.unified({})
      end
      expect(printed).to include "\e[H\e[2J\n\e[34m23184500\e[0m \e[32m@wired\e[0m \e[35mWired\e[0m \e[36m2014-02-19 20:04:43\e[0m \e[36m[IFTTT]\e[0m\n\nAn F1 Run Captured in Insane 360-Degree Interactive Video http://ift.tt/1mtTrU9\n\n\e[33mhttp://ift.tt/1mtTrU9\e[0m\n\n\n\e[34m23184932\e[0m \e[32m@popsci\e[0m \e[35mPopular Science\e[0m \e[36m2014-02-19 20:09:03\e[0m \e[36m[PourOver]\e[0m\n\nCat Bites Are Linked To Depression [feeds.popsci.com]\n\n\e[33mhttp://feeds.popsci.com/c/34567/f/632419/s/374c6496/sc/38/l/0L0Spopsci0N0Carticle0Cscience0Ccat0Ebites0Eare0Elinked0Edepression/story01.htm?utm_medium=App.net&utm_source=PourOver\e[0m\n\n\n\e[34m23185033\e[0m \e[32m@hackernews\e[0m \e[35mHacker News\e[0m \e[36m2014-02-19 20:10:23\e[0m \e[36m[Dev Lite]\e[0m\n\nHow Microryza Acquired the Domain Experiment.com\nhttp://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/\n» Comments [news.ycombinator.com]\n\n\e[33mhttp://Experiment.com\e[0m\n\e[33mhttp://priceonomics.com/how-microryza-acquired-the-domain-experimentcom/\e[0m\n\e[33mhttp://news.ycombinator.com/item?id=7265540\e[0m\n\n\n\e[34m23185081\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:11:14\e[0m \e[36m[IFTTT]\e[0m\n\nEntre ciel et terre by Andre Villeneuve http://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/hFi3AUnh_u8/61493427\e[0m\n\n\n\e[34m23185112\e[0m \e[32m@appadvice\e[0m \e[35mAppAdvice.com\e[0m \e[36m2014-02-19 20:11:35\e[0m \e[36m[IFTTT]\e[0m\n\nEnjoy Ghoulish Multiplayer Brawls In Fright Fight http://ift.tt/1d0TA7I\n\n\e[33mhttp://ift.tt/1d0TA7I\e[0m\n\n\n\e[34m23185830\e[0m \e[32m@hackernews\e[0m \e[35mHacker News\e[0m \e[36m2014-02-19 20:20:34\e[0m \e[36m[Dev Lite]\e[0m\n\nWikipedia-size maths proof too big for humans to check\nhttp://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M\n» Comments [news.ycombinator.com]\n\n\e[33mhttp://www.newscientist.com/article/dn25068-wikipediasize-maths-proof-too-big-for-humans-to-check.html#.UwTuA3gRq8M\e[0m\n\e[33mhttp://news.ycombinator.com/item?id=7264886\e[0m\n\n\n\e[34m23186223\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:25:51\e[0m \e[36m[IFTTT]\e[0m\n\nArizona Wildflowers by Lisa Holloway http://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/i4uhLN-4rd4/61484745\e[0m\n\n\n\e[34m23186340\e[0m \e[32m@arstechnica\e[0m \e[35mArs Technica\e[0m \e[36m2014-02-19 20:27:19\e[0m \e[36m[PourOver]\e[0m\n\nFCC thinks it can overturn state laws that restrict public broadband http://bit.ly/1cr16vM\n\n\e[33mhttp://bit.ly/1cr16vM\e[0m\n\n\n\e[34m23187363\e[0m \e[32m@adn\e[0m \e[35mApp.net Staff\e[0m \e[36m2014-02-19 20:39:34\e[0m \e[36m[Alpha]\e[0m\n\nBacker of the Day: Should Thinkful teach a class on Angular? https://app.net/b/m6bk3\n\n\e[33mhttps://app.net/b/m6bk3\e[0m\n\n\n\e[34m23187443\e[0m \e[32m@500px\e[0m \e[35m500px Popular Photos\e[0m \e[36m2014-02-19 20:40:56\e[0m \e[36m[IFTTT]\e[0m\n\nJagulsan. by Julia Cory ™  http://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259 \e[36m#photography\e[0m\n\n\e[33mhttp://feed.500px.com/~r/500px-best/~3/c2tMPEJVf6I/61517259\e[0m"
    end
  end
  describe "#Unified -i" do
    before do
      cnx.stub(:get_response_from).and_return(stream)
    end
    it "gets Unified, indexed" do
      printed = capture_stdout do
        puts Ayadn::Action.new.unified({index: true})
      end
      expect(printed).to include '001'
      expect(printed).to include '002'
      expect(printed).to include '010'
      expect(printed).to include '@wired'
      expect(printed).to include '@500px'
      expect(printed).to include 'An F1 Run Captured in Insane 360-Degree Interactive Video'
    end
  end
  describe "#Unified -x" do
    before do
      cnx.stub(:get_response_from).and_return(stream)
    end
    it "gets Unified, raw" do
      printed = capture_stdout do
        puts Ayadn::Action.new.unified({raw: true})
      end
      expect(printed).to include 'meta'
      expect(printed).to include '200'
      expect(printed).to include 'marker'
      expect(printed).to include 'you_blocked'
      expect(printed).to include 'd2rfichhc2fb9n.cloudfront.net/image/5/1Pfjg_QPxpJsmpz0qm-'
      expect(printed).to include 'you_can_subscribe'
    end
  end
  describe "#Mentions" do
    before do
      cnx.stub(:get_response_from).and_return(mentions)
    end
    it "gets Mentions" do
      printed = capture_stdout do
        puts Ayadn::Action.new.mentions(["aya_tests"],{})
      end
      expect(printed).to include '43418888'
      expect(printed).to include '@aya_tests'
      expect(printed).to include 'Big Jim'
      expect(printed).to include '[Ayadn]'
      expect(printed).to include '20:11:37'
      expect(printed).to include 'it’s fun talking to yourself'
    end
  end
  after do
    Ayadn::Databases.clear_users
    Ayadn::Databases.clear_pagination
    Ayadn::Databases.clear_index
    File.delete('spec/mock/ayadn.log')
  end
end