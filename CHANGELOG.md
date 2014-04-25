# 1.0.13

- New layout for '#nowplaying'
- Compact index.db and pagination.db if necessary

# 1.0.12

- Fixed an error in: authorizing an account if its folders already exists

# 1.0.11

- There was a typo in the last version that caused a bug in the PM command

# 1.0.10

- Fixes the help bug (doubled commands)
- Auto adds the @ if missing in pm

# 1.0.9

- Fixes the stubborn 'nowplaying' database bug

# 1.0.8

- Better error messages/logs (specifically when HTTP errors)
- Token is anonymized if in error logs
- No more database error when canceling a 'nowplaying' post
- Better mentions colorization

# 1.0.7

- Machine-only messages in channels are now viewable
- Don't output "Downloading" if options = raw in messages view
- Alert message instead of crash when an alias is undefined
- Removed username in front of ">>" in Auto (in case the authd user changed)
- Compatibility with Windows is broken

# 1.0.6

- Fixed a bug where post_max_chars was displayed instead of message_max_chars
- Show raw JSON in messages even if no data

# 1.0.5

- Fixed the colorization for mentions
- Added tests for colorization

# 1.0.4

- Fixed 'reply to an indexed stream' for Ruby < 2.1
- More tests for Databases
- Tests for Blacklist
- Tests for Set

# 1.0.3

- Fixed the bug introduced by the last bugfix (yes, I know... sigh...)

# 1.0.2

- Fixed a critical bug in Reply (when the original post was a repost)
- Tests for Databases
- Tests for Posts & Messages
- Better layout for checkins
- Better alert message if error 429

# 1.0.1

Release!

It should have been 1.0.0, but a PEBKAC happened and, yeah, so 1.0.1 it is.
