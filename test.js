Campfire = require("campfire").Campfire;
config = require("config")
var instance = new Campfire({
  ssl     : false,
  token   : config.token,
  account : "drew.lesueur"
});

instance.join(71764, function(error, room) {
  room.listen(function(message) {
    if (message.body == "PING") {
      console.log("PING received.");

      room.speak("PONG", function(error, response) {
        console.log("PONG sent at " + response.message.created_at + ".");
      });
    } else {
      console.log("Received unknown message:");
      console.log(message);
    }
  });
});
