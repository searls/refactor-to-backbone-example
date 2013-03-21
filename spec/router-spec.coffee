describe 'app.Router', ->
  Given -> @$container = affix('.container')
  Given -> @subject = new app.Router

  Then -> expect(@subject.routes).toEqual
    "accounts/new": "newAccount"
    "*path": "defaultRoute"

  describe "#defaultRoute", ->
    When -> @subject.defaultRoute()
    Then -> window.location.hash == "#accounts/new"

  describe "#newAccount", ->
    Given -> @signUpView = spyOnConstructor(app, 'SignUpView', ['render'])
    When -> @subject.newAccount()
    Then -> expect(@signUpView.constructor).toHaveBeenCalledWith
      el: @$container[0]
      model: any(app.SignUp)
    Then -> expect(@signUpView.render).toHaveBeenCalled()

