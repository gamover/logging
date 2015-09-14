Session.setDefault 'messagesLimit', MESSAGES_INCREMENT

Deps.autorun ->
  filterLimit = Session.get('filter')?.limit ? 0
  limit = Session.get('messagesLimit')
  if 0 < filterLimit < limit
    limit = filterLimit

  Meteor.subscribe 'messages', limit, Session.get('filter')?.type, Session.get('filter')?.source

Template.panel.helpers(
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
    messagePanelBody = $('.message-panel .panel-body').eq(0)
    messagesTable = $('.messages-table').eq(0)
    if messagesTable.height() < messagePanelBody.scrollTop() + messagePanelBody.height()
      showMoreMessages()
)

showMoreMessages = ->
  if Session.get 'paused'
    return

  filterLimit = Session.get('filter')?.limit ? 0
  limit = Session.get('messagesLimit') + MESSAGES_INCREMENT
  if 0 < filterLimit < limit
    limit = filterLimit

  Session.set 'messagesLimit', limit