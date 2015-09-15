Template.messages.helpers(
  messages: ->
    filter = Session.get 'filter'
    sort = Session.get 'sort'
    search = Session.get 'search'

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

    Logs.find selector, params

  isSortField: (field)->
    sort = Session.get 'sort'
    sort? and sort.field is field

  isSortDirAsc: ->
    Session.get('sort')?.dir is 1
)

Template.messages.events(
  'click .sort-header': (event)->
    field = $(event.currentTarget).data 'field'
    sort = Session.get('sort') ? {}
    dir = if field is sort.field and sort.dir? then -sort.dir else 1

    sort.field = field
    sort.dir = dir

    Session.set 'sort', sort

  'input #search-message': (event)->
    text = $(event.target).val()
    if text.length >= 3
      Session.set 'search', { message: text }
    else
      Session.set 'search', null
)