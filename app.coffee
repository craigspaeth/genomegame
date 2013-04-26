express = require 'express'
routes = require './app/routes'
path = require 'path'
db = require './lib/db'
global.nap = require 'nap'
http = require 'http'
User = require './app/models/user'

# Configure App
app = express()
app.configure ->
  @set "port", process.env.PORT or 3000
  @set "views", __dirname + "/app/templates"
  @set "view engine", "jade"
  @use express.favicon()
  # @use express.logger("dev")
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
        '/app/client/vendor/**/*'
      ]
      all: [
        '/app/client/lib/**/*.coffee'
        '/app/client/models/**/*.coffee'
        '/app/client/collections/**/*.coffee'
        '/app/client/views/**/*.coffee'
        '/app/client/routers/**/*.coffee'
        '/app/client/app.coffee'
      ]
    css:
      all: ['/app/stylesheets/**/*.styl']
    jst:
      all: [
        '/app/templates/users/**/*.jade'
        '/app/templates/artworks/**/*.jade'
      ]

# Load routes
for route, fn of routes
  verb = route.split(' ')[0]
  path = route.split(' ')[1]
  app[verb.toLowerCase()] path, fn


app.get '*', (req, res, next) ->
  req.session = null
  next()

# Open DB connection, start app server, then load sockets
db.open (err) ->
  User.drop ->
    server = app.listen app.get("port")
    require('./sockets')(server)