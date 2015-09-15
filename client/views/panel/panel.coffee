# задание значения по умолчанию для параметра инкрементации сообщений
Session.setDefault 'messagesLimit', MESSAGES_INCREMENT
Session.setDefault 'sort', { field: 'date', dir: 1 }

# подписка на сообщения
Deps.autorun ->
  filter = Session.get 'filter'
  sort = Session.get 'sort'
  limit = Session.get 'messagesLimit'
  search = Session.get 'search'

  Meteor.subscribe 'messages', filter, sort, limit, search

Template.panel.helpers(
  # показывать ли кнопку загрузки дополниетельных сообщений
  showMore: ->
    totalCount = Counts.get 'messagesCount'
    count = Logs.find().count()
    messagePanelBody = $('.message-panel .panel-body').eq(0)
    messagesTable = $('.messages-table').eq(0)
    filterLimit = Session.get('filter')?.limit
    paused = Session.get 'paused'

    totalCount > count &&
      (not filterLimit || filterLimit > count) &&
      messagesTable.height() < messagePanelBody.scrollTop() + messagePanelBody.height() &&
      !paused
)

Template.panel.events(
  'click .show-more': ->
    showMoreMessages()

  'scroll .panel-body': ->
    messagePanelBody = $('.message-panel .panel-body').eq 0
    messagesTable = $('.messages-table').eq 0
    if messagesTable.height() < messagePanelBody.scrollTop() + messagePanelBody.height()
      showMoreMessages()
)

# инициация подгрузки дополнительных сообщений
showMoreMessages = ->
  if Session.get 'paused'
    return

  filterLimit = Session.get('filter')?.limit
  limit = Session.get('messagesLimit') + MESSAGES_INCREMENT
  if 0 < filterLimit < limit
    limit = filterLimit

  Session.set 'messagesLimit', limit