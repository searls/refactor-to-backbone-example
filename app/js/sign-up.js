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
    new app.SignUpView({el: this.$container}).render();
  }
});

app.SignUpView = Backbone.View.extend({
  template: JST['app/templates/sign-up-form.us'],

  render: function(){
    this.$el.html(this.template());
    return this;
  }
});


jQuery(function($){
  window.router = new app.Router();
  Backbone.history.start();

  // Bind the events
  $('.create-account button').on('click', function(e){
    e.preventDefault();
    $.post('/accounts', $('.create-account form').serialize());
  });

  //Handle account availability
  $('.create-account input[name="login"]').on('change', function(e){
    requestedLogin = $(e.target).val();
    $.get('/account_availability/'+requestedLogin, function(response) {
      var message = response.available ? "Available!" : "That name's taken :-(";
      displayPopover(e.target, message);
    });
  });

  //Handle password confirmation
  $('.create-account input[name="passwordConfirmation"]').on('change', function(e){
    var password = $('.create-account input[name="password"]').val(),
        passwordConfirmation = $(e.target).val();

    if(password !== passwordConfirmation) {
      displayPopover(e.target, "Uh oh! Double-check your password!");
    } else {
      clearPopover(e.target);
    }
  });

  var displayPopover = function(el, message) {
    $(el).popover('destroy').popover({content: message}).popover('show');
  };

  var clearPopover = function(el) {
    $(el).popover('destroy');
  };

});
