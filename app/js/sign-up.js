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
});
