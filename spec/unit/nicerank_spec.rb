require 'spec_helper'
require 'helpers'
require 'json'
#require 'io/console'

describe Ayadn::NiceRank do
  before do
    Ayadn::Settings.stub(:options).and_return(
      {
        timeline: {
          directed: 1,
          deleted: 0,
          html: 0,
          annotations: 1,
          show_source: true,
          show_symbols: true,
          show_real_name: true,
          show_date: true,
          show_spinner: true,
          show_debug: false
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
          debug: :red
        },
        backup: {
          auto_save_sent_posts: false,
          auto_save_sent_messages: false,
          auto_save_lists: false
        },
        scroll: {
          timer: 3
        },
        nicerank: {
          threshold: 2.1,
          cache: 48,
          filter: true,
          filter_unranked: false
        },
        nowplaying: {},
        movie: {
          hashtag: 'nowwatching'
        },
        tvshow: {
          hashtag: 'nowwatching'
        }
      }
    )
    Ayadn::Settings.stub(:config).and_return({
        identity: {
          username: 'test',
          handle: '@test'
        },
        post_max_length: 256,
        message_max_length: 2048,
        version: 'wee'
      })
    Ayadn::Settings.stub(:user_token).and_return('XYZ')
    Ayadn::Settings.stub(:check_for_accounts)
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
  end

  let(:rest) {Ayadn::CNX = double} #verbose in RSpec output, but useful
  # let(:nicerank) { JSON.parse(File.read("spec/mock/nicerank.json")) }

  describe "#get_posts_day" do
    before do
      rest.stub(:get).and_return(File.read("spec/mock/nicerank.json"))
    end
    it "get posts/day for a user" do
      expect(rest).to receive(:get).with("http://api.nice.social/user/nicerank?ids=69904&show_details=Y")
      x = Ayadn::NiceRank.new.get_posts_day(['69904'])
      expect(x).to eq [{:id=>69904, :posts_day=>11.57}]
    end
  end
  describe "#from_ids" do
    before do
      rest.stub(:get).and_return(File.read("spec/mock/nicerank.json"))
    end
    it "get niceranks from user ids" do
      expect(rest).to receive(:get).with("http://api.nice.social/user/nicerank?ids=69904&show_details=Y")
      x = Ayadn::NiceRank.new.from_ids(['69904'])
      expect(x).to eq [{"user_id"=>69904,"rank"=>3.816259,"is_human"=>true,"user"=> {"username"=>"ericd","account_age"=>513,"following"=>277,"followers"=>261,"posts"=>5933,"stars"=>345,"posts_day"=>11.5653,"days_idle"=>0},"account"=> {"has_avatar"=>true,"has_bio"=>true,"has_cover"=>true,"is_verified"=>true,"is_human"=>true,"real_person"=>true},"stats"=>{"robo_posts"=>6,"post_count"=>294,"conversations"=>229,"links"=>36,"mentions"=>232,"questions"=>25}}]
    end
  end
end