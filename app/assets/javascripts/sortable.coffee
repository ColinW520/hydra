$(document).on 'turbolinks:load', (event) ->
  if $('#sortable').length > 0
    # table_width = $('#sortable').width()
    # cells = $('.table').find('tr')[0].cells.length
    # desired_width = table_width / cells + 'px'
    # $('.table td').css('width', desired_width)

    $('#sortable').sortable(
      axis: 'y'
      items: '.item'
      cursor: 'move'
      sort: (e, ui) ->
        ui.item.addClass('active-item-shadow')
      stop: (e, ui) ->
        ui.item.removeClass('active-item-shadow')
      update: (e, ui) ->
        ui.item.toggle "highlight"
        ui.item.toggle "highlight"
        item_id = ui.item.data('item-id')
        position = ui.item.index() # this will not work with paginated items, as the index is zero on every page
        $.ajax(
          type: 'POST'
          url: '/' + ui.item.data('item-path') + '/update_row_order'
          dataType: 'json'
          data: { id: item_id, display_order_position: position }
        )
    )
