$("ul.playlist-tracks[data-playlist-id=<%=@playlist.id%>] li[data-track-id=<%=@track.id%>]").fadeOut 300, () ->
  $(this).remove()
