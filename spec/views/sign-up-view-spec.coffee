describe 'app.SignUpView', ->
  Given -> @model = {}
  Given -> @subject = new app.SignUpView(model: @model)

  Then -> expect(@subject.events).toEqual
    "click button": "createAccount",
    "change input[name='login']": "checkAvailability",
    "change input[name='passwordConfirmation']": "confirmPassword"

  describe "#render", ->
    Given -> spyOn(JST, 'app/templates/sign-up-form.us').andReturn(-> '<div id="woot"/>')
    When -> @subject.render()
    Then -> @subject.$('#woot').length == 1

  describe "#createAccount", ->
    Given -> @subject.$el.affix('input[name="login"]').val('joe')
    Given -> @subject.$el.affix('input[name="email"]').val('joe@joe.com')
    Given -> @subject.$el.affix('input[name="password"]').val('notreallyjoe')
    Given -> @model.save = jasmine.createSpy('save')
    Given -> @event = fakeEvent()
    When -> @subject.createAccount(@event)
    Then -> expect(@event.preventDefault).toHaveBeenCalled()
    Then -> expect(@model.save).toHaveBeenCalledWith
      login: "joe"
      email: "joe@joe.com"
      password: "notreallyjoe"


  Given -> spyOn(app.PopoverWrapper, 'display')
  describe "#checkAvailability", ->
    Given -> @$login = @subject.$el.affix('input[name="login"][value="fun!"]')
    Given -> @event = fakeEvent('change', @$login[0])
    Given -> spyOn($, 'get')
    Given -> @ajaxCallback = jasmine.captor()
    When -> @subject.checkAvailability(@event)
    And -> expect($.get).toHaveBeenCalledWith('/account_availability/fun!', @ajaxCallback.capture())
    And -> @ajaxCallback.value(available: @available)

    context "~ the name is available", ->
      Given -> @available = true
      Then -> expect(app.PopoverWrapper.display).toHaveBeenCalledWith(@$login[0], "Available!")

    context "~ the name is NOT available", ->
      Given -> @available = false
      Then -> expect(app.PopoverWrapper.display).toHaveBeenCalledWith(@$login[0], "That name's taken :-(")

  describe "#confirmPassword", ->
    Given -> @$password = @subject.$el.affix('input[name="password"][value="foo"]')
    Given -> @$passwordConfirmation = @subject.$el.affix('input[name="passwordConfirmation"][value="foo"]')
    Given -> @event = fakeEvent('change', @$passwordConfirmation[0])
    When -> @subject.confirmPassword(@event)

    context "matching passwords", ->
      Given -> spyOn(app.PopoverWrapper, 'clear')
      Then -> expect(app.PopoverWrapper.clear).toHaveBeenCalledWith(@$passwordConfirmation[0])

    context "mismatching passwords", ->
      Given -> @$passwordConfirmation.val("bar")
      Then -> expect(app.PopoverWrapper.display).toHaveBeenCalledWith(@$passwordConfirmation[0], "Uh oh! Double-check your password!")


