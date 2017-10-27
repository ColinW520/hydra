$(document).on 'turbolinks:load', ->
  $.rails.allowAction = (link) ->
    return true unless link.attr('data-confirm')
    $.rails.showConfirmDialog(link)
    false

  $.rails.confirmed = (link) ->
    link.removeAttr('data-confirm')
    link.trigger('click.rails')

  $.rails.showConfirmDialog = (link) ->
    message = link.attr 'data-confirm'
    html = """
      <div class="modal" id="confirmationDialog">
        <div class="modal-dialog" role="document">
          <div class="modal-content">
            <div class="modal-header">
              <h4 class="modal-title">
                <i class='fa fa-exclamation-triangle text-danger'></i>
                Warning
              </h4>
              <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                <span aria-hidden="true">&times;</span>
              </button>
            </div>
            <div class="modal-body">
              <p class="lead">#{message}</p>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn btn-secondary" data-dismiss="modal">Nevermind!</button>
              <button type="button" class="btn btn-danger confirm" data-dismiss="modal">Continue</button>
            </div>
          </div>
        </div>
      </div>
    """
    $(html).modal('show')
    $('#confirmationDialog .confirm').click (event) ->
      $.rails.confirmed(link)
