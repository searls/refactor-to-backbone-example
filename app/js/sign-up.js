jQuery(function($){
  // Render the view
  var template = JST['app/templates/sign-up-form.us'];
  $('.container').append(template());

  // Update the URL
  window.location.hash = "accounts/new";

  // Bind the events
  $('.create-account button').on('click', function(e){
    e.preventDefault();
    $.post('/accounts', $('.create-account form').serialize());
  });

  //Handle account availability
  $('.create-account input[name="login"]').on('change', function(e){
    e.preventDefault();
    requestedLogin = $(e.target).val();
    $.get('/account_availability/'+requestedLogin, function(response) {
      var message = response.available ? "Available!" : "That name's taken :-(";
      $(e.target).popover('destroy').popover({content: message}).popover('show');
    });
  });
});
