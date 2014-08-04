# MOVIE (nowwatching)

Create a post from (part of) a movie title. Includes movie poster, IMDb url and hashtag.

Usage:

`ayadn movie ghost in the shell`

`ayadn movie existenz`

`ayadn -NW beetlejuice`

(shortcut is 'NW' because of 'nowwatching')

## ALT

If the movie is not the one you're looking for, you can specify the 'alt' option to force find an alternative.

This is useful for remakes:

`ayadn -NW solaris`

(gives the 2002 version)

`ayadn -NW solaris --alt`

(gives the 1972 version)

## ALIASES

`ayadn nowwatching godfather II`

`ayadn imdb -a conan`

## HASHTAG

You can modify the hashtag with 'set':

`ayadn set movie hashtag movietime`

`ayadn set movie hashtag adnmovieclub`

(default is 'nowwatching')



