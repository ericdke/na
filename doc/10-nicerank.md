# NiceRank

[NiceRank](http://jasonirwin.ca/2014/05/14/thinking-about-nicerank/) is a filter provided by Jason Irwin.

Thanks to this algorithm, you will be able to filter the spammers out of the Global stream!

It provides a whole new experience of ADN, and brings you back the pleasure of discovering new people to follow.

Ayadn is compatible with NiceRank since version 1.2.

*NiceRank only works with the Global stream.*  

## The scale

NiceRank analyzes App.net users, applies filters then attributes the users a score from 0 to 5.

*This is not a 'Klout' for ADN: NiceRank's only purpose is to differentiate spammers from regular users.*

An idea of the scale:

- A spammer's rank is always < 1

- A user posting a lot of automated links without being active otherwise will be < 2

- A new ADN user will typically start with 2

- A regular user will always be > 2

- Active regular users will be > 3

- Very 'social' users can be > 4

*Again, this is not a popularity ratio: far from it. It only serves as a filter for bots and spam.*


## Activate NiceRank

NiceRank is disabled by default.

Enable it with:

`ayadn set nicerank filter true`

My advice is to also filter out the few users that NiceRank haven't analyzed yet, as most of them are bots:

`ayadn set nicerank filter_unranked true`

## Threshold

Set the NiceRank threshold.

Any user with a NiceRank smaller than this value will be ignored.

`ayadn set nicerank threshold 2`  

## Deactivate NiceRank

It's the same as above, with *false* instead of *true*.  
