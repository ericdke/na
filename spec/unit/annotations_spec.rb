require 'spec_helper'
require 'helpers'
require 'json'

describe Ayadn::Annotations do

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
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::FileOps.stub(:make_paths).and_return(['~/your/path/cat.jpg', '~/your/path/dog.png']) # STUB1
    Ayadn::FileOps.stub(:upload_files).and_return([{'data' => {'id' => 3312,'file_token' => '0x3312-YOLO'}},{'data' => {'id' => 5550,'file_token' => '0x5550-WOOT'}}])
  end

  describe "#base" do
    it "creates basic annotations" do
      ann = Ayadn::Annotations.new({})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}]
    end
  end

  describe "#movie" do
    it "creates movie annotations" do
      ann = Ayadn::Annotations.new({title: 'WUT', source: 'tEsT', options: {movie: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.movie", "value"=>{"title"=>"WUT", "source"=>"tEsT"}}]
    end
  end

  describe "#tvshow" do
    it "creates tvshow annotations" do
      ann = Ayadn::Annotations.new({title: 'WUT', source: 'tEsT', options: {tvshow: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.tvshow", "value"=>{"title"=>"WUT", "source"=>"tEsT"}}]
    end
  end

  describe "#nowplaying --silent" do
    it "creates nowplaying --silent annotations" do
      ann = Ayadn::Annotations.new({source: 'wadawadawada', options: {nowplaying: true, no_url: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.nowplaying", "value"=>{"status"=>"no-url", "source"=>"wadawadawada"}}]
    end
  end

  describe "#nowplaying" do
    it "creates nowplaying annotations" do
      ann = Ayadn::Annotations.new({source: 'rspec', title: 'ibelieveicanfly', artist: 'big jim', artwork: 'http://ahah', link: 'http://ohoh', source: 'fake', width: 9000, height: 30000, artwork_thumb: 'http://hihi', width_thumb: 9, height_thumb: 3, options: {nowplaying: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.nowplaying", "value"=>{"title"=>"ibelieveicanfly", "artist"=>"big jim", "artwork"=>"http://ahah", "link"=>"http://ohoh", "source"=>"fake"}}, {"type"=>"net.app.core.oembed", "value"=>{"version"=>"1.0", "type"=>"photo", "width"=>9000, "height"=>30000, "title"=>"ibelieveicanfly", "url"=>"http://ahah", "embeddable_url"=>"http://ahah", "provider_url"=>"https://itunes.apple.com", "provider_name"=>"iTunes", "thumbnail_url"=>"http://hihi", "thumbnail_width"=>9, "thumbnail_height"=>3}}]
    end
  end

  describe "#files" do
    it "creates files annotations" do
      ann = Ayadn::Annotations.new({options: {embed: ['whatever.jpg', 'another.png']}}) # fake array, cf STUB1
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>nil, "ruby"=>"2.1.2", "locale"=>"fr_FR.UTF-8"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"http://ayadn-app.net", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"net.app.core.oembed", "value"=>{"+net.app.core.file"=>{"file_id"=>3312, "file_token"=>"0x3312-YOLO", "format"=>"oembed"}}}, {"type"=>"net.app.core.oembed", "value"=>{"+net.app.core.file"=>{"file_id"=>5550, "file_token"=>"0x5550-WOOT", "format"=>"oembed"}}}]
    end
  end

end
