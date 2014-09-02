# Floating toolbar nav
# Much <3 to Eyes

# window.toolbar_offset = undefined

scrollFunction = ->
  pos = $(document).scrollTop()
  pos = $('body').scrollTop() if pos is 0
  # console.log('Scroll Position : ' + pos)
  # console.log('Toolbar Offset  : ' + $('#toolbar').offset().top)
  if window.toolbar_offset <= pos
    if typeof($('#toolbar').attr("style")) == 'undefined'
      $('#toolbar').attr "style", "z-index: 1; position: fixed; top: 0px; background:white; width:" + $('#items').width() + ";"
  else
    if typeof($('#toolbar').attr("style")) != 'undefined'
      $('#toolbar').attr "style", null

window.setToolbarOffset = ->
  window.toolbar_offset = $('#toolbar').offset().top

$(document).ready ->
  if $('#toolbar').size() > 0
    # console.log('toolbar: ' + $('#toolbar')
    # console.log('Toolbar Offset : ' + toolbar_offset)
    window.onscroll = scrollFunction
    setToolbarOffset()
    # 250 is milliseconds
    $(window).resize( $.throttle( 250, setToolbarOffset ) )



