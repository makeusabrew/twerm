# hook up stdin
process.stdin.resume()
process.stdin.setEncoding "utf8"
process.stdin.setRawMode true

prompt      = "> "
currentLine = ""

process.stdin.on "data", (char) ->
    if char is "\r"
        clearLine()
        process.stdout.write currentLine+"\n"
        currentLine = ""
        return

    process.stdout.write char
    currentLine += char

setInterval ->
    # clear whatever the last line is
    clearLine()
    
    # add the "tweet"
    process.stdout.write "hi, pretend this is a tweet\n"

    # restore the contents of the current line
    process.stdout.write prompt+currentLine
, 1000

clearLine = ->
    # [2K = clear line
    # [(n)D = move (n) characters left
    process.stdout.write "\u001B[2K\u001B[100D"
