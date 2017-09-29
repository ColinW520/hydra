$ ->
  $('nav ul li a[href^=\'#\']').on 'click', (e) ->
    e.preventDefault()
    # store hash
    hash = @hash
    # animate
    $('html, body').animate { scrollTop: $(hash).offset().top }, 700, ->
      # when done, add hash to url
      # (default click behaviour)
      window.location.hash = hash
      return
    return
