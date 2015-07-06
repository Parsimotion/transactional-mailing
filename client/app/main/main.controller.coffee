'use strict'

app.controller 'MainCtrl', ($scope, templates, Template, OrderSample, $rootScope, $modal) ->
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

  $scope.test = ->
    Template.test(template: $scope.template, sample: OrderSample).$promise.then (test) ->
      $modal.open
        templateUrl: 'components/mailtest/mailtest.html'
        controller: ($scope, $modalInstance, $sce, compiled) ->
          $scope.subject = $sce.trustAsHtml(compiled.subject)
          $scope.body = $sce.trustAsHtml(compiled.body)
          $scope.close = -> $modalInstance.close()
        resolve: compiled: -> test
