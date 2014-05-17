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
    def self.options_extract
      "Extract links from each object"
    end
    def self.unified
      <<-USAGE
      Show your App.net timeline, aka the Unified Stream.

      Basic usage:

      ayadn timeline

      ayadn -tl

      Retrieves only 5 posts:

      ayadn -tl -c5

      Shows index instead of post numbers:

      ayadn -tl -i

      Shows index and retrieves 30 posts:

      ayadn -tl -i -c30

      Scroll the stream:

      ayadn -tl -s

      Show only new posts:

      ayadn -tl -n
      \n\n
      USAGE
    end
    def self.checkins
      <<-USAGE
      Show the Checkins Stream.

      Basic usage:

      ayadn checkins

      ayadn -ck

      Retrieves only 5 posts:

      ayadn -ck -c5

      Shows index instead of post numbers:

      ayadn -ck -i

      Shows index and retrieves 30 posts:

      ayadn -ck -i -c30

      Scroll the stream:

      ayadn -ck -s

      Show only new posts:

      ayadn -ck -n
      \n\n
      USAGE
    end
    def self.global
      <<-USAGE
      Show the Global Stream.

      Basic usage:

      ayadn global

      ayadn -gl

      Retrieves only 5 posts:

      ayadn -gl -c5

      Shows index instead of post numbers:

      ayadn -gl -i

      Shows index and retrieves 30 posts:

      ayadn -gl -i -c30

      Scroll the stream:

      ayadn -gl -s

      Show only new posts:

      ayadn -gl -n
      \n\n
      USAGE
    end
    def self.trending
      <<-USAGE
      Show the Trending Stream.

      Basic usage:

      ayadn trending

      ayadn -tr

      Retrieves only 5 posts:

      ayadn -tr -c5

      Shows index instead of post numbers:

      ayadn -tr -i

      Shows index and retrieves 30 posts:

      ayadn -tr -i -c30

      Scroll the stream:

      ayadn -tr -s

      Show only new posts:

      ayadn -tr -n
      \n\n
      USAGE
    end
    def self.photos
      <<-USAGE
      Show the Photos Stream.

      Basic usage:

      ayadn photos

      ayadn -ph

      Retrieves only 5 posts:

      ayadn -ph -c5

      Shows index instead of post numbers:

      ayadn -ph -i

      Shows index and retrieves 30 posts:

      ayadn -ph -i -c30

      Scroll the stream:

      ayadn -ph -s

      Show only new posts:

      ayadn -ph -n
      \n\n
      USAGE
    end
    def self.conversations
      <<-USAGE
      Show the Conversations Stream.

      Basic usage:

      ayadn conversations

      ayadn -cq

      Retrieves only 5 posts:

      ayadn -cq -c5

      Shows index instead of post numbers:

      ayadn -cq -i

      Shows index and retrieves 30 posts:

      ayadn -cq -i -c30

      Scroll the stream:

      ayadn -cq -s

      Show only new posts:

      ayadn -cq -n
      \n\n
      USAGE
    end
    def self.mentions
      <<-USAGE
      Show posts containing a mention of @username.

      Basic usage:

      ayadn mentions @ericd

      ayadn -m @ericd

      Retrieves only 5 posts:

      ayadn -m -c5 @ericd

      Shows index instead of post numbers:

      ayadn -m -i @ericd

      Shows index and retrieves 30 posts:

      ayadn -m -i -c30 @ericd

      Scroll mentions:

      ayadn -m -s @ericd
      \n\n
      USAGE
    end
    def self.posts
      <<-USAGE
      Show @username's posts.

      Basic usage:

      ayadn userposts @ericd

      ayadn -up @ericd

      Retrieves only 5 posts:

      ayadn -up -c5 @ericd

      Shows index instead of post numbers:

      ayadn -up -i @ericd

      Shows index and retrieves 30 posts:

      ayadn -up -i -c30 @ericd

      Scroll posts:

      ayadn -up -s @ericd
      \n\n
      USAGE
    end
    def self.whatstarred
      <<-USAGE
      Show posts starred by @username.

      Basic usage:

      ayadn whatstarred @ericd

      ayadn -was @ericd

      Retrieves only 5 posts:

      ayadn -was -c5 @ericd

      Shows index instead of post numbers:

      ayadn -was -i @ericd

      Shows index and retrieves 30 posts:

      ayadn -was -i -c30 @ericd
      \n\n
      USAGE
    end
    def self.interactions
      <<-USAGE
      Show your recent ADN interactions.

      Usage:

      ayadn interactions

      ayadn -int
      \n\n
      USAGE
    end
    def self.whoreposted
      <<-USAGE
      List users who reposted post n°POST.

      Usage:

      ayadn whoreposted 22790201

      ayadn -wor 22790201
      \n\n
      USAGE
    end
    def self.whostarred
      <<-USAGE
      List users who starred post n°POST.

      Usage:

      ayadn whostarred 22790201

      ayadn -wos 22790201
      \n\n
      USAGE
    end
    def self.convo
      <<-USAGE
      Show the conversation thread around post n°POST.

      Usage:

      ayadn convo 23362788

      ayadn -co 23362788

      Show index instead of post numbers:

      ayadn -co -i 23362788

      Scroll the conversation:

      ayadn -co -s 23362788
      \n\n
      USAGE
    end
    def self.followings
      <<-USAGE
      List users @username is following.

      Usage:

      ayadn followings @ericd

      ayadn -fwg @ericd
      \n\n
      USAGE
    end
    def self.followers
      <<-USAGE
      List users following @username.

      Usage:

      ayadn followers @ericd

      ayadn -fwr @ericd
      \n\n
      USAGE
    end
    def self.muted
      <<-USAGE
      List the users you muted.

      Usage:

      ayadn muted

      ayadn -mtd
      \n\n
      USAGE
    end
    def self.blocked
      <<-USAGE
      List the users you blocked.

      Usage:

      ayadn blocked

      ayadn -bkd
      \n\n
      USAGE
    end
    def self.hashtag
      <<-USAGE
      Show recent posts containing HASHTAG.

      Usage:

      ayadn hashtag thememonday

      ayadn -t thememonday
      \n\n
      USAGE
    end
    def self.search
      <<-USAGE
      Show recents posts containing WORD(S).

      Basic usage:

      ayadn search screenshot iterm

      ayadn -s screenshot iterm

      Retrieves only 5 posts:

      ayadn -s -c5 screenshot iterm

      Shows index instead of post numbers:

      ayadn -s -i screenshot iterm

      Shows index and retrieves 30 posts:

      ayadn -s -i -c30 screenshot iterm
      \n\n
      USAGE
    end
    def self.settings
      <<-USAGE
      List current Ayadn settings.

      Usage:

      ayadn settings

      ayadn -sg
      \n\n
      USAGE
    end
    def self.userinfo
      <<-USAGE
      Show detailed informations about @username.

      Usage:

      ayadn userinfo @ericd

      ayadn -ui @ericd
      \n\n
      USAGE
    end
    def self.postinfo
      <<-USAGE
      Show detailed informations about post n°POST.

      Usage:

      ayadn postinfo 23365251

      ayadn -pi 23365251
      \n\n
      USAGE
    end
    def self.files
      <<-USAGE
      List the files in your ADN storage.

      Basic usage:

      ayadn files

      ayadn -fl

      Retrieves only 5 files:

      ayadn -fl -c5

      Retrieves all files:

      ayadn -fl -a

      You can then download a file with its id: 'ayadn -df 23344556'
      \n\n
      USAGE
    end
    def self.delete
      <<-USAGE
      Delete a post.

      Usage:

      ayadn delete 23365251

      ayadn -D 23365251
      \n\n
      USAGE
    end
    def self.delete_m
      <<-USAGE
      Delete a message (private message or message in a channel).

      Usage:

      ayadn delete_m 42666 3365251

      ayadn -DM 42666 3365251

      ayadn -DM my_channel_alias 3365251
      \n\n
      USAGE
    end
    def self.unfollow
      <<-USAGE
      Unfollow a user.

      Usage:

      ayadn unfollow @spammer

      ayadn -UF @spammer
      \n\n
      USAGE
    end
    def self.unmute
      <<-USAGE
      Unmute a user.

      Usage:

      ayadn unmute @ericd

      ayadn -UM @ericd
      \n\n
      USAGE
    end
    def self.unblock
      <<-USAGE
      Unblock a user.

      Usage:

      ayadn unblock @notspammeractually

      ayadn -UB @notspammeractually
      \n\n
      USAGE
    end
    def self.unrepost
      <<-USAGE
      Unrepost a post.

      Usage:

      ayadn unrepost 23365251

      ayadn -UR 23365251
      \n\n
      USAGE
    end
    def self.unstar
      <<-USAGE
      Unstar a post.

      Usage:

      ayadn unstar 23365251

      ayadn -US 23365251
      \n\n
      USAGE
    end
    def self.star
      <<-USAGE
      Star a post.

      Usage:

      ayadn star 23365251

      ayadn -ST 23365251
      \n\n
      USAGE
    end
    def self.repost
      <<-USAGE
      Repost a post.

      Usage:

      ayadn repost 23365251

      ayadn -O 23365251
      \n\n
      USAGE
    end
    def self.follow
      <<-USAGE
      Follow a user.

      Usage:

      ayadn follow @ericd

      ayadn -FO @ericd
      \n\n
      USAGE
    end
    def self.mute
      <<-USAGE
      Mute a user.

      Usage:

      ayadn mute @spammer

      ayadn -MU @spammer
      \n\n
      USAGE
    end
    def self.block
      <<-USAGE
      Block a user.

      Usage:

      ayadn block @spammer

      ayadn -BL @spammer
      \n\n
      USAGE
    end
    def self.channels
      <<-USAGE
      List your active channels.

      Usage:

      ayadn channels

      ayadn -ch
      \n\n
      USAGE
    end
    def self.messages
      <<-USAGE
      Show recent messages in a channel.

      Basic usage:

      ayadn messages 46217

      ayadn -ms 46217

      Retrieves only 5 messages:

      ayadn -ms -c5 46217

      Retrieves only new messages:

      ayadn -ms -n 46217

      Scroll messages:

      ayadn -ms -s 46217

      If you've set an alias for the channel, you can display its messages with 'ayadn -ms my_alias'
      \n\n
      USAGE
    end
    def self.pin
      <<-USAGE
      Export a POST's link and text with tags to Pinboard.

      Usage:

      ayadn pin 23365251 screenshot iterm
      \n\n
      USAGE
    end
    def self.post
      <<-USAGE
      Simple post to App.net.

      Usage:

      ayadn post 'Hello from Ayadn!'

      ayadn -P 'Hello from Ayadn!'

      ayadn -P Watching a movie with friends

      You don't have to put quotes around your text, but it's better to do it.

      The 'write' method is recommended over this one: it's more secure and offers multi-line support.
      \n\n
      USAGE
    end
    def self.write
      <<-USAGE
      Multi-line post to App.net.

      Usage:

      ayadn write

      ayadn -W

      It enters the writing mode where you will type your post.
      \n\n
      USAGE
    end
    def self.pmess
      <<-USAGE
      Send a private message to @username.

      Usage:

      ayadn pm @ericd

      It enters the writing mode where you will type your message.
      \n\n
      USAGE
    end
    def self.send_to_channel
      <<-USAGE
      Send a message to a channel.

      Usage:

      ayadn send 46217

      ayadn -C 46217

      It enters the writing mode where you will type your message.

      If you've set an alias for the channel, you can post to it with 'ayadn -C my_alias'
      \n\n
      USAGE
    end
    def self.reply
      <<-USAGE
      Reply to post n°POST.

      Usage:

      ayadn reply 23365251

      ayadn -R 23365251

      It enters the writing mode where you will type your reply.

      Mentions and/or username will be detected and your text will be inserted appropriately.

      If you reply to a repost, Ayadn will automatically replace it by the original post.

      If you just viewed a stream with the -i (--index) option, you can also reply to a post by its index.

      Example: ayadn -R 3
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
    def self.set_defaults
      <<-USAGE
      Sets back the configuration to default values.

      ayadn set defaults
      \n\n
      USAGE
    end
    def self.alias
      <<-USAGE
      Manage your channel aliases. Commands: create, delete, list, import.

      Usage:

      ayadn alias list

      ayadn -A list

      ayadn -A create 33666 my_alias

      ayadn -A delete my_alias

      ayadn -A import '/Users/blah/backups/aliases.db'

      (Once an alias is set, you can display the messages in this channel with 'ayadn -ms my_alias', post to it with 'ayadn -C my_alias', etc)
      \n\n
      USAGE
    end
    def self.alias_create
      <<-USAGE
      Creates an alias for a channel.

      Usage:

      ayadn alias create 33666 my_alias

      ayadn -A create 33666 my_alias

      (Once an alias is set, you can display the messages in this channel with 'ayadn -ms my_alias', post to it with 'ayadn -C my_alias', etc)
      \n\n
      USAGE
    end
    def self.alias_delete
      <<-USAGE
      Deletes a previously created alias.

      Usage:

      ayadn alias delete my_alias

      ayadn -A delete my_alias
      \n\n
      USAGE
    end
    def self.alias_import
      <<-USAGE
      Imports an aliases database from a backed up Ayadn account.

      Usage:

      ayadn alias import '/Users/blah/ayadn/blah/db/aliases.db'

      ayadn -A import '/Users/blah/backups/aliases.db'
      \n\n
      USAGE
    end
    def self.alias_list
      <<-USAGE
      Lists previously created aliases.

      Usage:

      ayadn alias list

      ayadn -A list
      \n\n
      USAGE
    end
    def self.download
      <<-USAGE
      Download the file with id FILE.

      Usage:

      ayadn download 23344556

      ayadn -df 23344556

      (you can list your files with 'ayadn -fl')
      \n\n
      USAGE
    end
    def self.mark
      <<-USAGE
      Bookmark a conversation and manage your bookmarks.

      Usage:

      ayadn mark add 30594331

      ayadn mark add 30594331 convo_name

      ayadn mark list

      ayadn mark delete 30594331

      ayadn mark rename 'convo name' 'other name'
      \n\n
      USAGE
    end
    def self.mark_add
      <<-USAGE
      Add a conversation to your conversations bookmarks.

      Usage:

      ayadn mark add 30594331

      ayadn mark add 30594331 'title'

      You don't have to specify the root post of the conversation, any post within the thread will work.
      \n\n
      USAGE
    end
    def self.mark_list
      <<-USAGE
      List your bookmarked conversations.

      Usage:

      ayadn mark list
      \n\n
      USAGE
    end
    def self.mark_delete
      <<-USAGE
      Delete entry from your bookmarked conversations.

      Usage:

      ayadn mark delete 30594331
      \n\n
      USAGE
    end
    def self.mark_rename
      <<-USAGE
      Rename a bookmarked conversation.

      Usage:

      ayadn mark rename 30594331 'new title'
      \n\n
      USAGE
    end
    def self.blacklist
      <<-USAGE
      Manage your blacklist. Commands: add, remove, list, import.

      Usage:

      ayadn blacklist list

      ayadn -K list

      ayadn -K add mention @shmuck

      ayadn blacklist add hashtag sports

      ayadn -K add client IFTTT

      ayadn -K add client 'Spammy Unknown Client'

      ayadn blacklist remove mention @shmuck

      ayadn -K remove hashtag sports

      ayadn -K remove client IFTTT

      ayadn -K import '/Users/blah/backups/blacklist.db'
      \n\n
      USAGE
    end
    def self.blacklist_add
      <<-USAGE
      Adds a mention, hashtag or client to your blacklist.

      You don't have to respect the case as all data is recorded downcase.

      Usage:

      ayadn blacklist add mention @shmuck

      ayadn -K add mention @shmuck

      ayadn -K add hashtag sports

      ayadn -K add client IFTTT

      ayadn -K add client 'Spammy Unknown Client'
      \n\n
      USAGE
    end
    def self.blacklist_remove
      <<-USAGE
      Removes a mention, hashtag or client from your blacklist.

      You don't have to respect the case as all data is recorded downcase.

      Usage:

      ayadn blacklist remove mention @shmuck

      ayadn -K remove mention @shmuck

      ayadn -K remove hashtag sports

      ayadn -K remove client IFTTT
      \n\n
      USAGE
    end
    def self.blacklist_import
      <<-USAGE
      Imports a blacklist database from another Ayadn account.

      Usage:

      ayadn blacklist import '/Users/blah/ayadn/blah/db/blacklist.db'

      ayadn -K import '/Users/blah/backups/blacklist.db'
      \n\n
      USAGE
    end
    def self.blacklist_convert
      <<-USAGE
      Convert your current blacklist database to the new format. Useful if you used the blacklist command prior to Ayadn 10.0.13.

      Usage:

      ayadn blacklist convert

      ayadn -K convert
      \n\n
      USAGE
    end
    def self.blacklist_list
      <<-USAGE
      Lists the content of your blacklist.

      Usage:

      ayadn blacklist list

      ayadn -K list
      \n\n
      USAGE
    end
    def self.nowplaying
      <<-USAGE
      Post the track you're listening to.

      Usage:

      ayadn nowplaying

      ayadn -np

      (works only with iTunes and Mac Os X)
      \n\n
      USAGE
    end
    def self.random_posts
      <<-USAGE
      Show random posts from App.net.

      Usage:

      ayadn random

      ayadn -rnd

      With 'wait 2 seconds' option:

      ayadn -rnd -w2
      \n\n
      USAGE
    end
    def self.authorize
      <<-USAGE
      Authorize Ayadn to access your App.net account.

      Usage:

      ayadn authorize

      ayadn -auth

      Ayadn will give you a link to an App.net login page.

      After a successful login, you will be redirected to the Ayadn user token page.

      Copy this token and paste it into Ayadn.
      \n\n
      USAGE
    end
    def self.switch
      <<-USAGE
      Switch between already authorized App.net accounts.

      Usage:

      ayadn switch @myotheraccount

      ayadn -@ myotheraccount

      List your authorized accounts:

      ayadn -@ -l
      \n\n
      USAGE
    end
    def self.auto
      <<-USAGE
      Auto post every line of input.

      In this mode, each line you type (each time you hit ENTER!) is automatically posted to ADN.

      Hit CTRL+C to exit this mode at any moment.
      \n\n
      USAGE
    end
  end
end
