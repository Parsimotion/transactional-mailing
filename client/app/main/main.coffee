'use strict'

angular.module 'transactional-mailing-app'
.config ($stateProvider) ->
  $stateProvider
  .state 'main',
    url: '/'
    templateUrl: 'app/main/main.html'
    controller: 'MainCtrl'
    resolve:
      templates: (Template) -> Template.query().$promise
