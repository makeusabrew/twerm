Feed = require "./consumers/feed"
Renderer = require "./renderer"

# hook up stdin
process.stdin.resume()
process.stdin.setEncoding "utf8"
process.stdin.setRawMode true

prompt      = "> "
currentLine = ""

clearLine = ->
    # [2K = clear line
    # [(n)D = move (n) characters left
    process.stdout.write "\u001B[2K\u001B[100D"

doPrompt = ->
    process.stdout.write prompt+currentLine

writeLine = (data) ->
    # clear what we've currently got on the last line (either an empty prompt, or a half composed tweet / action)
    clearLine()
    
    # add the data for the new line
    process.stdout.write data+"\n"

    # restore the contents of the current line & prompt
    doPrompt()

process.stdin.on "data", (char) ->
    if char is "\r"
        # carriage return - let's tweet!
        data = currentLine
        currentLine = ""

        writeLine data
    else if char is "\3"
        # CTRL+C; cya!
        process.exit 0
    else if char is "\b"
        currentLine = currentLine.substr 0, -1
    else
        process.stdout.write char
        currentLine += char

###
# actual feed related logic
###

doPrompt()

feed = new Feed()

tweetCount = 0
feed.on "tweet", (tweet) ->
    tweetCount += 1
    writeLine Renderer.renderTweet tweet, tweetCount

feed.on "unknown", (data) ->
    writeLine "unknown..."

feed.on "frnds", (friends) ->
    writeLine "got friends..."
