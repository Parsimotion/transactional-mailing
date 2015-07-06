describe 'MainCtrl', ->
  scope = null
  httpBackend = null
  createController = null

  beforeEach ->
    inject ($rootScope, $controller, $httpBackend) ->
      scope = $rootScope.$new()
      httpBackend = $httpBackend
      createController = (templates) ->
        $controller 'MainCtrl',
          $scope: scope
          $httpBackend: httpBackend
          templates: templates

        scope.$apply()

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

      it 'should set the new id for the template', ->
        httpBackend.expectPOST('/api/templates', name: 'template').respond 200, _id: 'newId'
        httpBackend.flush()
        expect(scope.template._id).toBe 'newId'

      it 'should send a PUT to the API if save is called again', ->
        httpBackend.whenPOST('/api/templates', name: 'template').respond 200, {name: 'template', _id: 'newId'}
        httpBackend.flush()
        scope.save()
        httpBackend.expectPUT('/api/templates/newId', {name: 'template', _id: 'newId'}).respond 200
        httpBackend.flush()

  describe 'when the user has tempaltes', ->
    beforeEach ->
      createController [
        name: 'existingTemplate'
      ]

    it 'should bind the first template', ->
      expect(scope.template.name).toBe 'existingTemplate'

