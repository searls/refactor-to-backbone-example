describe "anonymous sign up code", ->
  describe "rendering the view", ->
    Given -> @$container = affix('.container')
    Given -> @html = "<div class='YAY'></div>"
    Given -> JST['app/templates/sign-up-form.us'] = jasmine.createSpy().andReturn(@html)
    When -> init()
    Then -> @$container.find('.YAY').length == 1
    And -> window.location.hash == "#accounts/new"

    describe "user events", ->
      describe "submitting the form", ->
        Given -> @$button = affix('.create-account').affix('button')
        Given -> @event = fakeEvent("click")
        Given -> spyOn($, 'post')
        Given -> stubFor($.fn, 'serialize').whenContext(argThat((o) -> o.selector == '.create-account form')).thenReturn("form!")
        When -> @$button.trigger(@event)
        Then -> expect(@event.preventDefault).toHaveBeenCalled()
        And -> expect($.post).toHaveBeenCalledWith('/accounts', 'form!')

