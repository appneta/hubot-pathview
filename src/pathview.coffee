# Description:
#   Display network path performance from PathView Cloud.
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_PVC_SUBDOMAIN
#   HUBOT_PVC_ACCOUNT
#   HUBOT_PVC_PASSWORD
#
# Commands:
#   hubot (pathview|pvc) me <start> (to)? <finish> - Return the performance of matching PathView Cloud paths
#
# Author:
#   Eronarn

module.exports = (robot) ->
  robot.respond /(pathview|pvc) me (\w*)\s*(to)?\s*(\w*)/i, (msg) ->

    # Get start and finish parameters.
    start = msg.match[2]
    finish = msg.match[4]

    # Get PVC credentials.
    subdomain = process.env.HUBOT_PVC_SUBDOMAIN
    account = process.env.HUBOT_PVC_ACCOUNT
    password = process.env.HUBOT_PVC_PASSWORD

    # Get the base64-encoded auth string.
    auth = new Buffer(account+":"+password).toString('base64')

    # Make a call to the PVC API.
    robot.http("https://"+subdomain+".pathviewcloud.com/pvc-ws/v1/paths?name=*"+start+"*"+finish+"*")
      .header('Authorization', 'Basic '+auth)
      .get() (err, res, body) ->
        if err
          msg.send "didn't work, bro :( #{err}"
          return

        # Get an array of paths.
        paths = JSON.parse body

        # Sort paths by name.
        paths.sort (a,b) ->
          if a.pathName.toUpperCase() >= b.pathName.toUpperCase() then 1 else -1

        # Format paths.
        print = (path) ->
          since = Date(new Date().valueOf() - path.serviceQualityTime);
          msg.send("#{path.pathName} @ #{path.target}: #{path.serviceQuality} since #{since}")

        print path for path in paths
