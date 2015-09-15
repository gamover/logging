startDate = null
endDate = null

Template.filter.helpers (
  types: MESSAGE_TYPES
  sources: SOURCES
  typeSelected: (type) ->
    'selected' if Session.get('filter')?.type is type

  sourceSelected: (source) ->
    'selected' if Session.get('filter')?.source is source

  limit: ->
    Session.get('filter')?.limit

  paused: ->
    !!Session.get 'paused'

  filtered: ->
    Session.get('filter')?
)

Template.filter.events(
  'submit .filter': (event)->
    event.preventDefault()

    filter = null
    type = event.target.type.value if event.target.type.value isnt ''
    source = event.target.source.value if event.target.source.value isnt ''
    limit = parseInt(event.target.limit.value) if event.target.limit.value isnt ''
    if type? or source? or (startDate? and endDate?) or limit?
      filter = {}
      filter.type = type if type?
      filter.source = source if source?
      filter.startDate = startDate.toDate() if startDate?
      filter.endDate = endDate.toDate() if endDate?
      filter.limit = limit if limit?

    Session.set 'filter', filter
    Session.set 'messagesLimit', MESSAGES_INCREMENT

  'click .reset-filter': ->
    startDate = null
    endDate = null
    $('form.filter input[name="dates"]').val ''
    Session.set 'filter', null
    Session.set 'messagesLimit', MESSAGES_INCREMENT

  'click .pause-sync': ->
    Session.set 'paused', !Session.get 'paused'

  'cancel.daterangepicker form.filter input[name="dates"]': ->
    startDate = null
    endDate = null
    $('form.filter input[name="dates"]').val ''

  # Не работает (глюк???)
#  'apply.daterangepicker form.filter input[name="dates"]': (ev, picker)->
#    startDate = picker.startDate.startOf 'minute'
#    endDate = picker.endDate.endOf 'minute'
)

Template.filter.rendered = ->
  input = $('form.filter input[name="dates"]')

  params = {
    locale: cancelLabel: 'Clear'
    timePicker: true
    timePickerIncrement: 1
    timePicker12Hour: false
    format: 'DD.MM.YYYY HH:mm:SS'
    separator: ' - '
  }

  input.on 'apply.daterangepicker', (event, picker)->
    startDate = picker.startDate.startOf 'minute'
    endDate = picker.endDate.endOf 'minute'

  Deps.autorun ->
    filter = Session.get('filter') ? {}
    if filter.startDate? and filter.endDate?
      input.val moment(filter.startDate).format('DD.MM.YYYY HH:mm:SS') + ' - ' + moment(filter.endDate).format('DD.MM.YYYY HH:mm:SS')
      params.startDate = filter.startDate
      params.endDate = filter.endDate

    input.daterangepicker params, (start, end)->
      startDate = start.startOf 'minute'
      endDate = end.endOf 'minute'