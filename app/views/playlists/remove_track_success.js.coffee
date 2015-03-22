$("ul.playlist-tracks li[data-track-id=<%=@track.id%>]").fadeOut 300, () ->
  $(this).remove()
