# Copy price of this item to all other items of the same template ID
window.copyprice = (item_id, item_template_id) ->
  price = $('#item_'+item_template_id+'_id_'+item_id+'_price').val()
  search = $('[id^=item_' + item_template_id + '_]')
  search.each (index) ->
    $(this).val(price)