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

      describe "changing the login field", ->
        Given -> @$login = affix('.create-account').affix('input[name="login"][value="fun!"]')
        Given -> @event = fakeEvent('change')
        Given -> spyOn($, 'get')
        Given -> @ajaxCallback = jasmine.captor()
        When -> @$login.trigger(@event)
        And -> expect($.get).toHaveBeenCalledWith('/account_availability/fun!', @ajaxCallback.capture())

        Given -> spyOn($.fn, 'popover').andReturn(popover: $.fn.popover)
        context "~ the name is available", ->
          When -> @ajaxCallback.value(available: true)
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> expect($.fn.popover).toHaveBeenCalledWith(content: "Available!")
          And -> expect($.fn.popover).toHaveBeenCalledWith("show")

        context "~ the name is available", ->
          When -> @ajaxCallback.value(available: false)
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> expect($.fn.popover).toHaveBeenCalledWith(content: "That name's taken :-(")
          And -> expect($.fn.popover).toHaveBeenCalledWith("show")
