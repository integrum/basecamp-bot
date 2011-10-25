Campfire = require("campfire").Campfire
config = require "config"
nimble = require "nimble"

http = require "http"
url = require "url"

campfire = new Campfire
  ssl: true
  token: config.token
  account: "integrum"

urls = []

campfire.join 375249, (error, room) ->
  room.listen (message) ->
    console.log "there was a message"
    if message.body == "test"
      console.log "body was test!!!"
      room.speak "Hello world", (err, response) ->
        console.log err
        console.log "sent hello world #{response.message.created_at}"
    else if message.body == "urls"
      room.speak "Here are the callback urls: #{urls.join(", ")}", ->
    else if message.body?.match /add url/
      _url = message.body.split(" ")[2]
      urls.push(_url)
      room.speak "the url #{_url} was added"
    else if message.body?.match /the url/
    else if message.body?.match /Here are/
    else if message.body?.match /Here is/
    else
      nimble.each urls, (_url, callback) ->
        myUrl = url.parse _url 
        request = http.get
          host:  myUrl.host
          path: myUrl.pathname + message.body
          port: myUrl.port or 80
        data = ""
        request.on "data", (chunk)->
          console.log data
          data += chunk.toString()
        request.on "end", () ->
          if data
            room.speak "Here is the result: " + data, ->
          callback null

      console.log "the body was #{message.body}"
        
