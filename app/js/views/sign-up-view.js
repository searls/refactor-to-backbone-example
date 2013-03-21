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
      app.PopoverWrapper.display(e.target, message);
    });
  },

  confirmPassword: function(e){
    var password = this.$('input[name="password"]').val(),
        passwordConfirmation = $(e.target).val();

    if(password !== passwordConfirmation) {
      app.PopoverWrapper.display(e.target, "Uh oh! Double-check your password!");
    } else {
      app.PopoverWrapper.clear(e.target);
    }
  }
});
