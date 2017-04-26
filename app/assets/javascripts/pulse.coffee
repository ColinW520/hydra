$ ->
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()
  UnobtrusiveFlash.flashOptions['timeout'] = 5000

  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'

  $('a[disabled=disabled]').click (event) ->
    event.preventDefault()


$(document).on 'ajax:error', 'form', (e, data, xhr) ->
  console.log data.responseText
  errors = data.responseText
  for message of errors
    $('ul#errors').append '<li>' + errors[message] + '</li>'
