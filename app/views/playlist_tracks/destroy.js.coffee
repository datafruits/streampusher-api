$("ul.playlist-tracks[data-playlist-id=<%=@playlist.id%>] li[data-playlist-track-id=<%=@playlist_track.id%>]").fadeOut 300, () ->
  $(this).remove()
