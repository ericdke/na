module Ayadn
  class Descriptions
    def self.unified
      <<-USAGE
      Show your Unified Stream, aka your App.net timeline.

      Example: ayadn -u
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

      Example: ayadn -po @ericd
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

      Example: ayadn -pi 23365251
      \n\n
      USAGE
    end
    def self.files
      <<-USAGE
      List the files in your ADN storage.

      Example: ayadn -fl
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
      \n\n
      USAGE
    end
    def self.reply
      <<-USAGE
      Reply to post n°POST.

      Example: ayadn -r 23365251

      Enters the writing mode where you will type your reply.

      Mentions will be detected and your text will be inserted appropriately.

      If you reply to a repost, Ayadn will automatically replace it by the original post.
      \n\n
      USAGE
    end
    def self.config
      <<-USAGE
      Configure a parameter and save it.

      Example: ayadn -cf colors mentions blue

      See the list of configurable parameters with: ayadn -sg
      \n\n
      USAGE
    end








  end
end
