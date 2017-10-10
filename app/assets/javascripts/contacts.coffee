$ ->
  if $("#contacts_placeholder").length > 0
    $.get
      url: '/contacts?id=' + gon.contact_ids
      cache: false
      success: (html) ->
        $('#contacts_placeholder').replaceWith html
        return
      error: (html) ->
        $('#contacts_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
