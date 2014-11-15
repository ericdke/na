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
    def self.options_force
      "Force retrieve posts if the user is muted/blocked and ignores posts index"
    end
    def self.unified
      <<-USAGE
      Show your App.net timeline, aka the Unified Stream.

      Basic usage:

      `ayadn timeline`

      `ayadn -tl`

      Scroll the stream:

      `ayadn -tl -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -tl -c5`

      Shows index instead of post numbers:

      `ayadn -tl -i`

      Shows index and retrieves 30 posts:

      `ayadn -tl -i -c30`

      Show only new posts:

      `ayadn -tl -n`

      Force compact view:

      `ayadn -tl -k`

      Force display blocked/muted/blacklisted:

      `ayadn -tl -f`

      Show as JSON:

      `ayadn -tl -x`
      \n\n
      USAGE
    end
    def self.checkins
      <<-USAGE
      Show the Checkins Stream.

      Basic usage:

      `ayadn checkins`

      `ayadn -ck`

      Scroll the stream:

      `ayadn -ck -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -ck -c5`

      Shows index instead of post numbers:

      `ayadn -ck -i`

      Shows index and retrieves 30 posts:

      `ayadn -ck -i -c30`

      Show only new posts:

      `ayadn -ck -n`

      Force compact view:

      `ayadn -ck -k`

      Force display blocked/muted/blacklisted:

      `ayadn -ck -f`

      Show as JSON:

      `ayadn -ck -x`
      \n\n
      USAGE
    end
    def self.global
      <<-USAGE
      Show the Global Stream.

      Basic usage:

      `ayadn global`

      `ayadn -gl`

      Scroll the stream:

      `ayadn -gl -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -gl -c5`

      Shows index instead of post numbers:

      `ayadn -gl -i`

      Shows index and retrieves 30 posts:

      `ayadn -gl -i -c30`

      Show only new posts:

      `ayadn -gl -n`

      Force compact view:

      `ayadn -gl -k`

      Force display blocked/muted/blacklisted:

      `ayadn -gl -f`

      Show as JSON:

      `ayadn -gl -x`
      \n\n
      USAGE
    end
    def self.trending
      <<-USAGE
      Show the Trending Stream.

      Basic usage:

      `ayadn trending`

      `ayadn -tr`

      Scroll the stream:

      `ayadn -tr -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -tr -c5`

      Shows index instead of post numbers:

      `ayadn -tr -i`

      Shows index and retrieves 30 posts:

      `ayadn -tr -i -c30`

      Show only new posts:

      `ayadn -tr -n`

      Force compact view:

      `ayadn -tr -k`

      Force display blocked/muted/blacklisted:

      `ayadn -tr -f`

      Show as JSON:

      `ayadn -tr -x`
      \n\n
      USAGE
    end
    def self.photos
      <<-USAGE
      Show the Photos Stream.

      Basic usage:

      `ayadn photos`

      `ayadn -ph`

      Scroll the stream:

      `ayadn -ph -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -ph -c5`

      Shows index instead of post numbers:

      `ayadn -ph -i`

      Shows index and retrieves 30 posts:

      `ayadn -ph -i -c30`

      Show only new posts:

      `ayadn -ph -n`

      Force compact view:

      `ayadn -ph -k`

      Force display blocked/muted/blacklisted:

      `ayadn -ph -f`

      Show as JSON:

      `ayadn -ph -x`
      \n\n
      USAGE
    end
    def self.conversations
      <<-USAGE
      Show the Conversations Stream.

      Basic usage:

      `ayadn conversations`

      `ayadn -cq`

      Scroll the stream:

      `ayadn -cq -s`

      # -----

      Retrieves only 5 posts:

      `ayadn -cq -c5`

      Shows index instead of post numbers:

      `ayadn -cq -i`

      Shows index and retrieves 30 posts:

      `ayadn -cq -i -c30`

      Show only new posts:

      `ayadn -cq -n`

      Force compact view:

      `ayadn -cq -k`

      Force display blocked/muted/blacklisted:

      `ayadn -cq -f`

      Show as JSON:

      `ayadn -cq -x`
      \n\n
      USAGE
    end
    def self.mentions
      <<-USAGE
      Show posts containing a mention of @username.

      Basic usage:

      `ayadn mentions @ericd`

      `ayadn -m ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own mentions.

      Scroll mentions:

      `ayadn -m -s me`

      # -----

      Retrieves only 5 posts:

      `ayadn -m -c5 me`

      Shows index instead of post numbers:

      `ayadn -m -i me`

      Shows index and retrieves 30 posts:

      `ayadn -m -i -c30 me`

      Force compact view:

      `ayadn -m -i -k me`

      Force display blocked/muted/blacklisted:

      `ayadn -m -f me`

      Show as JSON:

      `ayadn -m -x me`
      \n\n
      USAGE
    end
    def self.posts
      <<-USAGE
      Show @username's posts.

      Basic usage:

      `ayadn userposts @ericd`

      `ayadn -up @ericd`

      Scroll posts:

      `ayadn -up -s ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own posts.

      # -----

      Retrieves only 5 posts:

      `ayadn -up -c5 me`

      Shows index instead of post numbers:

      `ayadn -up -i me`

      Shows index and retrieves 30 posts:

      `ayadn -up -i -c30 me`

      Force compact view:

      `ayadn -up me -i -c30 -k`

      Force display blocked/muted/blacklisted:

      `ayadn -up -f me`

      Show as JSON:

      `ayadn -up -x me`
      \n\n
      USAGE
    end
    def self.whatstarred
      <<-USAGE
      Show posts starred by @username.

      Basic usage:

      `ayadn whatstarred @ericd`

      `ayadn -was ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own stars.

      # -----

      Retrieves only 5 posts:

      `ayadn -was -c5 @ericd`

      Shows index instead of post numbers:

      `ayadn -was -i @ericd`

      Shows index and retrieves 30 posts:

      `ayadn -was -i -c30 @ericd`

      Force compact view:

      `ayadn -was -i -c30 @ericd -k`

      Show result as JSON:

      `ayadn -was -x @ericd`

      Extracts all links contained in the starred posts:

      `ayadn -was -e @ericd`
      \n\n
      USAGE
    end
    def self.interactions
      <<-USAGE
      Show your recent ADN interactions.

      Usage:

      `ayadn interactions`

      `ayadn -int`

      # -----

      Force compact view:

      `ayadn -int -k`

      Show result as JSON:

      `ayadn -int -x`
      \n\n
      USAGE
    end
    def self.whoreposted
      <<-USAGE
      List users who reposted post n°POST.

      Usage:

      `ayadn whoreposted 22790201`

      `ayadn -wor 22790201`

      # -----

      Force compact view:

      `ayadn -wor -k 22790201`

      Show result as JSON:

      `ayadn -wor -x 22790201`
      \n\n
      USAGE
    end
    def self.whostarred
      <<-USAGE
      List users who starred post n°POST.

      Usage:

      `ayadn whostarred 22790201`

      `ayadn -wos 22790201`

      # -----

      Force compact view:

      `ayadn -was -k 22790201`

      Show result as JSON:

      `ayadn -wos -x 22790201`
      \n\n
      USAGE
    end
    def self.convo
      <<-USAGE
      Show the conversation thread around post n°POST.

      Usage:

      `ayadn convo 23362788`

      `ayadn -co 23362788`

      Scroll the conversation:

      `ayadn -co -s 23362788`

      # -----

      Show index instead of post numbers:

      `ayadn -co -i 23362788`

      Force compact view:

      `ayadn -co -i -k 23362788`

      Force display blocked/muted/blacklisted:

      `ayadn -co -f 23362788`

      Show as JSON:

      `ayadn -co -x 23362788`
      \n\n
      USAGE
    end
    def self.followings
      <<-USAGE
      List users @username is following.

      Usage:

      `ayadn followings @ericd`

      `ayadn -fwg ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own account.

      # -----

      Sort the list by username:

      `ayadn -fwg -u me`

      Sort the list by name:

      `ayadn -fwg -n me`

      Sort the list by posts/day:

      `ayadn -fwg -d me`

      Sort the list by total posts:

      `ayadn -fwg -p me`

      Reverse the list order:

      `ayadn -fwg -r me`

      `ayadn -fwg -u -r me`

      Force compact view:

      `ayadn -fwg -k me`

      Show as JSON:

      `ayadn -fwg me`
      \n\n
      USAGE
    end
    def self.followers
      <<-USAGE
      List users following @username.

      Usage:

      `ayadn followers @ericd`

      `ayadn -fwr ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own account.

      # -----

      Sort the list by username:

      `ayadn -fwr -u me`

      Sort the list by name:

      `ayadn -fwr -n me`

      Sort the list by posts/day:

      `ayadn -fwr -d me`

      Sort the list by total posts:

      `ayadn -fwr -p me`

      Reverse the list order:

      `ayadn -fwr -r me`

      `ayadn -fwr -u -r me`

      Force compact view:

      `ayadn -fwr -k me`

      Show as JSON:

      `ayadn -fwr me`
      \n\n
      USAGE
    end
    def self.muted
      <<-USAGE
      List the users you muted.

      Usage:

      `ayadn muted`

      `ayadn -mtd`

      # -----

      Sort the list by username:

      `ayadn -mtd -u`

      Sort the list by name:

      `ayadn -mtd -n`

      Sort the list by posts/day:

      `ayadn -mtd -d`

      Sort the list by total posts:

      `ayadn -mtd -p`

      Reverse the list order:

      `ayadn -mtd -r`

      `ayadn -mtd -u -r`

      Force compact view:

      `ayadn -mtd -k`

      Show as JSON:

      `ayadn -mtd`

      \n\n
      USAGE
    end
    def self.blocked
      <<-USAGE
      List the users you blocked.

      Usage:

      `ayadn blocked`

      `ayadn -bkd`

      # -----

      Sort the list by username:

      `ayadn -bkd -u`

      Sort the list by name:

      `ayadn -bkd -n`

      Sort the list by posts/day:

      `ayadn -bkd -d`

      Sort the list by total posts:

      `ayadn -bkd -p`

      Reverse the list order:

      `ayadn -bkd -r`

      `ayadn -bkd -u -r`

      Force compact view:

      `ayadn -bkd -k`

      Show as JSON:

      `ayadn -bkd`
      \n\n
      USAGE
    end
    def self.hashtag
      <<-USAGE
      Show recent posts containing HASHTAG.

      Usage:

      `ayadn hashtag thememonday`

      `ayadn -t thememonday`

      # -----

      Extracts all links contained in the posts:

      `ayadn -t -e thememonday`

      Ignore the blocked/muted/blacklisted filters:

      `ayadn -t -f thememonday`

      Force compact view:

      `ayadn -t thememonday -k`

      Show as JSON:

      `ayadn -t -x thememonday`
      \n\n
      USAGE
    end
    def self.search
      <<-USAGE
      Show recents posts containing WORD(S).

      # Basic usage

      `ayadn search oneword anotherone`

      `ayadn -s oneword anotherone`

      # -----

      Retrieves only 5 posts:

      `ayadn -s -c5 screenshot iterm`

      Shows index instead of post numbers:

      `ayadn -s -i screenshot iterm`

      Shows index and retrieves 30 posts:

      `ayadn -s -i -c30 screenshot iterm`

      Extracts all links contained in the posts:

      `ayadn -s -e screenshot iterm`

      Ignore the blocked/muted/blacklisted filters:

      `ayadn -s -f screenshot iterm`

      Force compact view:

      `ayadn -s screenshot -k`

      Show as JSON:

      `ayadn -s -x screenshot iterm`

      # -----

      # Advanced usage

      ## Messages

      Search for WORD(S) in messages, including PMs.

      You have to specify a channel id (or an alias).

      Usage:

      `ayadn -s --messages 33642 ipad movies`

      `ayadn -s --messages my_alias ipad movies`

      ## Users

      Search for App.net users by searching WORD(S) in their bio/description.

      Usage:

      `ayadn -s --users anime`

      ## Channels

      Search for App.net channels by searching WORD(S) in their description.

      Usage:

      `ayadn -s --channels movies`

      ## Annotations

      Search for posts containing a specific App.net annotation.

      Usage:

      `ayadn -s --annotations net.app.core.crosspost`
      \n\n
      USAGE
    end
    def self.settings
      <<-USAGE
      List current Ayadn settings.

      Usage:

      `ayadn settings`

      `ayadn -sg`

      # -----

      Force compact view:

      `ayadn -sg -k`

      Show as JSON:

      `ayadn -sg -x`
      \n\n
      USAGE
    end
    def self.userinfo
      <<-USAGE
      Show detailed informations about @username.

      Usage:

      `ayadn userinfo @ericd`

      `ayadn -ui @ericd`

      ("@" is optional)

      You can use "me" instead of your username for your own account.

      `ayadn -ui me`

      # -----

      Get infos about several users:

      `ayadn -ui ericd adnapi`

      Force compact view:

      `ayadn -ui ericd -k`

      Show as JSON:

      `ayadn -ui -x me`
      \n\n
      USAGE
    end
    def self.userupdate
      <<-USAGE
      Update your user profile.

      Usage:

      `ayadn userupdate --bio`

      `ayadn -U --bio`

      `ayadn -U --name`

      `ayadn -U --birthday`

      `ayadn -U --twitter`

      `ayadn -U --blog`

      `ayadn -U --avatar ~/Pics/myface.jpg`

      `ayadn -U --cover ~/Pics/mycats.jpg`
      \n\n
      USAGE
    end
    def self.postinfo
      <<-USAGE
      Show detailed informations about post n°POST.

      Usage:

      `ayadn postinfo 23365251`

      `ayadn -pi 23365251`

      # -----

      Force compact view:

      `ayadn -pi 23365251 -k`

      Show as JSON:

      `ayadn -pi -x 23365251`
      \n\n
      USAGE
    end
    def self.files
      <<-USAGE
      List the files in your ADN storage.

      Basic usage:

      `ayadn files`

      `ayadn -fl`

      # -----

      Retrieves only 5 files:

      `ayadn -fl -c5`

      Retrieves all files:

      `ayadn -fl -a`

      Show as JSON:

      `ayadn -fl -c5 -x`
      \n\n
      USAGE
    end
    def self.delete
      <<-USAGE
      Delete a post.

      Usage:

      `ayadn delete 23365251`

      `ayadn -D 23365251`

      You can delete several posts at once:

      `ayadn -D 42371250 23365251 42253824`
      \n\n
      USAGE
    end
    def self.delete_m
      <<-USAGE
      Delete a message (private message or message in a channel).

      Usage:

      `ayadn delete_m 42666 3365251`

      `ayadn -DM 42666 3365251`

      `ayadn -DM my_channel_alias 3365251`

      You can delete several messages at once:

      `ayadn -DM mychan 3365251 3365252 3365253`
      \n\n
      USAGE
    end
    def self.unfollow
      <<-USAGE
      Unfollow a user.

      Usage:

      `ayadn unfollow @spammer`

      `ayadn -UF @spammer`

      You can unfollow several users at once:

      `ayadn -UF @spammer @myex @thickhead`
      \n\n
      USAGE
    end
    def self.unmute
      <<-USAGE
      Unmute a user.

      Usage:

      `ayadn unmute @ericd`

      `ayadn -UM @ericd`

      You can unmute several users at once:

      `ayadn -UM @ericd @myex @thickhead`
      \n\n
      USAGE
    end
    def self.unblock
      <<-USAGE
      Unblock a user.

      Usage:

      `ayadn unblock @notspammeractually`

      `ayadn -UB @notspammeractually`

      You can unblock several users at once:

      `ayadn -UB @notspammeractually @myex @thickhead`
      \n\n
      USAGE
    end
    def self.unrepost
      <<-USAGE
      Unrepost a post.

      Usage:

      `ayadn unrepost 23365251`

      `ayadn -UR 23365251`

      You can unrepost several posts at once:

      `ayadn -UR 23365251 42253824`
      \n\n
      USAGE
    end
    def self.unstar
      <<-USAGE
      Unstar a post.

      Usage:

      `ayadn unstar 23365251`

      `ayadn -US 23365251`

      You can unstar several posts at once:

      `ayadn -US 23365251 42253824`
      \n\n
      USAGE
    end
    def self.star
      <<-USAGE
      Star a post.

      Usage:

      `ayadn star 23365251`

      `ayadn -ST 23365251`

      You can star several posts at once:

      `ayadn -ST 23365251 42253824`
      \n\n
      USAGE
    end
    def self.repost
      <<-USAGE
      Repost a post.

      Usage:

      `ayadn repost 23365251`

      `ayadn -O 23365251`

      You can repost several posts at once:

      `ayadn -O 23365251 42253824`
      \n\n
      USAGE
    end
    def self.follow
      <<-USAGE
      Follow a user.

      Usage:

      `ayadn follow @ericd`

      `ayadn -FO @ericd`

      You can follow several users at once:

      `ayadn -FO @ericd @ayadn @adnapi`
      \n\n
      USAGE
    end
    def self.mute
      <<-USAGE
      Mute a user.

      Usage:

      `ayadn mute @spammer`

      `ayadn -MU @spammer`

      You can mute several users at once:

      `ayadn -MU @spammer @myex @thickhead`
      \n\n
      USAGE
    end
    def self.block
      <<-USAGE
      Block a user.

      Usage:

      `ayadn block @spammer`

      `ayadn -BL @spammer`

      You can block several users at once:

      `ayadn -MU @spammer @myex @thickhead`
      \n\n
      USAGE
    end
    def self.channels
      <<-USAGE
      List your active channels.

      Usage:

      `ayadn channels`

      `ayadn -ch`

      # -----

      Retrieve only the specified channel(s):

      `ayadn -ch --id 42133 42134`

      Retrieve only your broadcast channel(s):

      `ayadn -ch --broadcasts`

      Retrieve only your private messages channel(s):

      `ayadn -ch --messages`

      Retrieve only your patter room channel(s):

      `ayadn -ch --patter`

      Retrieve all channel(s) except broadcasts, messages or patter:

      `ayadn -ch --other`

      Show as JSON:

      `ayadn -ch -x`
      \n\n
      USAGE
    end
    def self.messages
      <<-USAGE
      Show recent messages in a channel.

      Basic usage:

      `ayadn messages 46217`

      `ayadn -ms 46217`

      Scroll messages:

      `ayadn -ms -s 46217`

      # -----

      Retrieves only 5 messages:

      `ayadn -ms -c5 46217`

      Retrieves only new messages:

      `ayadn -ms -n 46217`

      Force compact view:

      `ayadn -ms -n 46217 -k`

      Ayadn will mark this PM channel as read after running this command.

      You can pass an option, `-z`, to avoid this temporarily:

      `ayadn -ms -z 46217`

      Or you can set it off permanently:

      `ayadn set marker messages false`

      If you've set an alias for the channel, you can use it instead of the channel id:

      `ayadn -ms my_alias`

      Show as JSON:

      `ayadn -ms -x 46217`
      \n\n
      USAGE
    end
    def self.messages_unread
      <<-USAGE
      Shows your unread private messages.

      Usage:

      `ayadn messages_unread`

      `ayadn -pmu`

      # -----

      Ayadn will mark all your PM channels as read after running this command.

      You can pass an option, `-z`, to avoid this for the time of the command:

      `ayadn -pmu -z`

      Or you can set it off permanently:

      `ayadn set marker messages false`

      Force compact view:

      `ayadn -pmu -k`
      \n\n
      USAGE
    end
    def self.pin
      <<-USAGE
      Export a POST's link and text with tags to Pinboard.

      Usage:

      `ayadn pin 23365251 screenshot iterm`
      \n\n
      USAGE
    end
    def self.post
      <<-USAGE
      Simple post to App.net.

      Usage:

      `ayadn post 'Hello from Ayadn!'`

      `ayadn -P 'Hello from Ayadn!'`

      `ayadn -P Watching a movie with friends`

      # -----

      Embed a picture:

      `ayadn -P "lol cat" -E ~/Pics/lolcat.jpg`

      You don't have to put quotes around your text, but it's better to do it.

      The 'write' method is recommended over this one: it's more secure and offers multi-line support.

      Embed an online video:

      `ayadn -P wave function -Y https://www.youtube.com/watch?v=Ei8CFin00PY`

      `ayadn -P wargarbl -V http://vimeo.com/123234345`

      Embed a movie poster:

      `ayadn -P "I'll be back" -M terminator`

      (This is different from the 'movie' command, check the docs.)
      \n\n
      USAGE
    end
    def self.write
      <<-USAGE
      Multi-line post to App.net.

      Usage:

      `ayadn write`

      `ayadn -W`

      # -----

      Embed a picture:

      `ayadn -W -E ~/Pics/lolcat.jpg`

      It enters the writing mode where you will type your post.

      Embed an online video:

      `ayadn -W -Y https://www.youtube.com/watch?v=Ei8CFin00PY`

      `ayadn -W -V http://vimeo.com/123234345`

      Embed a movie poster:

      `ayadn -W -M terminator`

      (This is different from the 'movie' command, check the docs.)
      \n\n
      USAGE
    end
    def self.pmess
      <<-USAGE
      Send a private message to @username.

      Usage:

      `ayadn pm @ericd`

      # -----

      Embed a picture:

      `ayadn pm @ericd -E ~/Pics/lolcat.jpg`

      Embed an online video:

      `ayadn pm @ericd -Y https://www.youtube.com/watch?v=Ei8CFin00PY`

      `ayadn pm @ericd -V http://vimeo.com/123234345`

      Embed a movie poster:

      `ayadn pm @ericd -M terminator`

      It enters the writing mode where you will type your message.

      Ayadn will mark your PM channel as read after running this command.

      You can pass an option, `-z`, to avoid this for the time of the command:

      `ayadn pm -z @ericd`

      Or you can set it off permanently:

      `ayadn set marker messages false`
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

      # -----

      If you've set an alias for the channel, you can post to it with 'ayadn -C my_alias'

      Embed a picture:

      `ayadn -C 46217 -E ~/Pics/lolcat.jpg`

      Embed an online video:

      `ayadn -C 46217 -Y https://www.youtube.com/watch?v=Ei8CFin00PY`

      `ayadn -C 46217 -V http://vimeo.com/123234345`

      Embed a movie poster:

      `ayadn -C 46217 -M terminator`

      It enters the writing mode where you will type your message.

      Ayadn will mark your PM channel as read after running this command.

      You can pass an option, `-z`, to avoid this for the time of the command:

      `ayadn -C -z 46217`

      Or you can set it off permanently:

      `ayadn set marker messages false`
      \n\n
      USAGE
    end
    def self.reply
      <<-USAGE
      Reply to post n°POST.

      Usage:

      `ayadn reply 23365251`

      `ayadn -R 23365251`

      It enters the writing mode where you will type your reply.

      Mentions and/or username will be detected and your text will be inserted appropriately.

      # -----

      If you reply to a repost, Ayadn will automatically replace it by the original post, following the App.net guidelines. But you can force respond to the reposted one by passing the 'noredirect' option:

      `ayadn -R --noredirect 23365251`

      If you just viewed a stream with the -i (--index) option, you can also reply to a post by its index:

      `ayadn -R 3`

      Embed a picture in a reply:

      `ayadn -R 23365251 -E ~/Pics/lolcat.jpg`

      Embed an online video:

      `ayadn -R23365251 -Y https://www.youtube.com/watch?v=Ei8CFin00PY`

      `ayadn -R23365251 -V http://vimeo.com/123234345`

      Embed a movie poster:

      `ayadn -R23365251 -M terminator`

      (This is different from the 'movie' command, check the docs.)
      \n\n
      USAGE
    end
    def self.set
      <<-USAGE
      Set (configure) a parameter and save it.

      Example: `ayadn set color mentions blue`

      See the list of configurable parameters with: `ayadn -sg`
      \n\n
      USAGE
    end
    def self.set_color
      <<-USAGE
      Set ITEM to color COLOR.

      Example: `ayadn set color mentions blue`
      \n\n
      USAGE
    end
    def self.set_timeline
      <<-USAGE
      Set ITEM to true or false.

      Example: `ayadn set directed true`
      \n\n
      USAGE
    end
    def self.set_backup
      <<-USAGE
      Set ITEM to be activated or not.

      Example: `ayadn set lists true`
      \n\n
      USAGE
    end
    def self.set_counts
      <<-USAGE
      Set ITEM to retrieve NUMBER of elements by default.

      Example: `ayadn set count unified 100`
      \n\n
      USAGE
    end
    def self.set_nicerank
      <<-USAGE
      Set NiceRank values.

      Examples:

      `ayadn set nicerank filter true`

      `ayadn set nicerank threshold 2.1`
      \n\n
      USAGE
    end
    def self.set_defaults
      <<-USAGE
      Sets back the configuration to default values.

      `ayadn set defaults`
      \n\n
      USAGE
    end
    def self.alias
      <<-USAGE
      Manage your channel aliases. Commands: create, delete, list, import.

      Usage:

      `ayadn alias list`

      `ayadn -A list`

      `ayadn -A create 33666 my_alias`

      `ayadn -A delete my_alias`

      (Once an alias is set, you can display the messages in this channel with `ayadn -ms my_alias`, post to it with `ayadn -C my_alias`, etc)
      \n\n
      USAGE
    end
    def self.alias_create
      <<-USAGE
      Creates an alias for a channel.

      Usage:

      `ayadn alias create 33666 my_alias`

      `ayadn -A create 33666 my_alias`

      (Once an alias is set, you can display the messages in this channel with `ayadn -ms my_alias`, post to it with `ayadn -C my_alias`, etc)
      \n\n
      USAGE
    end
    def self.alias_delete
      <<-USAGE
      Deletes a previously created alias.

      Usage:

      `ayadn alias delete my_alias`

      `ayadn -A delete my_alias`
      \n\n
      USAGE
    end
    def self.alias_list
      <<-USAGE
      Lists previously created aliases.

      Usage:

      `ayadn alias list`

      `ayadn -A list`

      Force compact view :

      `ayadn -A list -k`
      \n\n
      USAGE
    end
    def self.download
      <<-USAGE
      Download the file with id FILE.

      Usage:

      `ayadn download 23344556`

      `ayadn -df 23344556`
      \n\n
      USAGE
    end
    def self.mark
      <<-USAGE
      Bookmark a conversation and manage your bookmarks.

      Usage:

      `ayadn mark add 30594331`

      `ayadn mark add 30594331 convo_name`

      `ayadn mark list`

      `ayadn mark delete 30594331`

      `ayadn mark rename 'convo name' 'other name'`
      \n\n
      USAGE
    end
    def self.mark_add
      <<-USAGE
      Add a conversation to your conversations bookmarks.

      Usage:

      `ayadn mark add 30594331`

      `ayadn mark add 30594331 'title'`

      You don't have to specify the root post of the conversation, any post within the thread will work.
      \n\n
      USAGE
    end
    def self.mark_list
      <<-USAGE
      List your bookmarked conversations.

      Usage:

      `ayadn mark list`

      Force compact view :

      `ayadn mark list -k`
      \n\n
      USAGE
    end
    def self.mark_delete
      <<-USAGE
      Delete entry from your bookmarked conversations.

      Usage:

      `ayadn mark delete 30594331`
      \n\n
      USAGE
    end
    def self.mark_rename
      <<-USAGE
      Rename a bookmarked conversation.

      Usage:

      `ayadn mark rename 30594331 'new title'`
      \n\n
      USAGE
    end
    def self.blacklist
      <<-USAGE
      Manage your blacklist. Commands: add, remove, list, import.

      Usage:

      `ayadn blacklist list`

      `ayadn -K list`

      `ayadn -K add mention @shmuck`

      `ayadn -K add hashtag sports`

      `ayadn -K add client IFTTT`

      `ayadn -K add client 'Spammy Unknown Client'`

      `ayadn -K remove mention @shmuck`

      `ayadn -K remove hashtag sports`

      `ayadn -K remove client IFTTT`
      \n\n
      USAGE
    end
    def self.blacklist_add
      <<-USAGE
      Adds a mention, hashtag or client to your blacklist.

      You don't have to respect the case as all data is recorded downcase.

      Usage:

      `ayadn blacklist add mention @shmuck`

      `ayadn -K add mention @shmuck`

      `ayadn -K add hashtag sports`

      `ayadn -K add client IFTTT`

      `ayadn -K add client 'Spammy Unknown Client'`
      \n\n
      USAGE
    end
    def self.blacklist_remove
      <<-USAGE
      Removes a mention, hashtag or client from your blacklist.

      You don't have to respect the case as all data is recorded downcase.

      Usage:

      `ayadn blacklist remove mention @shmuck`

      `ayadn -K remove mention @shmuck`

      `ayadn -K remove hashtag sports`

      `ayadn -K remove client IFTTT`
      \n\n
      USAGE
    end
    def self.blacklist_list
      <<-USAGE
      Lists the content of your blacklist.

      Usage:

      `ayadn blacklist list`

      `ayadn -K list`

      Force compact view :

      `ayadn -K list -k`
      \n\n
      USAGE
    end
    def self.nowplaying
      <<-USAGE
      Post the track you're listening to.

      Ayadn will insert the album cover, a link and a description.

      Usage with iTunes (Mac Os X only):

      `ayadn nowplaying`

      `ayadn -NP`

      Usage with Last.fm:

      `ayadn nowplaying -l`

      `ayadn -NP -l`

      Specify a custom hashtag:

      `ayadn -NP -h listeningto`

      Specify a custom text:

      `ayadn -NP -t "I loved this song so much when I was young."`

      Don't resolve the names (ignores iTunes Store):

      `ayadn -NP -n`
      \n\n
      USAGE
    end
    def self.nowwatching
      <<-USAGE
      Create a post from (part of) a movie title. Includes movie poster and IMDb url.

      Usage:

      `ayadn movie ghost in the shell`

      `ayadn -NW beetlejuice`

      If the movie is not the one you're looking for, you can specify the 'alt' option to force find an alternative.

      This is useful for remakes:

      `ayadn -NW solaris`

      (gives the 2002 version)

      `ayadn -NW solaris --alt`

      (gives the 1972 version)

      Hashtag:

      You can modify the default hashtag with 'set':

      `ayadn set movie hashtag movietime`

      `ayadn set movie hashtag adnmovieclub`

      (default is 'nowwatching')
      \n\n
      USAGE
    end
    def self.tvshow
      <<-USAGE
      Create a post from (part of) a TV show title. Includes show poster and IMDb url.

      Usage:

      `ayadn tvshow magnum`

      `ayadn -TV game of thrones`

      If the show is not the one you're looking for, you can specify the 'alt' option to force find an alternative.

      `ayadn -TV whose line`

      (gives the US version)

      `ayadn -TV whose line --alt`

      (gives the UK version)

      Hashtag:

      You can modify the default hashtag with 'set':

      `ayadn set tvshow hashtag showtime`

      `ayadn set tvshow hashtag tvshow`

      (default is 'nowwatching')

      Banner:

      Use the `--banner` (-b) options to insert a banner instead of a poster:

      `ayadn -TV magnum --banner`
      \n\n
      USAGE
    end
    def self.random_posts
      <<-USAGE
      Show random posts from App.net.

      Usage:

      `ayadn random`

      `ayadn -rnd`

      With 'wait 30 seconds' option:

      `ayadn -rnd -w30`
      \n\n
      USAGE
    end
    def self.authorize
      <<-USAGE
      Authorize Ayadn to access your App.net account.

      Usage:

      `ayadn authorize`

      `ayadn -auth`

      `ayadn -AU`

      Ayadn will give you a link to an App.net login page.

      After a successful login, you will be redirected to the Ayadn user token page.

      Copy this token and paste it into Ayadn.
      \n\n
      USAGE
    end
    def self.unauthorize
      <<-USAGE
      Unauthorize an Ayadn account.

      Usage:

      `ayadn unauthorize @ericd`

      `ayadn -UA @ericd`

      You can specify the `--delete` (`-D`) option to force delete the account folders:

      `ayadn -UA -D @ericd`
      \n\n
      USAGE
    end
    def self.switch
      <<-USAGE
      Switch between already authorized App.net accounts.

      Usage:

      `ayadn switch @myotheraccount`

      `ayadn -@ myotheraccount`

      List your authorized accounts:

      `ayadn -@ -l`
      \n\n
      USAGE
    end
    def self.auto
      <<-USAGE
      Auto post every line of input.

      `ayadn auto`

      In this mode, each line you type (each time you hit ENTER!) is automatically posted to ADN.

      Hit CTRL+C to exit this mode at any moment.
      \n\n
      USAGE
    end
    def self.migrate
      <<-USAGE
      This command migrates an Ayadn 1.x account to the new 2.x format.

      This is an hidden command (doesn't show in the commands menu).

      You should only use this command once, when asked by Ayadn.

      `ayadn migrate`
      \n\n
      USAGE
    end
  end
end
