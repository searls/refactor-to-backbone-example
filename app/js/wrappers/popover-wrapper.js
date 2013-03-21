app.ViewHelpers = {
  displayPopover: function(el, message) {
    $(el).popover('destroy').popover({content: message}).popover('show');
  },

  clearPopover: function(el) {
    $(el).popover('destroy');
  }
};
