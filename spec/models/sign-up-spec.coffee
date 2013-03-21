describe 'app.SignUp', ->
  Given -> @subject = new app.SignUp
  Then -> @subject.urlRoot == "/accounts"
