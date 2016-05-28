jQuery ->
  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()

  $("#flash-message .flash").delay(3000).slideUp('slow')
