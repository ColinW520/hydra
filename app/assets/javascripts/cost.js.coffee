$ ->
  return unless $("#CostPanel").length > 0
  $.get
    url: '/dashboard/usage'
    cache: false
    success: (html) ->
      $('#CostPanel').replaceWith html
      return
    error: (xhr, status, errorThrown) ->
      $('#CostPanel').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
      return
