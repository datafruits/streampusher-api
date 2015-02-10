# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
radioTitle = () ->
  url = $(".jp-jplayer").data('icecast-json').toString()
  console.log(url)

  $.get url, (data) ->
    title = data.icestats.source[0].title
    console.log(title)
    $('.jp-title').html(title)

$('[data-controller=radios]').ready ->
  console.log('radios controller')

  #counter = new countUp('odometer', 0, 128, 0, 2.5)
  #counter.start()
  mp3 = $(".jp-jplayer").data('mp3').toString()
  $("#jquery_jplayer_1").jPlayer({
    ready: () ->
      $(this).jPlayer("setMedia", {
        mp3: mp3
      })
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

  setTimeout () ->
    radioTitle()
  , 500

  setInterval () ->
    radioTitle()
  , 10000

