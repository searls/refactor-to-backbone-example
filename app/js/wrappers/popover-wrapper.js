app.PopoverWrapper = {
  display: function(el, message) {
    $(el).popover('destroy').popover({content: message}).popover('show');
  },

  clear: function(el) {
    $(el).popover('destroy');
  }
};
