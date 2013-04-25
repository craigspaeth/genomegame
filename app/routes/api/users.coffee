User = require "#{process.cwd()}/app/models/user"
    
@['GET users'] = (req, res) ->
  User.find().toArray (err, docs) ->
    return res.send 500, err if err
    res.send User.docsToJSON(docs)