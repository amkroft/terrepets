# Functions for the Trading Post

# Show items on button click
window.showItems = (e) ->
  $("#show_items").hide();
  table = $("#trade_items");
  table.css('display', 'table');
  return false;

$(document).ready ->
  $("#show_items").click showItems