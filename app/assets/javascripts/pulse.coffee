# this is the global, catch-all JS file for TmT it is used for attaching
# event listeners to commonly used elements, like tooltips, filter-forms, select-all boxes, etc

UnobtrusiveFlash.flashOptions['timeout'] = 5000

# we use onMount to keep things from being bound multiple times.
# turbolinks:load doesn't fire after AJAX page manipulations, so we also listen for ajax complete
# in case a form element was changed, which is frequently the case.

$(document).on 'turbolinks:load ajaxComplete', ->
  $.onmount()

$.onmount '.smart-listing-controls input', ->
  $(this).change (e) ->
    e.preventDefault()
    $(this).closest('form').submit()

$.onmount '.smart-listing-controls select', ->
  $(this).change (e) ->
    e.preventDefault()
    $(this).closest('form').submit()

$.onmount '.select2', ->
  $('.select2').select2(
    multiple: true
    allowClear: true
    tags: true
    placeholder: ''
  ).on('select2:unselecting', ->
      $(this).data 'unselecting', true
  ).on 'select2:opening', (e) ->
    if $(this).data('unselecting')
      $(this).removeData 'unselecting'
      e.preventDefault()

$.onmount '[data-toggle="tooltip"]', ->
  $(this).tooltip()

$.onmount '#selectAll', ->
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
