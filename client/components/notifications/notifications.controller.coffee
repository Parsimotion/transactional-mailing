'use strict'

seconds = (value) -> value * 1000

angular.module 'transactional-mailing-app'
.controller 'NotificationsCtrl', ($scope, $timeout) ->
  $scope.resetNotification = ->
    $scope.notification = {}

  $scope.resetNotification()

  $scope.$on 'notify', (_, type, message) ->
    $scope.notification =
      message: message
      type: type

    $timeout $scope.resetNotification, seconds 10
