# ALIAS

Aliases are names you give to channels for an easier access.

Available subcommands: create, delete, list, import.

Example: you're a [Paste-App](http://paste-app.net/) user and your personal Paste-App channel is 46216.

Instead of getting this channel's messages with 

`ayadn -ms 46216` 

you can create an alias:

`ayadn alias create 46216 pasteapp`

or

`ayadn -A create 46216 pasteapp`

Then you can access this channel with 

`ayadn -ms pasteapp` 

Words are easier to remember than numbers!  

## CREATE

Create an alias for a channel.

`ayadn alias create 46216 pasteapp`

`ayadn -A create 46216 pasteapp`

## DELETE

Delete a channel alias.

`ayadn alias delete pasteapp`

`ayadn -A delete pasteapp`

## LIST

List all your channel aliases.

`ayadn alias list`

`ayadn -A list`
