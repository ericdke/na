# encoding: utf-8
module Ayadn
  class App < Thor
    package_name "ayadn"

    %w{action api descriptions endpoints cnx view workers settings post status extend databases fileops logs pinboard set alias errors blacklist scroll authorize switch}.each { |r| require_relative "#{r}" }

    desc "timeline", "Show your App.net timeline, aka the Unified Stream (shortcut: -tl)"
    map "unified" => :timeline
    map "-u" => :timeline
    map "-tl" => :timeline
    long_desc Descriptions.unified
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def timeline
      Action.new.unified(options)
    end

    desc "checkins", "Show the Checkins Stream (shortcut: -ck)"
    map "-ck" => :checkins
    long_desc Descriptions.checkins
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def checkins
      Action.new.checkins(options)
    end

    desc "global", "Show the Global Stream (shortcut: -gl)"
    map "-gl" => :global
    long_desc Descriptions.global
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def global
      Action.new.global(options)
    end

    desc "trending", "Show the Trending Stream (shortcut: -tr)"
    map "-tr" => :trending
    long_desc Descriptions.trending
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def trending
      Action.new.trending(options)
    end

    # desc "photos", "Show the Photos Stream (shortcut: -ph)"
    # map "-ph" => :photos
    # long_desc Descriptions.photos
    # option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    # option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    # option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    # option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    # option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    # def photos
    #   Action.new.photos(options)
    # end

    desc "conversations", "Show the Conversations Stream (shortcut: -cq)"
    map "-cq" => :conversations
    long_desc Descriptions.conversations
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def conversations
      Action.new.conversations(options)
    end

    desc "mentions @USERNAME", "Show posts containing a mention of a @username (shortcut: -m)"
    map "-m" => :mentions
    long_desc Descriptions.mentions
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def mentions(*username)
      Action.new.mentions(username, options)
    end

    desc "userposts @USERNAME", "Show posts of @username (shortcut: -up)"
    map "-up" => :userposts
    long_desc Descriptions.posts
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def userposts(*username)
      Action.new.posts(username, options)
    end

    desc "interactions", "Show your recent ADN activity (shortcut: -int)"
    map "-int" => :interactions
    long_desc Descriptions.interactions
    def interactions
      Action.new.interactions
    end

    desc "whatstarred @USERNAME", "Show posts starred by @username (shortcut: -was)"
    map "-was" => :whatstarred
    long_desc Descriptions.whatstarred
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def whatstarred(*username)
      Action.new.whatstarred(username, options)
    end

    desc "whoreposted POST", "List users who reposted a post (shortcut: -wor)"
    map "-wor" => :whoreposted
    long_desc Descriptions.whoreposted
    def whoreposted(post_id)
      Action.new.whoreposted(post_id)
    end

    desc "whostarred POST", "List users who starred a post (shortcut: -wos)"
    map "-wos" => :whostarred
    long_desc Descriptions.whostarred
    def whostarred(post_id)
      Action.new.whostarred(post_id)
    end

    desc "convo POST", "Show the conversation thread around a post (shortcut: -co)"
    map "-co" => :convo
    map "thread" => :convo
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    long_desc Descriptions.convo
    def convo(post_id)
      Action.new.convo(post_id, options)
    end

    desc "followings @USERNAME", "List users @username is following (shortcut: -fwg)"
    map "-fwg" => :followings
    long_desc Descriptions.followings
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def followings(*username)
      Action.new.followings(username, options)
    end

    desc "followers @USERNAME", "List users following @username (shortcut: -fwr)"
    map "-fwr" => :followers
    long_desc Descriptions.followers
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def followers(*username)
      Action.new.followers(username, options)
    end

    desc "muted", "List the users you muted (shortcut: -mtd)"
    map "-mtd" => :muted
    long_desc Descriptions.muted
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def muted
      Action.new.muted(options)
    end

    desc "blocked", "List the users you blocked (shortcut: -bkd)"
    map "-bkd" => :blocked
    long_desc Descriptions.blocked
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def blocked
      Action.new.blocked(options)
    end

    desc "hashtag HASHTAG", "Show recent posts containing #HASHTAG (shortcut: -t)"
    map "-t" => :hashtag
    long_desc Descriptions.hashtag
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def hashtag(hashtag)
      Action.new.hashtag(hashtag, options)
    end

    desc "search WORD(S)", "Show recents posts containing WORD(S) (shortcut: -s)"
    map "-s" => :search
    long_desc Descriptions.search
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def search(*words)
      Action.new.search(words.join(","), options)
    end

    desc "settings", "List current Ayadn settings (shortcut: -sg)"
    map "-sg" => :settings
    long_desc Descriptions.settings
    def settings
      Action.new.view_settings
    end

    desc "userinfo @USERNAME", "Show detailed informations about @username (shortcut: -iu)"
    map "-iu" => :userinfo
    long_desc Descriptions.userinfo
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def userinfo(*username)
      Action.new.userinfo(username, options)
    end

    desc "postinfo POST", "Show detailed informations about a post (shortcut: -ip)"
    map "-ip" => :postinfo
    long_desc Descriptions.postinfo
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def postinfo(post_id)
      Action.new.postinfo(post_id, options)
    end

    desc "files", "List your files (shortcut: -fl)"
    map "-fl" => :files
    long_desc Descriptions.files
    option :count, aliases: "-c", type: :numeric, desc: "Specify the number of files to display"
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    option :all, aliases: "-a", type: :boolean, desc: "Retrieve the list of all your files"
    def files
      Action.new.files(options)
    end

    desc "delete POST", "Delete a post (shortcut: -del)"
    map "-del" => :delete
    long_desc Descriptions.delete
    def delete(post_id)
      Action.new.delete(post_id)
    end

    desc "unfollow @USERNAME", "Unfollow @username (shortcut: -unf)"
    map "-unf" => :unfollow
    long_desc Descriptions.unfollow
    def unfollow(*username)
      Action.new.unfollow(username)
    end

    desc "unmute @USERNAME", "Unmute @username (shortcut: -unm)"
    map "-unm" => :unmute
    long_desc Descriptions.unmute
    def unmute(*username)
      Action.new.unmute(username)
    end

    desc "unblock @USERNAME", "Unblock @username (shortcut: -unb)"
    map "-unb" => :unblock
    long_desc Descriptions.unblock
    def unblock(*username)
      Action.new.unblock(username)
    end

    desc "unrepost POST", "Unrepost a post (shortcut: -unr)"
    map "-unr" => :unrepost
    long_desc Descriptions.unrepost
    def unrepost(post_id)
      Action.new.unrepost(post_id)
    end

    desc "unstar POST", "Unstar a post (shortcut: -uns)"
    map "-uns" => :unstar
    long_desc Descriptions.unstar
    def unstar(post_id)
      Action.new.unstar(post_id)
    end

    desc "star POST", "Star a post (shortcut: -st)"
    map "-st" => :star
    long_desc Descriptions.star
    def star(post_id)
      Action.new.star(post_id)
    end

    desc "repost POST", "Repost a post (shortcut: -rp)"
    map "-rp" => :repost
    long_desc Descriptions.repost
    def repost(post_id)
      Action.new.repost(post_id)
    end

    desc "follow @USERNAME", "Follow @username (shortcut: -fo)"
    map "-fo" => :follow
    long_desc Descriptions.follow
    def follow(*username)
      Action.new.follow(username)
    end

    desc "mute @USERNAME", "Mute @username (shortcut: -mu)"
    map "-mu" => :mute
    long_desc Descriptions.mute
    def mute(*username)
      Action.new.mute(username)
    end

    desc "block @USERNAME", "Block @username (shortcut: -bl)"
    map "-bl" => :block
    long_desc Descriptions.block
    def block(*username)
      Action.new.block(username)
    end

    desc "channels", "List your active channels (shortcut: -ch)"
    map "-ch" => :channels
    long_desc Descriptions.channels
    def channels
      Action.new.channels
    end

    desc "messages CHANNEL", "Show messages in a CHANNEL (shortcut: -ms)"
    map "-ms" => :messages
    long_desc Descriptions.messages
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: "Specify the number of messages to retrieve"
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def messages(channel_id)
      Action.new.messages(channel_id, options)
    end

    desc "pin POST TAG(S)", "Export a post's link and text with tags to Pinboard"
    long_desc Descriptions.pin
    def pin(post_id, *tags)
      Action.new.pin(post_id, tags)
    end

    desc "post Your text", "Simple post to App.net (shortcut: -p)"
    map "-p" => :post
    long_desc Descriptions.post
    def post(*args)
      Action.new.post(args)
    end

    desc "write", "Multi-line post to App.net (shortcut: -w)"
    map "compose" => :write
    map "-w" => :write
    long_desc Descriptions.write
    def write
      Action.new.write
    end

    desc "pm @USERNAME", "Send a private message to @username"
    map "-pm" => :pm
    long_desc Descriptions.pmess
    def pm(*username)
      Action.new.pmess(username)
    end

    desc "send CHANNEL", "Send a message to a CHANNEL (shortcut: -sc)"
    map "-sc" => :send_to_channel
    long_desc Descriptions.send_to_channel
    def send_to_channel(channel_id)
      Action.new.send_to_channel(channel_id)
    end

    desc "reply POST", "Reply to post n°POST (shortcut: -r)"
    map "-r" => :reply
    long_desc Descriptions.reply
    def reply(id)
      ayadn = Action.new
      ayadn.reply(id)
    end

    desc "set PARAM(S) VALUE", "Set/configure a parameter and save it"
    long_desc Descriptions.set
    subcommand "set", Set

    desc "alias COMMAND (PARAM)", "Create/delete/list aliases for channels"
    long_desc Descriptions.alias
    subcommand "alias", Alias

    desc "download FILE", "Download the file with id FILE (shortcut: -df)"
    map "-df" => :download
    long_desc Descriptions.download
    def download(file_id)
      ayadn = Action.new
      ayadn.download(file_id)
    end

    # desc "attach FILE", "Write a post with an attached file (shortcut: -at)"
    # map "-at" => :attach
    # long_desc "TODO" #TODO
    # def attach(file)
    #     Action.new.attach(file)
    # end


    desc "blacklist COMMAND (PARAM)", "Manage your blacklist"
    long_desc Descriptions.blacklist
    subcommand "blacklist", Blacklist

    desc "nowplaying", "Post the current iTunes track (shortcut: -np)"
    map "-np" => :nowplaying
    long_desc Descriptions.nowplaying
    def nowplaying
      Action.new.nowplaying
    end

    desc "random", "Show random posts from App.net (shortcut: -rnd)"
    map "-rnd" => :random
    option :wait, aliases: "-w", type: :numeric, desc: "In seconds, time to wait before next page"
    long_desc Descriptions.random_posts
    def random
      Action.new.random_posts(options)
    end

    desc "authorize", "Authorize Ayadn"
    map "-auth" => :authorize
    long_desc Descriptions.authorize
    def authorize
      Authorize.new.authorize
    end

    desc "switch @USERNAME", "Switch between authorized App.net accounts"
    long_desc Descriptions.switch
    def switch(*username)
      Switch.new.switch(username)
    end

  end
end
