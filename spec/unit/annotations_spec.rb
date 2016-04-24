require 'spec_helper'
require 'helpers'
require 'json'

describe Ayadn::Annotations do

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
      })
    )
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
    Ayadn::Errors.stub(:warn).and_return("warned")
    Ayadn::Logs.stub(:rec).and_return("logged")
    Ayadn::FileOps.stub(:make_paths).and_return(['~/your/path/cat.jpg', '~/your/path/dog.png']) # STUB1
    Ayadn::FileOps.stub(:upload_files).and_return([{'data' => {'id' => 3312,'file_token' => '0x3312-YOLO'}},{'data' => {'id' => 5550,'file_token' => '0x5550-WOOT'}}])
  end

  let(:rest) {Ayadn::CNX}

  describe "#base" do
    it "creates basic annotations" do
      ann = Ayadn::Annotations.new({})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>'shoes', "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}]
    end
  end

  describe "#youtube" do
    before do
      rest.stub(:download).and_return({'width' => 33, 'height' => 12}.to_json)
    end
    it "creates youtube annotations" do
      ann = Ayadn::Annotations.new({title: 'WUT', source: 'tEsT', options: {youtube: ['http://yolo']}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>"shoes", "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"net.app.core.oembed", "value"=>{"version"=>"1.0", "type"=>"video", "provider_name"=>"YouTube", "provider_url"=>"http://youtube.com/", "width"=>33, "height"=>12, "title"=>nil, "author_name"=>nil, "author_url"=>nil, "embeddable_url"=>"http://yolo", "html"=>nil, "thumbnail_url"=>nil, "thumbnail_height"=>nil, "thumbnail_width"=>nil}}, {"type"=>"com.ayadn.youtube", "value"=>{"title"=>nil, "link"=>"http://yolo"}}]
    end
  end

  describe "#vimeo" do
    before do
      rest.stub(:download).and_return({'title' => 'yolo'}.to_json)
    end
    it "creates vimeo annotations" do
      ann = Ayadn::Annotations.new({title: 'WUT', source: 'tEsT', options: {vimeo: ['http://yolo'],}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>"shoes", "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"net.app.core.oembed", "value"=>{"version"=>"1.0", "type"=>"video", "provider_name"=>"Vimeo", "provider_url"=>"http://vimeo.com/", "width"=>nil, "height"=>nil, "title"=>"yolo", "author_name"=>nil, "author_url"=>nil, "embeddable_url"=>"http://yolo", "html"=>nil, "thumbnail_url"=>nil, "thumbnail_height"=>nil, "thumbnail_width"=>nil}}, {"type"=>"com.ayadn.vimeo", "value"=>{"title"=>"yolo", "link"=>"http://yolo"}}]
    end
  end

  describe "#nowplaying --silent" do
    it "creates nowplaying --silent annotations" do
      ann = Ayadn::Annotations.new({source: 'wadawadawada', options: {nowplaying: true, no_url: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>'shoes', "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.nowplaying", "value"=>{"status"=>"no-url", "source"=>"wadawadawada"}}]
    end
  end

  describe "#nowplaying" do
    it "creates nowplaying annotations" do
      ann = Ayadn::Annotations.new({title: 'ibelieveicanfly', artist: 'big jim', artwork: 'http://ahah', link: 'http://ohoh', source: 'fake', width: 9000, height: 30000, artwork_thumb: 'http://hihi', width_thumb: 9, height_thumb: 3, options: {nowplaying: true}})
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>'shoes', "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"com.ayadn.nowplaying", "value"=>{"title"=>"ibelieveicanfly", "artist"=>"big jim", "artwork"=>"http://ahah", "link"=>"http://ohoh", "source"=>"fake"}}, {"type"=>"net.app.core.oembed", "value"=>{"version"=>"1.0", "type"=>"photo", "width"=>9000, "height"=>30000, "title"=>"ibelieveicanfly", "url"=>"http://ahah", "embeddable_url"=>"http://ahah", "provider_url"=>"https://itunes.apple.com", "provider_name"=>"iTunes", "thumbnail_url"=>"http://hihi", "thumbnail_width"=>9, "thumbnail_height"=>3}}]
    end
  end

  describe "#files" do
    it "creates files annotations" do
      ann = Ayadn::Annotations.new({options: {embed: ['whatever.jpg', 'another.png']}}) # fake array, cf STUB1
      expect(ann.content).to eq [{"type"=>"com.ayadn.user", "value"=>{"+net.app.core.user"=>{"user_id"=>"@test", "format"=>"basic"}, "env"=>{"platform"=>'shoes', "ruby"=>"0", "locale"=>"gibberish"}}}, {"type"=>"com.ayadn.client", "value"=>{"url"=>"https://github.com/ericdke/na", "author"=>{"name"=>"Eric Dejonckheere", "username"=>"ericd", "id"=>"69904", "email"=>"eric@aya.io"}, "version"=>"wee"}}, {"type"=>"net.app.core.oembed", "value"=>{"+net.app.core.file"=>{"file_id"=>3312, "file_token"=>"0x3312-YOLO", "format"=>"oembed"}}}, {"type"=>"net.app.core.oembed", "value"=>{"+net.app.core.file"=>{"file_id"=>5550, "file_token"=>"0x5550-WOOT", "format"=>"oembed"}}}]
    end
  end

end
