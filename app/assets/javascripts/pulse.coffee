$ ->
  $('[data-toggle="tooltip"]').tooltip()
  $('[data-toggle="popover"]').popover()

  UnobtrusiveFlash.flashOptions['timeout'] = 5000

  $('#menu-toggle').click (e) ->
    e.preventDefault()
    $('#wrapper').toggleClass 'toggled'

  $('#selectAll').click ->
    if (this.checked)
      $(':checkbox').each ->
        $(this).prop('checked', true)
    else
      $(':checkbox').each ->
        $(this).prop('checked', false)

$(document).on 'ajax:error', 'form', (evt, xhr, status) ->
  $('div#error_holder').html '<ul id="errors"></ul>'
  errors = jQuery.parseJSON(xhr.responseText)
  for message of errors
    $('ul#errors').after '''<p style="padding-bottom: 10px; text-decoration: none;" class="text-danger"><i class="fa fa-exclamation-triangle text-danger" style="padding-right: 5px;"></i>''' + errors[message] + '</p><br />'
