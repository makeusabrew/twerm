zmq    = require "zmq"
Stream = require "./consumers/stream"

publisher = zmq.socket "pub"

publisher.bindSync "tcp://127.0.0.1:5600"

consumer = new Stream()

throw "Sorry, please specify an auth header" unless process.argv[2]

consumer.start process.argv[2]

consumer.on "tweet", (tweet) ->
    publisher.send "tweet|#{tweet}"

consumer.on "unknown", (data) ->
    console.log "unknown"

consumer.on "friends", (friends) ->
    publisher.send "frnds|#{friends}"
