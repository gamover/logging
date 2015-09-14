generateMessage = (type = null, source = null)->
  type = type ? Random.choice MESSAGE_TYPES
  source = source ? Random.choice SOURCES
  type: type
  source: source
  message: source + ' ' + type + ' message'
  date: new Date()

Logs.remove({})
((cnt) -> Logs.insert generateMessage()) cnt for cnt in [1..100]

Meteor.publish 'messages', (limit = 0, type = null, source = null) ->
  selector = {}
  if type?
    selector.type = type
  if source?
    selector.source = source

  if limit >= Logs.find(selector).count() - MESSAGES_INCREMENT
    Meteor.setTimeout ->
      count = Logs.find(selector).count() + 1
      ((cnt) -> Logs.insert generateMessage(type, source)) cnt for cnt in [count..count + MESSAGES_INCREMENT - 1]
    , 0

  Counts.publish this, 'messagesCount', Logs.find selector
  Logs.find selector, limit: limit