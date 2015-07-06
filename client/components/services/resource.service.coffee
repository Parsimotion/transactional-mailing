app.factory 'Resource', ($resource) ->
    (url, params, methods) ->
      defaults =
        update:
          method: 'PUT'
          isArray: false
        create: method: 'POST'
      methods = angular.extend(defaults, methods)
      resource = $resource(url, params, methods)

      resource::$save = ->
        if !@_id
          @$create()
        else
          @$update()

      resource