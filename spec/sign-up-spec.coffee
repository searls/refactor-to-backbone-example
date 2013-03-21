describe "anonymous sign up code", ->
  describe "rendering the view", ->
    Given -> @$container = affix('.container')
    Given -> @html = "<div class='YAY'></div>"
    Given -> JST['app/templates/sign-up-form.us'] = jasmine.createSpy().andReturn(@html)
    When -> init()
    Then -> @$container.find('.YAY').length == 1
    And -> window.location.hash == "#accounts/new"

