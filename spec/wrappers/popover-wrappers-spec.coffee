describe 'app.PopoverWrapper', ->
  Given -> @subject = app.PopoverWrapper

  describe ".displayPopover", ->
    Given -> @$div = affix('div')
    When -> @subject.display(@$div[0], "ahoy!")
    And -> @$result = @$div.next()
    Then -> @$result.text() == "ahoy!"
    And -> @$result.is(':visible')

  describe ".clearPopover", ->
    Given -> @$div = affix('[data-animation="false"]')
    Given -> @$div.popover(content: 'foo').popover('show')
    When -> @subject.clear(@$div[0])
    Then -> $('.popover').length == 0

