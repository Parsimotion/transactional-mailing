'use strict'

angular.module 'transactional-mailing-app'
.factory 'User', ($resource) ->
  $resource '/api/users/:id/:controller',
    id: '@_id'
  ,
    get:
      method: 'GET'
      params:
        id: 'me'

