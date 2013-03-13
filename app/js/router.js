app.Router = Backbone.Router.extend({
  routes: {
    "accounts/new": "newAccount",
    "*path": "defaultRoute"
  },

  initialize: function(){
    this.$container = $('.container');
  },

  defaultRoute: function(){
    this.navigate('accounts/new', {trigger: true});
  },

  newAccount: function(){
    new app.SignUpView({
      el: this.$container,
      model: new app.SignUp()
    }).render();
  }
});
