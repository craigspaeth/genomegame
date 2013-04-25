glob = require 'glob'

@['GET /'] = (req, res) ->
  res.render "index",
    title: "Express"

# Load API routes
for file in glob.sync __dirname + '/api/**/*'
  for route, fn of require(file)
    verb = route.split(' ')[0]
    path = route.split(' ')[1]
    @["#{verb} /api/#{path}"] = fn