window.app = {};

jQuery(function($){
  window.router = new app.Router();
  Backbone.history.start();
});
