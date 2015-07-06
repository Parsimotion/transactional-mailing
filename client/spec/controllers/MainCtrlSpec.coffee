describe 'MainCtrl', ->
  scope = null
  httpBackend = null
  createController = null
  rootScope = null

  beforeEach ->
    inject ($rootScope, $controller, $httpBackend) ->
      rootScope = $rootScope
      scope = rootScope.$new()
      httpBackend = $httpBackend
      createController = (templates) ->
        $controller 'MainCtrl',
          $scope: scope
          $httpBackend: httpBackend
          templates: templates

        scope.$apply()
        spyOn rootScope, "$broadcast"

  describe 'when the user has no tempaltes', ->
    beforeEach ->
      createController []

    it 'should bind a new template in scope with the default name', ->
      expect(scope.template.name).toBe 'template'

    describe 'and save is called', ->
      beforeEach ->
        scope.save()

      it 'should send a POST to the API', ->
        httpBackend.expectPOST('/api/templates', name: 'template').respond 200, _id: 'newId'
        httpBackend.flush()

      describe 'and POST succeeds', ->
        beforeEach ->
          httpBackend.whenPOST('/api/templates', name: 'template').respond 200, {name: 'template', _id: 'newId'}
          httpBackend.flush()

        it 'should set the new id for the template', ->
          expect(scope.template._id).toBe 'newId'

        it 'should broadcast success message if POST succeeded', ->
          expect(rootScope.$broadcast).toHaveBeenCalledWith 'notify', 'success', 'template.save.success'

        it 'should send a PUT to the API if save is called again', ->
          scope.save()
          httpBackend.expectPUT('/api/templates/newId', {name: 'template', _id: 'newId'}).respond 200
          httpBackend.flush()

      it 'should broadcast failure message if POST fails', ->
        httpBackend.whenPOST('/api/templates', name: 'template').respond 500
        httpBackend.flush()
        expect(rootScope.$broadcast).toHaveBeenCalledWith 'notify', 'failure', 'template.save.failure'

  describe 'when the user has tempaltes', ->
    beforeEach ->
      createController [
        name: 'existingTemplate'
      ]

    it 'should bind the first template', ->
      expect(scope.template.name).toBe 'existingTemplate'

