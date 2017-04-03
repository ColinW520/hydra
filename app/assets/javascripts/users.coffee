$ ->
  return unless $("#users_placeholder").length > 0
  $.get
    url: '/users?organization_id=' + gon.organization_id
    cache: false
    success: (html) ->
      $('#users_placeholder').replaceWith html
      return
    error: (html) ->
      $('#users_placeholder').replaceWith '<div class="alert alert-dismissible alert-warning"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>Well, there was some trouble when we tried to load these users. Sorry! Try again later, or, contact the sys admin.</p></div>'
      return
