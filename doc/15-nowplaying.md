# NOWPLAYING

Post what you're listening to!

## iTunes

OS X only.

`ayadn nowplaying`

`ayadn -NP`

Ayadn will grab information from your running iTunes, format it, insert the *#nowplaying* hashtag then ask for your confirmation before posting it.

It will also grab a link to the album and the album artwork from the iTunes Store (you can prevent this behavior by adding the `--no_url` option (short: `-n`).

## Last.fm

`ayadn nowplaying --last-fm`

`ayadn -NP -l`

Ayadn will grab information from your Last.fm account, format it, insert the *#nowplaying* hashtag then ask for your confirmation before posting it.

It will also grab a link to the album and the album artwork from the iTunes Store (you can prevent this behavior by adding the `--no_url` option (short: `-n`).

## Deezer

`ayadn nowplaying --deezer`

`ayadn -NP -d`

Ayadn will grab information from your Deezer account (you will be prompted to authorize Ayadn for Deezer the first time you launch this command), format it, insert the *#nowplaying* hashtag then ask for your confirmation before posting it.

It will also grab a link to the album and the album artwork from the iTunes Store (you can prevent this behavior by adding the `--no_url` option (short: `-n`).

## Options

Specify a custom hashtag:

`ayadn -NP -h listeningto`

Specify a custom text:

`ayadn -NP -t "I loved this song so much when I was young."`

Works with all sources.
