Template.registerHelper 'messageTypeClass', (type) ->
  typeMap = {
    error: 'danger'
    warning: 'warning'
    info: 'info'
    verbose: 'success'
  }
  typeMap[type] || ''