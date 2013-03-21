root = this;

root.context = root.describe
root.xcontext = root.xdescribe

root.fakeEvent = (type) ->
  _(jQuery.Event(type)).extend
    preventDefault: jasmine.createSpy('preventDefault')

root.argThat = jasmine.argThat
root.any = jasmine.any
