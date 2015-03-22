$("ul#playlists").append("<%= j render @playlist %>");
$('.playlist-tracks').sortable({
  revert: true
  receive: (event, ui) ->
    playlistId = $(this).data('playlistId')
    trackId = ui.item.data('trackId')
    console.log("recevied track #{trackId} on playlist #{playlistId}")
    $.ajax
      type: 'POST'
      url: "/playlists/#{playlistId}/add_track"
      data:
        track:
          id: trackId
      success: (data) ->
        console.log(data)
      error: (data) ->
        console.log(data)
}).disableSelection()
