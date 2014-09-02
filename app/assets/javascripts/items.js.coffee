# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# Toggle a range of checkboxes by clicking the first and shift-clicking the last.
cur = undefined
checkEvent = (e) ->
  if e.button is 0 or e.keyCode is 32 # clicked, or pressed SPACE
    
    # already have a starting point, and shift is pressed?
    selectRange cur, e.target  if cur and e.shiftKey
    cur = e.target
  return

selectRange = (from, to) ->
  checkboxes = $("input:checkbox")
  last = undefined
  i = undefined

  i = 0
  while i < checkboxes.length
    if checkboxes[i] is to
      last = from
      break
    if checkboxes[i] is from
      last = to
      break
    i++

  while i < checkboxes.length
    # from and to have been clicked by the user
    # state change?
    if checkboxes[i] isnt from and checkboxes[i] isnt to and checkboxes[i].checked isnt from.checked
      checkboxes[i].checked = not checkboxes[i].checked
    break if checkboxes[i] is last
    i++

  return

window.checkAll = (box) ->
  for checkbox in $(':checkbox')
    checkbox.checked = box.checked


$(document).ready ->
  $("input:checkbox").click checkEvent
  # if document.documentElement.addEventListener
  #   $("input:checkbox").click checkEvent
  #   # $("input:checkbox").keyup checkEvent
  # else if document.documentElement.attachEvent # IE
  #   $("input:checkbox").click checkEvent
  #   $("input:checkbox").keypress checkEvent
  # return

# reinit_selectrange = (id) ->
#   if document.documentElement.addEventListener
#     $("#" + id).click checkEvent
#     $("#" + id).keyup checkEvent
#   else if document.documentElement.attachEvent # IE
#     $("#" + id).click checkEvent
#     $("#" + id).keypress checkEvent
#   return