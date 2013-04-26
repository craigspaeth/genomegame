User = require "#{process.cwd()}/app/models/user"
_ = require 'underscore'

@['GET users/:id'] = (req, res) ->
  user = new User _id: req.params.id
  user.fetch (err, doc) ->
    return res.send 500, err if err
    res.send user.toJSON()
    
@['GET users'] = (req, res) ->
  User.find().toArray (err, docs) ->
    return res.send 500, err if err
    res.send User.docsToJSON(docs)

@['POST users'] = (req, res) ->
  user = new User req.body
  return res.send 403 unless user.get 'name'
  user.save (err, docs) ->
    return res.send 500, err if err
    user.set docs[0]
    req.session.userId = user.id()
    res.send user.toJSON()
    
@['PUT users/:id'] = (req, res) ->
  delete req.body.points
  user = new User _id: req.params.id
  return res.send 500 unless user.get('_id')
  user.fetch (err) ->
    return res.send 500, err if err
    user.set(req.body).save (err, docs) ->
      return res.send 500, err if err
      res.send user.toJSON()
    
@['DELETE users/:id'] = (req, res) ->
  user = new User _id: req.params.id
  user.fetch (err, doc) ->
    return res.send 500, err if err
    req.session.userId = null
    user.destroy (err) ->
      return res.send 500, err if err
      res.send user.toJSON()