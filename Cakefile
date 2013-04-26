db = require './lib/db'
User = require './app/models/user'

task 'create:craig', ->
  db.open ->
    user = new User name: 'Craig'
    user.save console.log

task 'delete:craig', ->
  db.open ->
    User.findOne name: 'Craig', (err, doc) ->
      user = new User doc
      user.destroy console.log