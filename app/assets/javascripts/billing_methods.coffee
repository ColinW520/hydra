$ ->
  if $("#billing_placeholder").length > 0
    $.get
      url: gon.organization_id + '/billing_methods'
      cache: false
      success: (html) ->
        $('#billing_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#billing_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
