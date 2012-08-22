# twerm - your terminal's favourite twitter client

## Please note: not alot works at the moment

To run in its current nascent state, you'll need to start a stream
consumer standalone - this will change over time:

```coffee stream.coffee '[full oauth header here]'```

Once started, the idea is multiple consumers of the stream can co-exist
off only one connection to userstream.twitter.com. At the moment, only
```feed.coffee``` exists, but the idea is to make standalone scripts to
consume mentions, DMs etc, or allow them as flags to feed.coffee.

### N.B. You can't tweet yet :)

## Here's a diagram of some (slightly inaccurate) thoughts:

![diagram](https://docs.google.com/drawings/pub?id=1wySIU4xwdIvK-BqjeseRjxVA27qFqEVCvm5p-ryBcqY&amp;w=1054&amp;h=772 "Diagram")
