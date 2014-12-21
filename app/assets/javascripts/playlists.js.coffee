# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$('[data-controller=playlists]').ready ->
  $('#track-uploader').S3Uploader
    allow_multiple_files: false
    remove_completed_progress_bar: false
    done: (e, data) ->
      console.log("done!")

  $('#track-uploader').on 's3_uploads_start', (e) ->
    console.log("Uploads have started")
    $("#status").html("uploading...")

  $('#track-uploader').on "ajax:success", (e, data) ->
    console.log("server was notified of new file on S3; responded with "+data)
    $("#status").html("complete!")

  $('#track-uploader').on  "ajax:error", (e, data) ->
    $("#status").html("error! :(")
    console.log("there was an error; responded with "+data)

  $('#tracks').sortable({
    revert: true
    connectWith: '.playlist-tracks'
  }).disableSelection()

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
