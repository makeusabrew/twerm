require "colors"

###
# simply pad a string, currently hard coded to a space to the right
###
pad = (str, char, len, right) ->
    if str.length < len
        if right
            return pad str + char, char, len, right
        else
            return pad char + str, char, len, right
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


###
# make entity order a bit more sane
###
processEntities = (entities) ->
    orderedEntities = []
    entityTypes = ['urls', 'media', 'hashtags', 'user_mentions']
    i = entityTypes.length

    # let's make a flat array of entities
    while i
        i -= 1
        eType = entityTypes[i]
        continue if not entities[eType]?

        j = entities[eType].length

        while j
            j -= 1
            entity = entities[eType][j]
            entity.eType = eType
            orderedEntities.push(entity)

    # get the entities array in ascending order
    orderedEntities.sort (a, b) ->
        return a.indices[0] - b.indices[0]

    return orderedEntities

###
# spice up entities
###
formatText = (text, entities) ->

    i = entities.length
    while i
        i -= 1
        display = i+1

        entity = entities[i]
        start = entity.indices[0]
        end   = entity.indices[1]

        insert = ''

        switch entity.eType

            when "urls"
                url = entity.expanded_url || entity.url
                insert = url.green

            when "media"
                url = entity.expanded_url || entity.media_url
                insert = url.green

            when "user_mentions"
                insert = "@#{entity.screen_name}".magenta

            when "hashtags"
                insert = "##{entity.text}".cyan

        insert += " " + "[#{display}]".bold

        text = text.substring(0, start) + insert + text.substring(end)

    return text

module.exports =
    renderTweet: (tweet, index) ->
        date = dateFormat new Date tweet.created_at
        screenName = pad tweet.user.screen_name + ":", " ", 20, true

        entities = processEntities tweet.entities

        text = formatText tweet.text, entities

        index = pad index.toString(), "0", 4, false

        return "" +
        "[#{index}] " +
        "[" + "T".cyan + "] " +
        "[" + "#{date}".yellow + "] " +
        "@#{screenName}".bold +
        "#{text}"
