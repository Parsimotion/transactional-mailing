beforeEach ->
  module "transactional-mailing-app"
  inject ($httpBackend) ->
    $httpBackend.whenGET(/api/language\?lang=/).respond()
