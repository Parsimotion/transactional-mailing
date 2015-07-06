'use strict'

app.controller 'MainCtrl', ($scope, templates, Template, $rootScope) ->
  $scope.template = if templates.length > 0 then templates[0] else new Template name: 'template'

  $scope.save = ->
    $scope.savingTemplate = true
    $scope.template.$save()
    .then(->
      $rootScope.$broadcast "notify", 'success', 'template.saved'
    , -> $rootScope.$broadcast "notify", 'failure', 'template.save.error')
    .then -> $scope.savingTemplate = false
