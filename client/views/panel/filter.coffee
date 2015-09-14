Template.filter.helpers (
  types: MESSAGE_TYPES
  sources: SOURCES,
  typeSelected: (type) ->
    'selected' if Session.get('filter')?.type is type
  sourceSelected: (source) ->
    'selected' if Session.get('filter')?.source is source
  limit: ->
    Session.get('filter')?.limit
  paused: ->
    !!Session.get 'paused'
)

Template.filter.events(
  'submit .filter': (event)->
    event.preventDefault()

    filter = {}
    filter.type = event.target.type.value if event.target.type.value isnt ''
    filter.source = event.target.source.value if event.target.source.value isnt ''
    filter.limit = parseInt(event.target.limit.value) if event.target.limit.value isnt ''

    Session.set 'filter', filter
    Session.set 'messagesLimit', MESSAGES_INCREMENT

  'click .reset-filter': ->
    Session.set 'filter', null
    Session.set 'messagesLimit', MESSAGES_INCREMENT

  'click .pause-sync': ->
    Session.set 'paused', !Session.get 'paused'
)