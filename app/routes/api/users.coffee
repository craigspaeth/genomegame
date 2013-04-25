User = require "#{process.cwd()}/app/models/user"
    
@['GET users'] = (req, res) ->
  User.find().toArray (err, docs) ->
    return res.send 500, err if err
    res.send User.docsToJSON(docs)

@['POST users'] = (req, res) ->
  user = new User req.body
  req.session.user = user
  user.save (err, doc) ->
    return res.send 500, err if err
    res.send user.toJSON()
    
@['DELETE users/:id'] = (req, res) ->
  user = new User _id: req.params.id
  user.fetch (err, doc) ->
    return res.send 500, err if err
    user.destroy (err) ->
      return res.send 500, err if err
      res.send user.toJSON()