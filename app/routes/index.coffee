glob = require 'glob'

# Load API routes
for file in glob.sync __dirname + '/api/**/*'
  for route, fn of require(file)
    verb = route.split(' ')[0]
    path = route.split(' ')[1]
    @["#{verb} /api/#{path}"] = fn

# Push state fallbacks
indexRoutes = [
  'GET /'
  'GET /join'
  'GET /game'
]
for route in indexRoutes
  @[route] = (req, res) ->
    res.render "index",
      title: "Express"
      userId: req.session.userId
      timeout: require('../../sockets').TIMEOUT
      
console.log require('../../sockets').TIMEOUT