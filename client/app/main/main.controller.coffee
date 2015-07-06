'use strict'

app.controller 'MainCtrl', ($scope, templates, Template, $rootScope) ->
  $scope.template = if templates.length > 0 then templates[0] else new Template name: 'template'

  broadcast = (type) ->
    $rootScope.$broadcast 'notify', type, 'template.save.' + type

  $scope.save = ->
    $scope.savingTemplate = true
    $scope.template.$save()
    .then(->
      broadcast 'success'
    , -> broadcast 'failure')
    .then -> $scope.savingTemplate = false
