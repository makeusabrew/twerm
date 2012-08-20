Feed = require "./consumers/feed"
Renderer = require "./renderer"

feed = new Feed()

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
    clearLine()
    
    # add the data
    process.stdout.write data+"\n"

    # restore the contents of the current line
    doPrompt()

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

feed.on "tweet", (tweet) ->
    writeLine Renderer.renderTweet tweet

feed.on "unknown", (data) ->
    writeLine "unknown..."

feed.on "frnds", (friends) ->
    writeLine "got friends..."
