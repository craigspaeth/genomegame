express = require 'express'
routes = require './app/routes'
path = require 'path'
db = require './lib/db'
global.nap = require 'nap'
http = require 'http'
socketio = require 'socket.io'

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
      all: []

# Load routes
for route, fn of routes
  verb = route.split(' ')[0]
  path = route.split(' ')[1]
  app[verb.toLowerCase()] path, fn

# Start app server
server = app.listen app.get("port")

# Open DB connection
db.open (err) -> console.warn err if err

# Connect socket IO
io = socketio.listen(server, log: off)
io.on 'connection', (socket) ->
  socket.on 'user:enter', (id) ->
    io.sockets.emit 'user:enter', id