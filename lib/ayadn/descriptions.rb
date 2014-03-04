module Ayadn
  class Descriptions
    def self.unified
      %Q{Show your Unified Stream. Example: 'ayadn -u'}
    end
    def self.checkins
      %Q{Show the Checkins Stream. Example: 'ayadn -ck'}
    end
    def self.global
      %Q{Show the Global Stream. Example: 'ayadn -gl'}
    end
    def self.trending
      %Q{Show the Trending Stream. Example: 'ayadn -tr'}
    end
    def self.photos
      %Q{Show the Photos Stream. Example: 'ayadn -ph'}
    end
    def self.conversations
      %Q{Show the Conversations Stream. Example: 'ayadn -cq'}
    end
    def self.mentions
      %Q{Show posts containing a mention of a @username. Example: 'ayadn -m @ericd', 'ayadn -m me'}
    end
    def self.posts
      %Q{Show @username's posts. Example: 'ayadn -po @ericd', 'ayadn -po me'}
    end
    def self.whatstarred
      %Q{Show posts starred by @username. Example: 'ayadn -was @ericd'}
    end
    def self.interactions
      %Q{Show your recent ADN activity. Example: 'ayadn -int'}
    end
    def self.whoreposted
      %Q{List users who reposted post n°POST. Example: 'ayadn -wor 22790201'}
    end
    def self.whostarred
      %Q{List users who starred post n°POST. Example: 'ayadn -wos 22790201'}
    end
    def self.convo
      %Q{Show the conversation thread around post n°POST. Example: 'ayadn -co 23362788'}
    end
    def self.followings
      %Q{List users @username is following. Example: 'ayadn -fg @ericd', 'ayadn -fg me'}
    end
    def self.followers
      %Q{List users following @username. Example: 'ayadn -fr @ericd', 'ayadn -fr me'}
    end
    def self.muted
      %Q{List the users you muted. Example: 'ayadn -mtd'}
    end
    def self.blocked
      %Q{List the users you blocked. Example: 'ayadn -bkd'}
    end
    def self.hashtag
      %Q{Show recent posts containing #HASHTAG. Example: 'ayadn -t thememonday'}
    end
    def self.search
      %Q{Show recents posts containing WORD(S). Example: 'ayadn -s screenshot iTerm'}
    end
    def self.settings
      %Q{List current Ayadn settings. Example: 'ayadn -sg'}
    end
    def self.userinfo
      %Q{Show detailed informations about @username. Example: 'ayadn -ui @ericd', 'ayadn -ui me'}
    end
    def self.postinfo
      %Q{Show detailed informations about n°POST. Example: 'ayadn -pi 23365251'}
    end
    def self.files
      %Q{List the files in your ADN storage. Example: 'ayadn -fl'}
    end
    def self.delete
      %Q{Delete a post. Example: 'ayadn -del 23365251'}
    end
    def self.unfollow
      %Q{Unfollow a user. Example: 'ayadn -unf @spammer'}
    end
    def self.unmute
      %Q{Unmute a user. Example: 'ayadn -unm @ericd'}
    end
    def self.unblock
      %Q{Unblock a user. Example: 'ayadn -unb @ericd'}
    end
    def self.unrepost
      %Q{Unrepost a post. Example: 'ayadn -unr 23365251'}
    end
    def self.unstar
      %Q{Unstar a post. Example: 'ayadn -uns 23365251'}
    end
    def self.star
      %Q{Star a post. Example: 'ayadn -st 23365251'}
    end
    def self.repost
      %Q{Repost a post. Example: 'ayadn -rp 23365251'}
    end
    def self.follow
      %Q{Follow a user. Example: 'ayadn -fo @ayadn'}
    end
    def self.mute
      %Q{Mute a user. Example: 'ayadn -mu @spammer'}
    end
    def self.block
      %Q{Block a user. Example: 'ayadn -bl @spammer'}
    end
    def self.channels
      %Q{List your active channels. Example: 'ayadn -ch'}
    end
    def self.messages
      %Q{Show messages in channel CHANNEL. Example: 'ayadn -ms 46217'}
    end
    def self.pin
      %Q{Export a POST's link and text with tags to Pinboard. Example: 'ayadn pin 23365251 screenshot iTerm'}
    end
    def self.post
      %Q{Post to App.net with a one-liner. Example: 'ayadn -p Hello!'. Note that the 'write' method is recommended over this one.}
    end
    def self.write
      %Q{Post to App.net. Example: 'ayadn -w'. You will enter the compose mode where you will write your post.}
    end









  end
end
