$ ->
  UnobtrusiveFlash.flashOptions['timeout'] = 2000
  console.log(gon)
  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'

  $('a[disabled=disabled]').click (event) ->
    event.preventDefault()
