$(document).on 'turbolinks:load', (event) ->
  if $("#feed_items_placeholder").length > 0
    $.get
      url: '/activities'
      cache: false
      success: (html) ->
        $('#feed_items_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#feed_items_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
