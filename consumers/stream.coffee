https = require "https"
EventEmitter = require("events").EventEmitter

class Consumer
    constructor: ->
        @ee = new EventEmitter()
        @strpos = -1
        @buffer = ""
    
    start: (auth) ->
        options =
            host: "userstream.twitter.com"
            port: 443
            path: "/2/user.json"
            headers:
                authorization: auth

        https.get options, (response) =>
            process.stdout.write "Not connected [#{response.statusCode}]" if response.statusCode isnt 200
            response.setEncoding "utf8"

            response.on "data", (chunk) =>
                @processChunk chunk

            response.on "end", ->
                process.stdout.write "stream connection ended\n"

    on: (event, listener) ->
        @ee.on event, listener

    emitEvent: (data) ->
        
        return @ee.emit "tweet", data if data.text and data.user

        return @ee.emit "friends", data if data.friends

        @ee.emit "unknown", data

    processChunk: (chunk) ->
        delimPos = chunk.indexOf "\r\n"

        data = chunk.substr 0, delimPos

        if data.length
            process.stdout.write "+"
            @emitEvent JSON.parse data
        else
            process.stdout.write "-"

module.exports = Consumer
