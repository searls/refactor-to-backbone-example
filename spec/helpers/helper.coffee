root = this

root.context = root.describe
root.xcontext = root.xdescribe

root.fakeEvent = (type = 'click') ->
  _(new jQuery.Event(type)).extend
    preventDefault: jasmine.createSpy('#preventDefault')
