_ = require('underscore')
couch_utils = require('./couch_utils')

x = {}

x.mk_objs = (obj, path_array, val={}) ->
  ###
  make a set of nested object.

  obj = {'x': 1}
  mk_objs(obj, ['a', 'b'], ['1'])
  # returns []
  # obj now equals {'x': 1, 'a': {'b': ['1']}}

  return the val
  ###
  last_key = path_array.pop()
  for key in path_array
    if not obj[key]?
      obj[key] = {}
    obj = obj[key]
  if not obj[last_key]
    obj[last_key] = val
  return obj[last_key]

# x.deep_merge = (obj1, obj2) ->


x.process_resp = (callback) ->
  ###
  process a request HTTP response. return a standardized
  error regardless of whether there was a transport error or a server error
  ###
  (err, resp, body) ->
    if err or resp.statusCode > 400
      err = {err: err, msg: body, code: resp?.statusCode}
    callback(err, resp, body)

x.compact_hash = (hash) ->
  ###
  given a hash return a new hash with only non-falsy values. 
  if the hash will be empty, return undefined
  ###
  out = _.pick(hash, _.identity)
  if _.isEmpty(out)
    return undefined
  else
    return out

x.get_org_dbs = (callback) ->
  ###
  return all organization databases
  ###
  await couch_utils.nano_admin.db.list(defer(err, dbs))
  if err then return callback(err)
  out = _.filter(dbs, (x) -> x.indexOf('org_') == 0)
  return callback(null, out)

module.exports = x