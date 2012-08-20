require "colors"

pad = (str, len) ->
    if str.length < len
        return pad str + " ", len
    return str

module.exports =
    renderTweet: (tweet) ->
        screenName = pad tweet.user.screen_name+":", 20

        return "@#{screenName}".bold + "#{tweet.text}"
