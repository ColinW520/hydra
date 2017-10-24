$.onmount '#message_request_dialog', ->
  $(this).on 'show.bs.modal', (e) ->
    $rate = 0.0075
    $('.file').on 'change', '#message_request_media_item', ->
      if $(this).get(0).files.length > 0
        $rate = 0.02
        $('textarea').keyup()
      else
        $rate = 0.0075
        $('textarea').keyup()

    $('#warning.alert.alert-danger').eq(1).hide()
    $('textarea').on 'keyup', ->
      length = $(this).val().length
      if length < 140
        $('#counter.pull-right').eq(1).html "<p class='text-success'>Charachters: " + length + "</p>"
        $('#warning.alert.alert-danger').eq(1).hide()
        estimate_value = $('div#estimate').eq(1).data("original") * 1 * $rate
        $('div#estimate').eq(1).html "<p class='lead text-success'>$" + estimate_value + "</p>"
      if length > 140 && length < 280
        $('#counter.pull-right').eq(1).html "<p class='text-warning'>Charachters: " + length + "</p>"
        $('#warning.alert.alert-danger').eq(1).hide()
        estimate_value = $('div#estimate').eq(1).data("original") * 2 * $rate
        $('div#estimate').eq(1).html "<p class='lead text-danger'>$" + estimate_value + "</p>"
      if length > 280 && length < 420
        $('#counter.pull-right').eq(1).html "<p class='text-danger'>Charachters: " + length + "</h3>"
        $('#warning.alert.alert-danger').eq(1).show()
        estimate_value = $('div#estimate').eq(1).data("original") * 3 * $rate
        $('div#estimate').eq(1).html "<p class='lead text-danger'>$" + estimate_value + "</p>"
      if length > 420
        estimate_value = $('div#estimate').eq(1).data("original") * 4 * $rate
        $('div#estimate').eq(1).html "<p class='lead text-danger'> >$" + estimate_value + "</p>"
