@Logs = new Meteor.Collection 'logs'

if Meteor.isServer
  Logs._ensureIndex type: 1
  Logs._ensureIndex source: 1
  Logs._ensureIndex message: 1
  Logs._ensureIndex date: 1