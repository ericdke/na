# 1.4.7 - 'Nozomi'

- Follow/unfollow several users at a time
- In 'convo', both the post id you've requested, and the post it replies to, are marked with arrows
- Faster users lists generation
- Users lists include number of posts/day

# 1.4.6 - 'Roman'

- Temporary fix for filepaths instability when uploading pictures

# 1.4.5 - 'Sébastien'

- Fixed a crash when iTunes Store URL contained exotic characters

# 1.4.4 - 'Randolph'

- Fixed a database problem in PM and SEND

# 1.4.3 - 'Sergent Stretch'

- NowPlaying is compatible with iTunes and Last.fm. Default: iTunes. Add `--last-fm` or `-l` to get Last.fm last played track instead
- NowPlaying audio link has been replaced with an iTunes Store link
- NowPlaying album art now has thumbnails (compatible with Chimp, etc)
- NowPlaying doesn't crash if the iTunes Store doesn't respond
- Better global error and events logging
- Automatically fixes the arguments order for 'post' if needed when uploading a picture
- General code cleaning

# 1.4.2 - 'Caligula'

- Ayadn is more resilient to connectivity errors
- Better handling of filenames when uploading

# 1.4.1 - 'Oh boy'

- A few fixes in the NowPlaying section

# 1.4.0 - 'Florian'

- New feature: embed one or several pictures within a post (in write, post, reply, and pm)
- Nowplaying inserts preview URL and album art from iTunes Store (you can prevent this with: `--no-url`)

# 1.3.2 - 'Max'

- Fixed: Global stream crashed if NiceRank was enabled but unreachable

# 1.3.1 - 'Nico'

- NiceRank threshold is a float again. Default value is 2.1

# 1.3.0 - 'K'

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

# 1.2.10 - 'Anders'

- Fixed the non-installing unicode_utils Gem

# 1.2.9 - 'Kirschen'

- NiceRank database auto-limits to 10000 users
- Better handling of connection errors
- Better display of emojis
- General code cleaning

# 1.2.8 - 'Hans'

- No more Ruby 1.9.3
- Search for users: returns a detailed view of users containing word(s) in their bio/description
- Search for annotations: returns posts containing a specific annotation
- Search for channels containing word(s) in their description
- Search for words in messages (PMs)
- Better display of the starred and replied_to symbols

# 1.2.7 - 'Roman'

- Conform remove_arobase in Switch

# 1.2.6 - 'Saket'

- NiceRank enabled by default on new installs
- NiceRank cache expires after 48h by default
- NiceRank cache auto-limits to 5000 users
- Set the NiceRank cache value (in hours)
- More debug info
- Misc fixes related to recent features

# 1.2.5 - 'Bis repetita'

- Fix the NiceRank filter staying on true

# 1.2.4 - 'Stoopid me'

- Fix the copy/paste error in Settings

# 1.2.3 - 'Taylor'

- Text containing '#' but not an hashtag: not colorized
- Add/remove several elements to/from blacklist at once
- Cached results for NiceRank (expire = 24h)
- NiceRank filter works better
- NiceRank logs missed users ids in a separate file
- Option for showing debug messages
- Show spinner = true

# 1.2.2 - 'Chris'

- No more empty lines in the scroll
- Spinner while waiting for posts (false by default)
- Hashtags support accented characters

# 1.2.1 - 'Vinz'

- Fixed the exclusion bug in NiceRank filters
- Improved the truncation in Mark list
- Changes to match changes in NiceRank API

# 1.2.0 - 'Jason'

- @matigo's NiceRank filter for the Global stream

# 1.1.3 - 'Kevin'

- Bookmark a conversation
- List, delete, rename bookmarks

# 1.1.2 - 'Craig'

- URL for the docs

# 1.1.1 - 'State Of The Onion'

- Star and unstar a reposted post
- Nowplaying shows an error message if iTunes is closed or not currently playing any track

# 1.1.0 - 'Leviathan'

- Show who's writing, and who's the recipient
- Less help text when writing, more concise
- The blacklist works better (recorded and compared downcased)
- New command: convert blacklist
- Export blacklist as CSV, aliases and settings as JSON
- New option: 'extract'. Extracts all links from results of a search by word or by hashtag, or from the 'what starred' command
- New command: show current version
- New command: photos stream
- New command: delete message (private or in a channel)

# 1.0.13 - 'Charlotte'

- New layout for '#nowplaying'
- Compact index.db and pagination.db if necessary
- New api urls
- Fix 'download file'

# 1.0.12 - 'Rolando'

- Fixed an error in: authorizing an account if its folders already exists

# 1.0.11 - 'Chris'

- There was a typo in the last version that caused a bug in the PM command

# 1.0.10 - 'Johannes'

- Fixes the help bug (doubled commands)
- Auto adds the @ if missing in pm

# 1.0.9 - 'Brian'

- Fixes the stubborn 'nowplaying' database bug

# 1.0.8 - 'Laurent'

- Better error messages/logs (specifically when HTTP errors)
- Token is anonymized if in error logs
- No more database error when canceling a 'nowplaying' post
- Better mentions colorization

# 1.0.7 - 'Hugo'

- Machine-only messages in channels are now viewable
- Don't output "Downloading" if options = raw in messages view
- Alert message instead of crash when an alias is undefined
- Removed username in front of ">>" in Auto (in case the authd user changed)
- Compatibility with Windows is broken

# 1.0.6 - 'Matthew'

- Fixed a bug where post_max_chars was displayed instead of message_max_chars
- Show raw JSON in messages even if no data

# 1.0.5 - 'Joel'

- Fixed the colorization for mentions
- Added tests for colorization

# 1.0.4 - 'Jeremy'

- Fixed 'reply to an indexed stream' for Ruby < 2.1
- More tests for Databases
- Tests for Blacklist
- Tests for Set

# 1.0.3 - 'Donny'

- Fixed the bug introduced by the last bugfix (yes, I know... sigh...)

# 1.0.2 - 'Mark'

- Fixed a critical bug in Reply (when the original post was a repost)
- Tests for Databases
- Tests for Posts & Messages
- Better layout for checkins
- Better alert message if error 429

# 1.0.1 - 'Phoenix'

Release!

It should have been 1.0.0, but a PEBKAC happened and, yeah, so 1.0.1 it is.
