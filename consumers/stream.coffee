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

        process.stdout.write "."

        wireData = JSON.stringify data

        return @ee.emit "tweet", wireData if data.text and data.user

        return @ee.emit "friends", wireData if data.friends

        @ee.emit "unknown", data

    processChunk: (chunk) ->
        @buffer += chunk
        @strpos = @buffer.indexOf "\r"

        if @strpos isnt -1
            data = @buffer.substr 0, @strpos
            if data.length > 1
                @emitEvent JSON.parse data
            else
                #console.log "ignoring heartbeat "+data.length

            # make sure we don't lose the remainder
            @buffer = @buffer.substr @strpos+1

module.exports = Consumer
