'use strict'

app.controller 'MainCtrl', ($scope, templates, Template) ->
  $scope.template = if templates.length > 0 then templates[0] else new Template name: 'template'

  $scope.save = ->
    $scope.template.$save()
