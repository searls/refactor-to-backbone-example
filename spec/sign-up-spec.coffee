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

      Given -> spyOn($.fn, 'popover').andReturn(popover: $.fn.popover)
      describe "changing the login field", ->
        Given -> @$login = affix('.create-account').affix('input[name="login"][value="fun!"]')
        Given -> @event = fakeEvent('change')
        Given -> spyOn($, 'get')
        Given -> @ajaxCallback = jasmine.captor()
        When -> @$login.trigger(@event)
        And -> expect($.get).toHaveBeenCalledWith('/account_availability/fun!', @ajaxCallback.capture())
        And -> @ajaxCallback.value(available: @available)

        context "~ the name is available", ->
          Given -> @available = true
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> expect($.fn.popover).toHaveBeenCalledWith(content: "Available!")
          And -> expect($.fn.popover).toHaveBeenCalledWith("show")

        context "~ the name is available", ->
          Given -> @available = false
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> expect($.fn.popover).toHaveBeenCalledWith(content: "That name's taken :-(")
          And -> expect($.fn.popover).toHaveBeenCalledWith("show")

      describe "confirming the password", ->
        Given -> @$view = affix('.create-account')
        Given -> @$password = @$view.affix('input[name="password"][value="foo"]')
        Given -> @$passwordConfirmation = @$view.affix('input[name="passwordConfirmation"][value="foo"]')
        Given -> @event = fakeEvent('change')

        When -> @$passwordConfirmation.trigger(@event)

        context "matching passwords", ->
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> $.fn.popover.callCount == 1

        context "mismatching passwords", ->
          Given -> @$passwordConfirmation.val("bar")
          Then -> expect($.fn.popover).toHaveBeenCalledWith('destroy')
          And -> expect($.fn.popover).toHaveBeenCalledWith(content: "Uh oh! Double-check your password!")
          And -> expect($.fn.popover).toHaveBeenCalledWith("show")
