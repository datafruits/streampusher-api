show_ajax_message = (msg, type) ->
  $("#flash-message").html "<div class='flash' id='#{type}'>#{msg}</div>"
  $(".flash##{type}").delay(3000).slideUp 'slow'

$(document).ajaxComplete (event, request) ->
  msg = request.getResponseHeader("X-Message")
  type = request.getResponseHeader("X-Message-Type")
  if msg?
    show_ajax_message msg, type

