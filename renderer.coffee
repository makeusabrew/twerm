require "colors"

###
# simply pad a string, currently hard coded to a space to the right
###
pad = (str, len) ->
    if str.length < len
        return pad str + " ", len
    return str

###
# return a Date object in dd/mm/yyyy hh:ii:ss
###
dateFormat = (date) ->

    day = date.getDate()
    day = "0#{day}" if day < 10

    month = date.getMonth() + 1
    month = "0#{month}" if month < 10

    year = date.getFullYear()

    hours = date.getHours()
    hours = "0#{hours}" if hours < 10

    mins = date.getMinutes()
    mins = "0#{mins}" if mins < 10

    secs = date.getSeconds()
    secs = "0#{secs}" if secs < 10

    return "#{hours}:#{mins}:#{secs} #{day}/#{month}/#{year}"

module.exports =
    renderTweet: (tweet) ->
        date = dateFormat new Date tweet.created_at
        screenName = pad tweet.user.screen_name + ":", 20

        return "[" + "#{date}".yellow + "] " + "@#{screenName}".bold + "#{tweet.text}"
