# 1.2.1 - 'Vinz'

- Fixed the exclusion bug in NiceRank filters
- Improved the truncation in Mark list
- Changes to match changes in NiceRank API

# 1.2.0 - 'Jason'

- @matigo's NiceRank filter for the Global stream

# 1.1.3 - 'Kevin'

- Bookmark a conversation
- List, delete, rename bookmarks

# 1.1.2 - 'Anders'

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
