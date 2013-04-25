{ ObjectID } = mongodb = require 'mongodb'
db = require "#{process.cwd()}/lib/db"
_ = require 'underscore'

module.exports = class Base
  
  collection: ->
    db.collection @collectionName
  
  constructor: (@attrs = {}) ->
    throw "You must specify a collectionName" unless @collectionName?
    
  id: ->
    return null unless @get('_id')
    new ObjectID(@get('_id').toString())
  
  get: (attr) ->
    @attrs[attr]
  
  set: (attrs) ->
    @attrs[key] = val for key, val of attrs
    
  save: (cb) ->
    if @id()
      @collection().update { _id: @id() }, @attrs, { upsert: true }, cb
    else
      @collection().insert @attrs, cb
        
  fetch: (cb) ->
    return cb?("Must have _id to fetch.") unless @id()
    @collection().findOne { _id: @id() }, (err, doc) =>
      @set doc unless err
      cb? arguments...
    
  destroy: (cb) ->
    @collection().remove { _id: @id() }, cb
  
  toJSON: ->
    _.extend @attrs, { id: @get('_id'), _id: undefined }
  
  @docsToJSON: (docs) ->
    models = (new @(doc) for doc in docs)
    (model.toJSON() for model in models)
  
  for method in ['find', 'findOne', 'update', 
                 'insert', 'findAndModify', 'drop', 'count']
    @[method] = _.partial ((method, args...) ->
      db.collection(@::collectionName)[method] args...
    ), method