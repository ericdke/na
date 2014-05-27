# encoding: utf-8
module Ayadn
  class App < Thor
    package_name "Ayadn"

    %w{action api descriptions endpoints cnx view workers settings post status extend databases fileops logs pinboard set alias errors blacklist scroll authorize switch mark nicerank}.each { |r| require_relative "#{r}" }

    desc "timeline", "Show your App.net timeline, aka the Unified Stream (-tl)"
    map "unified" => :timeline
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

    desc "checkins", "Show the Checkins Stream (-ck)"
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

    desc "global", "Show the Global Stream (-gl)"
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

    desc "trending", "Show the Trending Stream (-tr)"
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

    desc "photos", "Show the Photos Stream (-ph)"
    map "-ph" => :photos
    long_desc Descriptions.photos
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :new, aliases: "-n", type: :boolean, desc: Descriptions.options_new
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def photos
      Action.new.photos(options)
    end

    desc "conversations", "Show the Conversations Stream (-cq)"
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

    desc "mentions @USERNAME", "Show posts containing a mention of @username (-m)"
    map "-m" => :mentions
    long_desc Descriptions.mentions
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def mentions(*username)
      Action.new.mentions(username, options)
    end

    desc "userposts @USERNAME", "Show posts by @username (-up)"
    map "-up" => :userposts
    long_desc Descriptions.posts
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def userposts(*username)
      Action.new.posts(username, options)
    end

    desc "interactions", "Show your recent ADN activity (-int)"
    map "-int" => :interactions
    long_desc Descriptions.interactions
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def interactions
      Action.new.interactions(options)
    end

    desc "whatstarred @USERNAME", "Show posts starred by @username (-was)"
    map "-was" => :whatstarred
    long_desc Descriptions.whatstarred
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    option :extract, aliases: "-e", type: :boolean, desc: Descriptions.options_extract
    def whatstarred(*username)
      Action.new.whatstarred(username, options)
    end

    desc "whoreposted POST", "List users who reposted a post (-wor)"
    map "-wor" => :whoreposted
    long_desc Descriptions.whoreposted
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def whoreposted(post_id)
      Action.new.whoreposted(post_id, options)
    end

    desc "whostarred POST", "List users who starred a post (-wos)"
    map "-wos" => :whostarred
    long_desc Descriptions.whostarred
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def whostarred(post_id)
      Action.new.whostarred(post_id, options)
    end

    desc "convo POST", "Show the conversation thread around a post (-co)"
    map "-co" => :convo
    map "thread" => :convo
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    long_desc Descriptions.convo
    def convo(post_id)
      Action.new.convo(post_id, options)
    end

    desc "followings @USERNAME", "List users @username is following (-fwg)"
    map "-fwg" => :followings
    long_desc Descriptions.followings
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def followings(*username)
      Action.new.followings(username, options)
    end

    desc "followers @USERNAME", "List users following @username (-fwr)"
    map "-fwr" => :followers
    long_desc Descriptions.followers
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def followers(*username)
      Action.new.followers(username, options)
    end

    desc "muted", "List the users you muted (-mtd)"
    map "-mtd" => :muted
    long_desc Descriptions.muted
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def muted
      Action.new.muted(options)
    end

    desc "blocked", "List the users you blocked (-bkd)"
    map "-bkd" => :blocked
    long_desc Descriptions.blocked
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def blocked
      Action.new.blocked(options)
    end

    desc "hashtag HASHTAG", "Show recent posts containing #HASHTAG (-t)"
    map "-t" => :hashtag
    long_desc Descriptions.hashtag
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    option :extract, aliases: "-e", type: :boolean, desc: Descriptions.options_extract
    def hashtag(hashtag)
      Action.new.hashtag(hashtag, options)
    end

    desc "search WORD(S)", "Show recents posts containing WORD(S) (-s)"
    map "-s" => :search
    long_desc Descriptions.search
    option :count, aliases: "-c", type: :numeric, desc: Descriptions.options_count
    option :index, aliases: "-i", type: :boolean, desc: Descriptions.options_index
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    option :extract, aliases: "-e", type: :boolean, desc: Descriptions.options_extract
    option :messages, type: :boolean, desc: Descriptions.search_messages
    option :users, type: :boolean, desc: Descriptions.search_users
    option :channels, type: :boolean, desc: Descriptions.search_channels
    option :annotations, type: :boolean, desc: Descriptions.search_annotations
    def search(*words)
      if options[:messages]
        Action.new.search(words, options)
      else
        Action.new.search(words.join(","), options)
      end
    end

    desc "settings", "List current Ayadn settings (-sg)"
    map "-sg" => :settings
    long_desc Descriptions.settings
    option :raw, aliases: "-x", type: :boolean, desc: "Outputs the raw list in JSON"
    def settings
      Action.new.view_settings(options)
    end

    desc "userinfo @USERNAME", "Show detailed informations about @username (-ui)"
    map "-ui" => :userinfo
    long_desc Descriptions.userinfo
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def userinfo(*username)
      Action.new.userinfo(username, options)
    end

    desc "postinfo POST", "Show detailed informations about a post (-pi)"
    map "-pi" => :postinfo
    long_desc Descriptions.postinfo
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    def postinfo(post_id)
      Action.new.postinfo(post_id, options)
    end

    desc "files", "List your files (-fl)"
    map "-fl" => :files
    long_desc Descriptions.files
    option :count, aliases: "-c", type: :numeric, desc: "Specify the number of files to display"
    option :raw, aliases: "-x", type: :boolean, desc: Descriptions.options_raw
    option :all, aliases: "-a", type: :boolean, desc: "Retrieve the list of all your files"
    def files
      Action.new.files(options)
    end

    desc "delete POST", "Delete a post (-D)"
    map "-D" => :delete
    long_desc Descriptions.delete
    def delete(post_id)
      Action.new.delete(post_id)
    end

    desc "delete_m CHANNEL MESSAGE", "Delete a message (-DM)"
    map "-DM" => :delete_m
    long_desc Descriptions.delete_m
    def delete_m(*args)
      Action.new.delete_m(args)
    end

    desc "unfollow @USERNAME", "Unfollow @username (-UF)"
    map "-UF" => :unfollow
    long_desc Descriptions.unfollow
    def unfollow(*username)
      Action.new.unfollow(username)
    end

    desc "unmute @USERNAME", "Unmute @username (-UM)"
    map "-UM" => :unmute
    long_desc Descriptions.unmute
    def unmute(*username)
      Action.new.unmute(username)
    end

    desc "unblock @USERNAME", "Unblock @username (-UB)"
    map "-UB" => :unblock
    long_desc Descriptions.unblock
    def unblock(*username)
      Action.new.unblock(username)
    end

    desc "unrepost POST", "Unrepost a post (-UR)"
    map "-UR" => :unrepost
    long_desc Descriptions.unrepost
    def unrepost(post_id)
      Action.new.unrepost(post_id)
    end

    desc "unstar POST", "Unstar a post (-US)"
    map "-US" => :unstar
    long_desc Descriptions.unstar
    def unstar(post_id)
      Action.new.unstar(post_id)
    end

    desc "star POST", "Star a post (-ST)"
    map "-ST" => :star
    long_desc Descriptions.star
    def star(post_id)
      Action.new.star(post_id)
    end

    desc "repost POST", "Repost a post (-O)"
    map "-O" => :repost
    long_desc Descriptions.repost
    def repost(post_id)
      Action.new.repost(post_id)
    end

    desc "follow @USERNAME", "Follow @username (-FO)"
    map "-FO" => :follow
    long_desc Descriptions.follow
    def follow(*username)
      Action.new.follow(username)
    end

    desc "mute @USERNAME", "Mute @username (-MU)"
    map "-MU" => :mute
    long_desc Descriptions.mute
    def mute(*username)
      Action.new.mute(username)
    end

    desc "block @USERNAME", "Block @username (-BL)"
    map "-BL" => :block
    long_desc Descriptions.block
    def block(*username)
      Action.new.block(username)
    end

    desc "channels", "List your active channels (-ch)"
    map "-ch" => :channels
    long_desc Descriptions.channels
    def channels
      Action.new.channels
    end

    desc "messages CHANNEL", "Show messages in a CHANNEL (-ms)"
    map "-ms" => :messages
    long_desc Descriptions.messages
    option :scroll, aliases: "-s", type: :boolean, desc: "Scroll the stream"
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

    desc "post Your text", "Simple post to App.net (-P)"
    map "-P" => :post
    long_desc Descriptions.post
    def post(*args)
      Action.new.post(args)
    end

    desc "write", "Multi-line post to App.net (-W)"
    map "compose" => :write
    map "-W" => :write
    long_desc Descriptions.write
    def write
      Action.new.write
    end

    desc "pm @USERNAME", "Send a private message to @username"
    long_desc Descriptions.pmess
    def pm(*username)
      Action.new.pmess(username)
    end

    desc "send CHANNEL", "Send a message to a CHANNEL (-C)"
    map "-C" => :send_to_channel
    long_desc Descriptions.send_to_channel
    def send_to_channel(channel_id)
      Action.new.send_to_channel(channel_id)
    end

    desc "reply POST", "Reply to post n°POST (-R)"
    map "-R" => :reply
    long_desc Descriptions.reply
    def reply(id)
      ayadn = Action.new
      ayadn.reply(id)
    end

    desc "auto", "Auto post every line of input to App.net"
    long_desc Descriptions.auto
    def auto
      Action.new.auto(options)
    end

    desc "set TYPE PARAM VALUE", "Set/configure a parameter and save it"
    long_desc Descriptions.set
    subcommand "set", Set

    desc "alias COMMAND (PARAM)", "Create/delete/list aliases for channels (-A)"
    map "-A" => :alias
    long_desc Descriptions.alias
    subcommand "alias", Alias

    desc "mark POST (TITLE)", "Bookmark a conversation / manage bookmarks"
    long_desc Descriptions.mark
    subcommand "mark", Mark

    desc "download FILE", "Download the file with id FILE (-df)"
    map "-df" => :download
    long_desc Descriptions.download
    def download(file_id)
      ayadn = Action.new
      ayadn.download(file_id)
    end

    desc "blacklist COMMAND (PARAM)", "Manage your blacklist (-K)"
    map "-K" => :blacklist
    long_desc Descriptions.blacklist
    subcommand "blacklist", Blacklist

    desc "nowplaying", "Post the current iTunes track (-np)"
    map "-np" => :nowplaying
    long_desc Descriptions.nowplaying
    def nowplaying
      Action.new.nowplaying
    end

    desc "random", "Show random posts from App.net (-rnd)"
    map "-rnd" => :random
    option :wait, aliases: "-w", type: :numeric, desc: "In seconds, time to wait before next page"
    long_desc Descriptions.random_posts
    def random
      Action.new.random_posts(options)
    end

    desc "authorize", "Authorize Ayadn (-auth)"
    map "-auth" => :authorize
    long_desc Descriptions.authorize
    def authorize
      Authorize.new.authorize
    end

    desc "switch @USERNAME", "Switch between authorized App.net accounts (-@)"
    map "-@" => :switch
    option :list, aliases: "-l", type: :boolean, desc: "List authorized accounts"
    long_desc Descriptions.switch
    def switch(*username)
      unless options[:list]
        Switch.new.switch(username)
      else
        Switch.new.list
      end
    end

    desc "version", "Show the current Ayadn version (-v)"
    map "-v" => :version
    def version
      puts "\nAYADN\n".color(:red)
      puts "Version:\t".color(:cyan) + "#{VERSION}\n".color(:green)
      puts "Changelog:\t".color(:cyan) + "https://github.com/ericdke/na/blob/master/CHANGELOG.md\n".color(:yellow)
      puts "Docs:\t\t".color(:cyan) + "http://ayadn-app.net/doc/".color(:yellow)
      puts "\n"
    end

  end
end
