# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  if $('#contacts_show').length > 0
    console.log('seeing this')
    $.get
      url: "/messages?contact_id=" + gon.contact_id
      cache: false
      success: (html) ->
        $('#messages_placeholder').replaceWith html
        return
      error: (xhr, status, errorThrown) ->
        $('#messages_placeholder').replaceWith """<div class="alert alert-dismissible alert-danger"><button type="button" class="close" data-dismiss="alert">&times;</button><h4>Whoops!</h4><p>#{error}</p></div>"""
        return
