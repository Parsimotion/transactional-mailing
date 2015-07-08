request = require('request')
azure = require('azure')

websiteName = 'transactional-mailing' + if process.env.NODE_ENV is 'production' then '' else "-#{process.env.NODE_ENV}"
notificationsUrl = process.env.NOTIFICATIONS_URL or "http://#{websiteName}.azurewebsites.net/api/hooks/webjob"
connectionString = process.env.SERVICEBUS_CONNECTIONSTRING
topic = 'salesorder'
subscription = 'transactional-mailing'

class ServiceBusReceiver
  constructor: (connectionString, @topic, @subscription) ->
    @serviceBusService = azure.createServiceBusService connectionString

  run: =>
    @_createSubscription (error) =>
      if !error
        console.log 'subscription created'
        @_createRule()
      @_receive()

  _createSubscription: (callback) =>
    @serviceBusService.createSubscription @topic, @subscription, callback

  _receive: =>
    @serviceBusService.receiveSubscriptionMessage @topic, @subscription, { isPeekLock: true }, (error, lockedMessage) =>
      if !error
        console.log 'receiving message...'
        # Message received and locked
        request.post @_buildRequest(lockedMessage), (err, result) =>
          if err or result and result.statusCode != 200 and result.statusCode != 409
            console.log "error processing message: #{err or result.body}"
            return @serviceBusService.unlockMessage lockedMessage, ->

          @serviceBusService.deleteMessage lockedMessage, (deleteError) ->
            if deleteError
              console.log "error deleting message: #{deleteError}"
            else
              console.log 'message processed OK'
        @_receive()

      else
        @_receive()

  _buildRequest: (message) ->
    body = JSON.parse message.body.substring message.body.indexOf '{'
    url: notificationsUrl
    headers: signature: process.env.WEBJOB_SIGNATURE or 'a signature for webjobs'
    body:
      companyId: body.CompanyId
      salesOrderId: body.ResourceId
    json: true


  _createRule: =>
    ruleOptions = sqlExpressionFilter: 'created = True'
    @_deleteDefault()
    console.log 'default filter removed'
    @serviceBusService.createRule 'salesorder', 'transactional-mailing', 'created', ruleOptions, @_handleError
    console.log 'custom filter created'

  _deleteDefault: =>
    @serviceBusService.deleteRule @topic, @subscription, azure.Constants.ServiceBusConstants.DEFAULT_RULE_NAME, @_handleError

  _handleError: (error) ->
    if error
      console.log error

new ServiceBusReceiver(connectionString, topic, subscription).run()
