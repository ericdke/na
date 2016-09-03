## 4.0.3 - 2016-09-03 - 'S U R V I V E'

- Fixed: bug introduced by the last fix (yay for incomplete tests...)

## 4.0.2 - 2016-09-03 - 'Defeated Sanity'

- Fixed: crash in configuration diagnostics when checking settings
- Fixed: crash when attempting to access a deleted channel message

## 4.0.1 - 2016-09-03 - 'Halt And Catch Fire'

- Fixed: crash when attempting to access a deleted channel

## 4.0 - 2016-05-01 - 'Mr. Robot'

- Fixed: when possible, unauthorizing a user keeps the current user logged
- Fixed: inconsistencies in the 'set' command
- Fixed: malformed address for checkins in some cases
- Fixed: a case where changing the root URL was ignored
- Fixed: typos in descriptions
- Fixed: occasional crash in the 'random' stream
- New: documentation for developing with the Ayadn codebase
- Deprecated: 'movie' and 'tvshow' commands (we don't have access to imdb anymore)
- Code cleanup

## 3.0 - 2015-11-07 - 'Edge Of Tomorrow'

- New: option to set an alternative base URL for the API calls
- New: run diagnostics (network, accounts, settings, gem)
- New: --auth bypass authorization webpage by providing the token inline
- New: edit settings with your $EDITOR
- Fixed: commands when no user authorized
- Fixed: --unauthorize if no valid username
- Deprecated: Ayadn 1.x migration tools
- Deprecated: "ayadn-app.net" domain name (use GitHub repository)

## 2.1 - 2015-08-29 - 'Electric Boogaloo'

- Fix: crash when scrolling Global with NiceRank
- Fix: crash when using list sort option posts/day
- Fix: rare crash if user has no name
- Deprecated: sort lists using posts/day

## 2.0.12 - 2015-05-10 - 'Agent Carter'

- Fix: Youtube/Vimeo integration if video not found or unauthorized
- Fix: failsafe for NR API failures
- Fix: connexion timeout before retry
- Fix: list command description

## 2.0.11 - 2015-04-12 - 'Pink'

- New: add single words to the blacklist
- Fix: ignore unknown emoji modifiers (temporary)

## 2.0.10 - 2015-02-21 - 'Haneke'

- New: cache results in Lists (and replay requests instantly)

## 2.0.9 - 2015-02-11 - 'Russel'

- Fix: bug in add/remove user/mention to the blacklist

## 2.0.7 - 2015-02-04 - 'Diacritics'

- Fix: users list if an element isn't in UTF8

## 2.0.6 - 2015-01-25 - 'Gibson'

- Fix: nowplaying post annotation
- Fix: bug in display settings

## 2.0.5 - 2015-01-24 - 'Charlie'

- New: NowPlaying with Deezer
- New: 'lastposts' in Followings (show every user last post)
- New: in Followings, sort by last post date (only with 'lastposts')
- Fix: do not crash if interrupted by user while loading Gems

## 2.0.4 - 2014-11-30 - 'The Penguin'

- Fix: nowplaying iTunes Store requests
- Fix: unread messages displayed from oldest to newest

## 2.0.3 - 2014-11-18 - 'Dexter'

- Fix: title of a pinned post
- Fix: unauthorize sets another user active if possible

## 2.0.2 - 2014-11-18 - 'To beat the devil'

- Fix: config import in 'migrate'

## 2.0.1 - 2014-11-17 - 'Nessie'

- Windows compatible (under conditions)
- NowPlaying posts affiliate links

## 2.0.0 - 2014-11-15 - 'The Piper At The Gates Of Dawn'

- SQLite database. Means FAST!
- Unified style for statuses, questions and alerts
- NowPlaying: better results, custom hashtag, custom text
- Channels: option to show only broadcasts/PMs/patter/other
- Users lists: sort by username, name, total posts or posting frequency
- Star/unstar/repost/unrepost/userinfos accept several targets
- Ayadn instances share access to the blacklist
- Unauthorize an Ayadn user account
- Posts index resolution is active by default
- Option: force view to be temporarily "compact"
- Setting: show tables borders (default: true)
- Setting: short date in timeline when scrolling (default: true)
- Setting: blacklist active (default: true)
- Spinner: better display when scrolling
- Simplified, shorter settings names
- NiceRank filter for Global is cached in-memory
- Inline help and online docs have been updated
- Code has been optimized. Bugs have been squashed.

## 1.8.2 - 2014-10-31 - 'Asylum'

- Fix: directed posts in timeline, bis

## 1.8.1 - 2014-10-31 - 'Stockholm'

- Fix: directed posts in timeline

## 1.8.0 - 2014-10-29 - 'Cascadeur'

- New: command to view all unread PMs
- New: channel commands can update unread status (default: true)
- Fix: nowplaying iTunes Store results are much more accurate
- Fix: faster follow/mute/block/delete actions
- Fix: root post of conversation shows "has replies" symbol
- Fix: clear screen before showing spinner in scroll
- Fix: save lists if backup enabled
- Update: debug info included in posts annotations
- Update: gem dependencies

## 1.7.7 - 2014-10-26 - 'The Twins'

- Fix: max characters information when sending to a channel
- Fix: line break at the end of stream if compact view
- Fix: save posts/messages if backup enabled
- New: embed an image in a message to a channel
- New: embed a Youtube video in a message
- New: embed a Vimeo video in a message
- New: embed a movie poster in a message
- New: option to show OEmbed links from channels/messages
- New: extracted links are exported to a json file

## 1.7.6 - 2014-10-25 - 'Barrie'

- Fix: channels parser (response != 200, working status)
- Fix: settings list with compact view

## 1.7.5 - 2014-10-20 - 'Cirrus'

- New: option to display a compact view for the timeline
- Fix: character count in reply with Markdown links

## 1.7.4 - 2014-09-21 - 'Elton'

- Fix: nowplaying (show artwork)
- Fix: nowwatching (show posting account)
- Fix: tvshow (show posting account)

## 1.7.3 - 2014-09-08 - 'Scanners'

- New: option to reply to a reposted post
- New: you can change the users lists order with `set`
- New: you can change the table width with `set`
- Docs: the documentation has been fixed and updated

## 1.7.2 - 2014-09-04 - 'Fortress'

- Fixed: option to retrieve only specified channels in Channels
- Fixed: validators for Set
- New: better tests suite

## 1.7.1 - 2014-09-02 - 'Poltergeist'

- New: update your user profile (full name, bio (user description), avatar, cover, Twitter username, blog url, web url)
- Update profile: option to delete the field instead of updating
- New: option to retrieve only specified channels in Channels
- New: option to display raw response in Channels

## 1.7.0 - 2014-08-21 - 'Private Investigations'

- New: embed a Youtube video in a normal post with option `-Y`
- New: embed a Vimeo video in a normal post with option `-V`
- New: embed a movie poster in a normal post with option `-M`
- New: force view blacklisted/muted/blocked user's posts with option `-f`
- New: the cursor is hidden when the scroll spinning wheel is displayed
- Change: option to embed an image in a post is now `-E` (previously -e)
- Fixed: bookmark title; also fixed the previous fix...
- Fixed: value displayed when setting NiceRank
- Refactored a few classes and methods

## 1.6.0 - 2014-08-04 - 'Beetlejuice'

- New command: 'movie'. Create a post from a movie title (with link + movie poster). Customisable hashtag (default: '#nowwatching').
- New command: 'tvshow'. Create a post from a TV show title (with link + show poster). Customisable hashtag (default: '#nowwatching'). Option to display a banner instead of a poster.
- New: see the target of your PM when writing a message.
- New: delete several posts at once.
- New: delete several PMs at once.
- Fixed: uploading jpg if there were spaces in the filename.
- Fixed: bookmark convos.
- General code cleaning and refactoring.

## 1.5.1 - 2014-07-27 - 'Holograms'

- Improved accuracy of iTunes Store requests for NowPlaying

## 1.5.0 - 2014-07-25 - 'Nozomi'

- In 'convo', both the post id you've requested and the post it replies to are marked with arrows
- Same feature in the view after a reply
- Follow/unfollow/etc several users at a time
- Much faster users lists generation (followers, muted, etc)
- Users lists include number of posts/day
- User info (-ui) includes number of posts/day
- Added NowPlaying annotations
- Documentation is included in the repo
- Skipped objects are logged if debug is enabled
- Force delete obsolete config keys / force create mandatory ones (less checks in the code, more stability)

## 1.4.6 - 'Roman'

- Temporary fix for filepaths instability when uploading pictures

## 1.4.5 - 2014-07-19 - 'Sébastien'

- Fixed a crash when iTunes Store URL contained exotic characters

## 1.4.4 - 'Randolph'

- Fixed a database problem in PM and SEND

## 1.4.3 - 2014-07-17 - 'Sergent Stretch'

- NowPlaying is compatible with iTunes and Last.fm. Default: iTunes. Add `--last-fm` or `-l` to get Last.fm last played track instead
- NowPlaying audio link has been replaced with an iTunes Store link
- NowPlaying album art now has thumbnails (compatible with Chimp, etc)
- NowPlaying doesn't crash if the iTunes Store doesn't respond
- Better global error and events logging
- Automatically fixes the arguments order for 'post' if needed when uploading a picture
- General code cleaning

## 1.4.2 - 2014-07-15 - 'Caligula'

- Ayadn is more resilient to connectivity errors
- Better handling of filenames when uploading

## 1.4.1 - 'Oh boy'

- A few fixes in the NowPlaying section

## 1.4.0 - 2014-07-14 - 'Florian'

- New feature: embed one or several pictures within a post (in write, post, reply, and pm)
- Nowplaying inserts preview URL and album art from iTunes Store (you can prevent this with: `--no-url`)

## 1.3.2 - 'Max'

- Fixed: Global stream crashed if NiceRank was enabled but unreachable

## 1.3.1 - 2014-06-16 - 'Nico'

- NiceRank threshold is a float again. Default value is 2.1

## 1.3.0 - 2014-06-09 - 'K'

- Updated the NiceRank API url
- NiceRank filter is more efficient (checks is_human + real_person)
- A few gridless grids for readability
- Added several command synonyms     
Features:
- New color: black. Depends on your terminal. (ex: ayadn set color date black)
- Silence a user (ayadn -K add user @username)
- Clear the contents of the aliases database (ayadn -A clear)
- Clear the contents of the blacklist database (ayadn -K clear)
- Clear the contents of the bookmarks database (ayadn mark clear)

## 1.2.10 - 'Anders'

- Fixed the non-installing unicode_utils Gem

## 1.2.9 - 2014-05-29 - 'Kirschen'

- NiceRank database auto-limits to 10000 users
- Better handling of connection errors
- Better display of emojis
- General code cleaning

## 1.2.8 - 2014-05-27 - 'Hans'

- No more Ruby 1.9.3
- Search for users: returns a detailed view of users containing word(s) in their bio/description
- Search for annotations: returns posts containing a specific annotation
- Search for channels containing word(s) in their description
- Search for words in messages (PMs)
- Better display of the starred and replied_to symbols

## 1.2.7 - 'Roman'

- Conform remove_arobase in Switch

## 1.2.6 - 'Saket'

- NiceRank enabled by default on new installs
- NiceRank cache expires after 48h by default
- NiceRank cache auto-limits to 5000 users
- Set the NiceRank cache value (in hours)
- More debug info
- Misc fixes related to recent features

## 1.2.5 - 'Bis repetita'

- Fix the NiceRank filter staying on true

## 1.2.4 - 2014-05-25 - 'Stoopid me'

- Fix the copy/paste error in Settings

## 1.2.3 - 'Taylor'

- Text containing '#' but not an hashtag: not colorized
- Add/remove several elements to/from blacklist at once
- Cached results for NiceRank (expire = 24h)
- NiceRank filter works better
- NiceRank logs missed users ids in a separate file
- Option for showing debug messages
- Show spinner = true

## 1.2.2 - 2014-05-21 - 'Chris'

- No more empty lines in the scroll
- Spinner while waiting for posts (false by default)
- Hashtags support accented characters

## 1.2.1 - 2014-05-20 - 'Vinz'

- Fixed the exclusion bug in NiceRank filters
- Improved the truncation in Mark list
- Changes to match changes in NiceRank API

## 1.2.0 - 2014-05-19 - 'Jason'

- @matigo's NiceRank filter for the Global stream

## 1.1.3 - 2014-05-17 - 'Kevin'

- Bookmark a conversation
- List, delete, rename bookmarks

## 1.1.2 - 'Craig'

- URL for the docs

## 1.1.1 - 2014-05-07 - 'State Of The Onion'

- Star and unstar a reposted post
- Nowplaying shows an error message if iTunes is closed or not currently playing any track

## 1.1.0 - 2014-04-28 - 'Leviathan'

- Show who's writing, and who's the recipient
- Less help text when writing, more concise
- The blacklist works better (recorded and compared downcased)
- New command: convert blacklist
- Export blacklist as CSV, aliases and settings as JSON
- New option: 'extract'. Extracts all links from results of a search by word or by hashtag, or from the 'what starred' command
- New command: show current version
- New command: photos stream
- New command: delete message (private or in a channel)

## 1.0.13 - 2014-04-25 - 'Charlotte'

- New layout for '#nowplaying'
- Compact index.db and pagination.db if necessary
- New api urls
- Fix 'download file'

## 1.0.12 - 'Rolando'

- Fixed an error in: authorizing an account if its folders already exists

## 1.0.11 - 'Chris'

- There was a typo in the last version that caused a bug in the PM command

## 1.0.10 - 'Johannes'

- Fixes the help bug (doubled commands)
- Auto adds the @ if missing in pm

## 1.0.9 - 'Brian'

- Fixes the stubborn 'nowplaying' database bug

## 1.0.8 - 2014-04-16 - 'Laurent'

- Better error messages/logs (specifically when HTTP errors)
- Token is anonymized if in error logs
- No more database error when canceling a 'nowplaying' post
- Better mentions colorization

## 1.0.7 - 2014-04-13 - 'Hugo'

- Machine-only messages in channels are now viewable
- Don't output "Downloading" if options = raw in messages view
- Alert message instead of crash when an alias is undefined
- Removed username in front of ">>" in Auto (in case the authd user changed)
- Compatibility with Windows is broken

## 1.0.6 - 2014-04-12 - 'Matthew'

- Fixed a bug where post_max_chars was displayed instead of message_max_chars
- Show raw JSON in messages even if no data

## 1.0.5 - 'Joel'

- Fixed the colorization for mentions
- Added tests for colorization

## 1.0.4 - 2014-04-06 - 'Jeremy'

- Fixed 'reply to an indexed stream' for Ruby < 2.1
- More tests for Databases
- Tests for Blacklist
- Tests for Set

## 1.0.3 - 'Donny'

- Fixed the bug introduced by the last bugfix (yes, I know... sigh...)

## 1.0.2 - 'Mark'

- Fixed a critical bug in Reply (when the original post was a repost)
- Tests for Databases
- Tests for Posts & Messages
- Better layout for checkins
- Better alert message if error 429

## 1.0.1 - 2014-04-04 - 'Phoenix'

Release!

It should have been 1.0.0, but a PEBKAC happened and, yeah, so 1.0.1 it is.
