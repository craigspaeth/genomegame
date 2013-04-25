express = require 'express'
routes = require './app/routes'
path = require 'path'
db = require './lib/db'
global.nap = require 'nap'

# Configure App
app = express()
app.configure ->
  @set "port", process.env.PORT or 3000
  @set "views", __dirname + "/app/templates"
  @set "view engine", "jade"
  @use express.favicon()
  @use express.logger("dev")
  @use express.bodyParser()
  @use express.methodOverride()
  @use express.cookieParser()
  @use express.cookieSession secret: 'Genome123'
  @use @router
  @use express.static(path.join(__dirname, "public"))
  @use express.errorHandler()

# Configure nap
nap
  assets:
    js:
      vendor: [
        '/app/client/vendor/jquery.js'
        '/app/client/vendor/underscore.js'
        '/app/client/vendor/backbone.js'
      ]
      all: ['/app/client/**/*.coffee']
    css:
      all: ['/app/stylesheets/**/*.styl']
    jst:
      all: []
  
for route, fn of routes
  verb = route.split(' ')[0]
  path = route.split(' ')[1]
  app[verb.toLowerCase()] path, fn

app.listen app.get("port"), ->
  console.log "Express server listening on port " + app.get("port")
db.open (err) -> console.warn(err) if err
nap.package() if process.env.NODE_ENV is 'production'