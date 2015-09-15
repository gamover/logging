generateMessage = (type, source)->
  type = type ? Random.choice MESSAGE_TYPES
  source = source ? Random.choice SOURCES
  type: type
  source: source
  message: source + ' ' + type + ' message'
  date: new Date()

Logs.remove({})
(-> Logs.insert generateMessage()) cnt for cnt in [1..100]

Meteor.publish 'messages', (filter, sort, limit, search)->
  selector = {}
  if filter?
    if filter.type?
      selector.type = filter.type
    if filter.source?
      selector.source = filter.source
    if filter.startDate? and filter.endDate?
      selector.$and = [
        { date: { $gte: filter.startDate } }
        { date: { $lte: filter.endDate } }
      ]
  if search?.message?
    selector.message = { $regex: search.message }

  params = {}
  if sort? and sort.field? and sort.dir?
    params.sort = {}
    params.sort[sort.field] = sort.dir
  if limit?
    params.limit = limit

  count = Logs.find(selector).count()
  if limit >= count - MESSAGES_INCREMENT
    Meteor.setTimeout ->
      (-> Logs.insert generateMessage filter?.type, filter?.source) cnt for cnt in [count + 1..count + MESSAGES_INCREMENT]
    , 0

  Counts.publish this, 'messagesCount', Logs.find selector
  Logs.find selector, params