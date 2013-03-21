describe 'app.SignUpView', ->
  Given -> @subject = new app.SignUpView

  Then -> expect(@subject.events).toEqual
    "click button": "createAccount",
    "change input[name='login']": "checkAvailability",
    "change input[name='passwordConfirmation']": "confirmPassword"

  describe "#render", ->
    Given -> spyOn(JST, 'app/templates/sign-up-form.us').andReturn(-> '<div id="woot"/>')
    When -> @subject.render()
    Then -> @subject.$('#woot').length == 1
