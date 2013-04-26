{ Collection, MongoClient } = mongodb = require 'mongodb'
_ = require 'underscore'

@open = (callback) =>
  return callback? null, @db if @db
  uri = process.env.MONGO_URI or "mongodb://127.0.0.1:27017/genomegame"
  MongoClient.connect uri, (@err, @db) => callback? @err, @db
    
@close = =>
  ensureConnected()
  @db.close()

@collection = (name) =>
  ensureConnected()
  new Collection @db, name
  
ensureConnected = =>
  throw @err or "No database client open. Try running require('lib/db').open" unless @db?