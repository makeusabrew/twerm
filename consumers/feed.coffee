zmq = require "zmq"
EventEmitter = require("events").EventEmitter

class Feed
    constructor: ->
        @ee = new EventEmitter()
        subscriber = zmq.socket "sub"

        subscriber.subscribe "tweet"
        subscriber.subscribe "frnds"

        subscriber.connect "tcp://127.0.0.1:5600"

        subscriber.on "message", (data) =>
            data = data.toString 'utf8'

            event = data.substr 0, 5
            msg = data.substr 6

            packet = JSON.parse msg

            @ee.emit event, packet

    on: (event, listener) ->
        @ee.on event, listener

module.exports = Feed
