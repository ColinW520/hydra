$(document).on 'turbolinks:load', (event) ->
  if $("#ThisMonth").length > 0
    $.get
      url: '/dashboard/usage?time_frame=this_month'
      cache: false
      success: (html) ->
        $('#ThisMonth').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#ThisMonth').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
  if $("#LastMonth").length > 0
    $.get
      url: '/dashboard/usage?time_frame=last_month'
      cache: false
      success: (html) ->
        $('#LastMonth').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#LastMonth').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
