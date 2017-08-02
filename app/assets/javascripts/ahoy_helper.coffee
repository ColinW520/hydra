# $(document).on('turbolinks:load', =>
#   # These methods call document.on('event') and should not be called
#   # more than once per lifecycle of document.
#   unless window.ahoyDocumentEventTrackersInitialized
#     ahoy.trackClicks()
#     ahoy.trackSubmits()
#     window.ahoyDocumentEventTrackersInitialized = true
#
#   # Should be called once per page load.
#   ahoy.trackView()
# )
