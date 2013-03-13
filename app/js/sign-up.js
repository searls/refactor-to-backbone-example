window.app = {};

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

app.SignUp = Backbone.Model.extend({
  urlRoot: "/accounts"
});

app.SignUpView = Backbone.View.extend({
  template: JST['app/templates/sign-up-form.us'],

  events: {
    "click button": "createAccount",
    "change input[name='login']": "checkAvailability",
    "change input[name='passwordConfirmation']": "confirmPassword"
  },

  render: function(){
    this.$el.html(this.template());
    return this;
  },

  createAccount: function(e){
    e.preventDefault();

    this.model.save({
      login: this.$("input[name='login']").val(),
      email: this.$("input[name='email']").val(),
      password: this.$("input[name='password']").val()
    });
  },

  checkAvailability: function(e){
    var requestedLogin = $(e.target).val();
    $.get('/account_availability/'+requestedLogin, function(response) {
      var message = response.available ? "Available!" : "That name's taken :-(";
      app.ViewHelpers.displayPopover(e.target, message);
    });
  },

  confirmPassword: function(e){
    var password = this.$('input[name="password"]').val(),
        passwordConfirmation = $(e.target).val();

    if(password !== passwordConfirmation) {
      app.ViewHelpers.displayPopover(e.target, "Uh oh! Double-check your password!");
    } else {
      app.ViewHelpers.clearPopover(e.target);
    }
  }
});

app.ViewHelpers = {
  displayPopover: function(el, message) {
    $(el).popover('destroy').popover({content: message}).popover('show');
  },

  clearPopover: function(el) {
    $(el).popover('destroy');
  }
};

jQuery(function($){
  window.router = new app.Router();
  Backbone.history.start();
});
