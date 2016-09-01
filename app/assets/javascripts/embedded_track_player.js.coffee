#= require jquery
#= require jplayer/jquery.jplayer.js

$(document).ready ->
  mp3 = $(".jp-jplayer").data('mp3').toString()
  $("#jquery_jplayer_1").jPlayer({
    ready: () ->
      $(this).jPlayer("setMedia", {
        mp3: mp3
      })

    playing: (e) ->
      $('.jp-loading').hide()

    error: (event) ->
      console.log('jPlayer error: '+ event.jPlayer.error.type)

      $('jp-pause').hide()
      $('jp-loading').hide()

    waiting: (e) ->
      $('.jp-loading').show()
      $('.jp-play').hide()
      $('.jp-pause').hide()

    loadeddata: (e) ->
      $('.jp-loading').hide()

    cssSelectorAncestor: "#jp_container_1",
    swfPath: "/assets/flash/jplayer",
    supplied: "mp3",
    useStateClassSkin: true,
    autoBlur: false,
    smoothPlayBar: true,
    keyEnabled: true,
    remainingDuration: true,
    toggleDuration: true
  })
