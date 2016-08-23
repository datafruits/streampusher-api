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
    listeners = 0
    $.each data.icestats.source, (key, data) ->
      listeners += data.listeners
      counter = new countUp('odometer', 0, listeners, 0, 2.5)
      counter.start()
    console.log('listeners: '+listeners)

$('[data-controller=radios][data-action=index]').ready ->
  console.log('radios controller')

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

  ctx = document.getElementById("listensChart").getContext("2d")
  options = {}
  $.get "/listens.json", (listens) ->
    data = {
      labels: _.keys(listens)
      datasets: [
          {
              label: "listens",
              fillColor: "rgba(220,220,220,0.2)",
              strokeColor: "rgba(220,220,220,1)",
              pointColor: "rgba(220,220,220,1)",
              pointStrokeColor: "#fff",
              pointHighlightFill: "#fff",
              pointHighlightStroke: "rgba(220,220,220,1)",
              data: _.values(listens)
          },
      ]

    }
    listensChart = new Chart(ctx).Line(data, options)
