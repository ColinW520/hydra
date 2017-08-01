$ ->
  if $("#users_placeholder").length > 0
    $.get
      url: '/users?organization_id=' + gon.organization_id
      cache: false
      success: (html) ->
        $('#users_placeholder').replaceWith html
        return
      error: (html) ->
        $('#users_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
