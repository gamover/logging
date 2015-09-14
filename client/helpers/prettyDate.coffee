Template.registerHelper 'prettyDate', (date) ->
  moment(date).format 'DD.MM.YYYY HH:mm:ss'