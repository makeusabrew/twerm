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

###
# actual feed related logic
###
feed = new Feed()

tweetCount = 0
feed.on "tweet", (tweet) ->
    tweetCount += 1
    writeLine Renderer.renderTweet tweet, tweetCount

feed.on "unknown", (data) ->
    writeLine "unknown..."

feed.on "frnds", (friends) ->
    writeLine "got friends..."

#feed.ee.emit "tweet", {"text":"Fashion Orders Startup Miinto Secures $6M Series A Round From Dawn Capital http:\/\/t.co\/R944y8Ki by @mikebutcher","contributors":null,"in_reply_to_user_id":null,"truncated":null,"possibly_sensitive_editable":true,"id_str":"237881819855470592","entities":{"user_mentions":[{"screen_name":"mikebutcher","indices":[99,111],"id_str":"13666","name":"Mike Butcher","id":13666}],"hashtags":[],"urls":[{"indices":[75,95],"url":"http:\/\/t.co\/R944y8Ki","display_url":"tcrn.ch\/PBRwu8","expanded_url":"http:\/\/tcrn.ch\/PBRwu8"}]},"retweeted":false,"retweet_count":0,"created_at":"Tue Aug 21 12:00:20 +0000 2012","place":null,"coordinates":null,"source":"\u003Ca href=\"http:\/\/vip.wordpress.com\/hosting\" rel=\"nofollow\"\u003EWordPress.com VIP\u003C\/a\u003E","in_reply_to_status_id":null,"in_reply_to_status_id_str":null,"favorited":false,"possibly_sensitive":false,"user":{"geo_enabled":false,"profile_link_color":"0888C4","screen_name":"TechCrunch","profile_background_image_url_https":"https:\/\/si0.twimg.com\/profile_background_images\/553722652\/twitter.png","friends_count":817,"profile_background_color":"149500","id_str":"816653","listed_count":67740,"lang":"en","profile_background_tile":false,"created_at":"Wed Mar 07 01:27:09 +0000 2007","description":"Breaking Technology News And Opinions From TechCrunch","profile_sidebar_fill_color":"DDFFCC","url":"http:\/\/techcrunch.com","default_profile":false,"follow_request_sent":null,"contributors_enabled":false,"verified":true,"followers_count":2357252,"is_translator":false,"statuses_count":45433,"following":null,"profile_sidebar_border_color":"BDDCAD","profile_image_url_https":"https:\/\/si0.twimg.com\/profile_images\/2176846885\/-5-1_normal.jpeg","protected":false,"location":"Silicon Valley","show_all_inline_media":false,"notifications":null,"profile_use_background_image":true,"profile_image_url":"http:\/\/a0.twimg.com\/profile_images\/2176846885\/-5-1_normal.jpeg","name":"TechCrunch","default_profile_image":false,"profile_text_color":"222222","id":816653,"profile_background_image_url":"http:\/\/a0.twimg.com\/profile_background_images\/553722652\/twitter.png","time_zone":"Pacific Time (US & Canada)","utc_offset":-28800,"favourites_count":34},"in_reply_to_screen_name":null,"id":237881819855470592,"in_reply_to_user_id_str":null,"geo":null}
