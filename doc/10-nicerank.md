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

- A new ADN user will typically start with 2.1

- A regular user will always be > 2

- Very active and 'social' users will be > 3

*Again, this is not a popularity ratio: far from it. It only serves as a filter for bots and spam.*

In addition to this manual rank filter, NiceRank and Ayadn have other automatic filtering based upon the information publicly available about the users.

## Threshold

Set the NiceRank threshold.

You can use an integer or a float (only one decimal).

Any user with a NiceRank smaller than this value will be ignored in the Global stream.

`ayadn set nicerank threshold 2.5`

`ayadn set nicerank threshold 3`

(default: 2.1)

## Deactivate NiceRank

NiceRank is enabled by default on new Ayadn installations, but can be disabled if needed:

`ayadn set nicerank filter false`

*Note: the other field, `unranked`, can be activated to ignore the users who haven't been analysed by NiceRank yet. It's more an experimental feature, and it's actually recommended to always let it to false.*
