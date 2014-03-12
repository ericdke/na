# encoding: utf-8
module Ayadn
  class Descriptions
    def self.options_new
      "Retrieve only new posts since your last visit"
    end
    def self.options_count
      "Specify the number of posts to retrieve"
    end
    def self.options_index
      "Use an ordered index instead of the posts ids"
    end
    def self.options_raw
      "Outputs the App.net raw JSON response"
    end
    def self.unified
      <<-USAGE
      Show your App.net timeline, aka the Unified Stream.

      Example: ayadn -tl
      \n\n
      USAGE
    end
    def self.checkins
      <<-USAGE
      Show the Checkins Stream.

      Example: ayadn -ck
      \n\n
      USAGE
    end
    def self.global
      <<-USAGE
      Show the Global Stream.

      Example: ayadn -gl
      \n\n
      USAGE
    end
    def self.trending
      <<-USAGE
      Show the Trending Stream.

      Example: ayadn -tr
      \n\n
      USAGE
    end
    def self.photos
      <<-USAGE
      Show the Photos Stream.

      Example: ayadn -ph
      \n\n
      USAGE
    end
    def self.conversations
      <<-USAGE
      Show the Conversations Stream.

      Example: ayadn -cq
      \n\n
      USAGE
    end
    def self.mentions
      <<-USAGE
      Show posts containing a mention of @username.

      Example: ayadn -m @ericd
      \n\n
      USAGE
    end
    def self.posts
      <<-USAGE
      Show @username's posts.

      Example: ayadn -up @ericd
      \n\n
      USAGE
    end
    def self.whatstarred
      <<-USAGE
      Show posts starred by @username.

      Example: ayadn -was @ericd
      \n\n
      USAGE
    end
    def self.interactions
      <<-USAGE
      Show your recent ADN activity.

      Example: ayadn -int
      \n\n
      USAGE
    end
    def self.whoreposted
      <<-USAGE
      List users who reposted post n°POST.

      Example: ayadn -wor 22790201
      \n\n
      USAGE
    end
    def self.whostarred
      <<-USAGE
      List users who starred post n°POST.

      Example: ayadn -wos 22790201
      \n\n
      USAGE
    end
    def self.convo
      <<-USAGE
      Show the conversation thread around post n°POST.

      Example: ayadn -co 23362788
      \n\n
      USAGE
    end
    def self.followings
      <<-USAGE
      List users @username is following.

      Example: ayadn -fg @ericd
      \n\n
      USAGE
    end
    def self.followers
      <<-USAGE
      List users following @username.

      Example: ayadn -fr @ericd
      \n\n
      USAGE
    end
    def self.muted
      <<-USAGE
      List the users you muted.

      Example: ayadn -mtd
      \n\n
      USAGE
    end
    def self.blocked
      <<-USAGE
      List the users you blocked.

      Example: ayadn -bkd
      \n\n
      USAGE
    end
    def self.hashtag
      <<-USAGE
      Show recent posts containing #HASHTAG.

      Example: ayadn -t thememonday
      \n\n
      USAGE
    end
    def self.search
      <<-USAGE
      Show recents posts containing WORD(S).

      Example: ayadn -s screenshot iterm
      \n\n
      USAGE
    end
    def self.settings
      <<-USAGE
      List current Ayadn settings.

      Example: ayadn -sg
      \n\n
      USAGE
    end
    def self.userinfo
      <<-USAGE
      Show detailed informations about @username.

      Example: ayadn -ui @ericd
      \n\n
      USAGE
    end
    def self.postinfo
      <<-USAGE
      Show detailed informations about post n°POST.

      Example: ayadn -di 23365251
      \n\n
      USAGE
    end
    def self.files
      <<-USAGE
      List the files in your ADN storage.

      Example: ayadn -fl

      You can then download a file with its id: 'ayadn -df 23344556'
      \n\n
      USAGE
    end
    def self.delete
      <<-USAGE
      Delete a post.

      Example: ayadn -del 23365251
      \n\n
      USAGE
    end
    def self.unfollow
      <<-USAGE
      Unfollow a user.

      Example: ayadn -unf @spammer
      \n\n
      USAGE
    end
    def self.unmute
      <<-USAGE
      Unmute a user.

      Example: ayadn -unm @ericd
      \n\n
      USAGE
    end
    def self.unblock
      <<-USAGE
      Unblock a user.

      Example: ayadn -unb @ericd
      \n\n
      USAGE
    end
    def self.unrepost
      <<-USAGE
      Unrepost a post.

      Example: ayadn -unr 23365251
      \n\n
      USAGE
    end
    def self.unstar
      <<-USAGE
      Unstar a post.

      Example: ayadn -uns 23365251
      \n\n
      USAGE
    end
    def self.star
      <<-USAGE
      Star a post.

      Example: ayadn -st 23365251
      \n\n
      USAGE
    end
    def self.repost
      <<-USAGE
      Repost a post.

      Example: ayadn -rp 23365251
      \n\n
      USAGE
    end
    def self.follow
      <<-USAGE
      Follow a user.

      Example: ayadn -fo @ericd
      \n\n
      USAGE
    end
    def self.mute
      <<-USAGE
      Mute a user.

      Example: ayadn -mu @spammer
      \n\n
      USAGE
    end
    def self.block
      <<-USAGE
      Block a user.

      Example: ayadn -bl @spammer
      \n\n
      USAGE
    end
    def self.channels
      <<-USAGE
      List your active channels.

      Example: ayadn -ch
      \n\n
      USAGE
    end
    def self.messages
      <<-USAGE
      Show recent messages in a channel.

      Example: ayadn -ms 46217

      If you've set an alias for the channel, you can display its messages with 'ayadn -ms my_alias'
      \n\n
      USAGE
    end
    def self.pin
      <<-USAGE
      Export a POST's link and text with tags to Pinboard.

      Example: ayadn pin 23365251 screenshot iTerm
      \n\n
      USAGE
    end
    def self.post
      <<-USAGE
      Simple post to App.net.

      Example: ayadn -p Hello from Ayadn!

      You don't have to put quotes around your text.

      Note: the 'write' method is recommended over this one (more secure and offers multi-line support).
      \n\n
      USAGE
    end
    def self.write
      <<-USAGE
      Multi-line post to App.net.

      Example: ayadn -w

      Enters the writing mode where you will type your post.
      \n\n
      USAGE
    end
    def self.pmess
      <<-USAGE
      Send a private message to @username.

      Example: ayadn -pm @ericd

      Enters the writing mode where you will type your message.
      \n\n
      USAGE
    end
    def self.send_to_channel
      <<-USAGE
      Send a message to a channel.

      Example: ayadn -se 46217

      Enters the writing mode where you will type your message.

      If you've set an alias for the channel, you can post to it with 'ayadn -se my_alias'
      \n\n
      USAGE
    end
    def self.reply
      <<-USAGE
      Reply to post n°POST.

      Example: ayadn -r 23365251

      Enters the writing mode where you will type your reply.

      Mentions and/or username will be detected and your text will be inserted appropriately.

      If you reply to a repost, Ayadn will automatically replace it by the original post.

      If you just viewed a stream with the -i (--index) option, you can also reply to a post by its index.

      Example: ayadn -r 3
      \n\n
      USAGE
    end
    def self.set
      <<-USAGE
      Set (configure) a parameter and save it.

      Example: ayadn set color mentions blue

      See the list of configurable parameters with: ayadn -sg
      \n\n
      USAGE
    end
    def self.set_color
      <<-USAGE
      Set ITEM to color COLOR.

      Example: ayadn set color mentions blue
      \n\n
      USAGE
    end
    def self.set_timeline
      <<-USAGE
      Set ITEM to true or false.

      Example: ayadn set directed true
      \n\n
      USAGE
    end
    def self.set_backup
      <<-USAGE
      Set ITEM to be activated or not.

      Example: ayadn set auto_save_lists true
      \n\n
      USAGE
    end
    def self.set_counts
      <<-USAGE
      Set ITEM to retrieve NUMBER of elements by default.

      Example: ayadn set count unified 100
      \n\n
      USAGE
    end
    def self.alias
      <<-USAGE
      Create, delete and list aliases for channels.

      Examples:

      ayadn alias list

      ayadn alias create 33666 my_alias

      ayadn alias delete my_alias

      (Once an alias is set, you can display the messages in this channel with 'ayadn -ms my_alias', post to it with 'ayadn -se my_alias', etc)
      \n\n
      USAGE
    end
    def self.alias_create
      <<-USAGE
      Creates an alias for a channel.

      Example: ayadn alias create 33666 my_alias

      (Once an alias is set, you can display the messages in this channel with 'ayadn -ms my_alias', post to it with 'ayadn -se my_alias', etc)
      \n\n
      USAGE
    end
    def self.alias_delete
      <<-USAGE
      Deletes a previously created alias.

      Example: ayadn alias delete my_alias
      \n\n
      USAGE
    end
    def self.alias_list
      <<-USAGE
      Lists previously created aliases.

      Example: ayadn alias list
      \n\n
      USAGE
    end
    def self.download
      <<-USAGE
      Download the file with id FILE.

      Example: ayadn -df 23344556

      You can list your files with 'ayadn -fl'
      \n\n
      USAGE
    end
    def self.blacklist
      <<-USAGE
      Manage your blacklist: add to, remove from, and show the list.

      Examples:

      ayadn blacklist list

      ayadn blacklist add mention @shmuck

      ayadn blacklist add hashtag sports

      ayadn blacklist add client IFTTT

      ayadn blacklist remove mention @shmuck

      ayadn blacklist remove hashtag sports

      ayadn blacklist remove client IFTTT
      \n\n
      USAGE
    end
    def self.blacklist_add
      <<-USAGE
      Adds a mention, hashtag or client to your blacklist.

      Examples:

      ayadn blacklist add mention @shmuck

      ayadn blacklist add hashtag sports

      ayadn blacklist add client IFTTT
      \n\n
      USAGE
    end
    def self.blacklist_remove
      <<-USAGE
      Removes a mention, hashtag or client from your blacklist.

      Examples:

      ayadn blacklist remove mention @shmuck

      ayadn blacklist remove hashtag sports

      ayadn blacklist remove client IFTTT
      \n\n
      USAGE
    end
    def self.blacklist_list
      <<-USAGE
      Lists the content of your blacklist.

      Example: ayadn blacklist list
      \n\n
      USAGE
    end
    def self.nowplaying
      <<-USAGE
      Post the track you're listening to.

      Example: ayadn -np

      Works only with iTunes and Mac Os X.
      \n\n
      USAGE
    end
    def self.random_posts
      <<-USAGE
      Show random posts from App.net. Just for fun ;)

      Example: ayadn -rnd
      \n\n
      USAGE
    end
    def self.authorize
      <<-USAGE
      Authorize Ayadn to access your App.net account.

      On Mac OS X, your browser will open and an App.net login page asking to authorize Ayadn will show up.

      On other systems, Ayadn will give you a link that you will open yourself.

      After a successful login, you will be redirected to the Ayadn authorization page.

      Copy the token and paste it into Ayadn.
      \n\n
      USAGE
    end



  end
end
