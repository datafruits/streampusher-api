# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require player

$(".jp-jplayer").ready ->
  new Player("#navbar_jp_container").start()

$('[data-controller=radios][data-action=index]').ready ->
  # Instance the tour
  tour = new Tour({
    steps: [{
      title: "Welcome to Streampusher",
      content: "Mind if we show you around a bit?",
      orphan: true
    },
    {
      element: "#media-link",
      title: "Upload audio files and Manage Playlists",
      content: "Upload audio files to play on your radio right now"
    },
    {
      element: "#schedule-link",
      title: "Schedule broadcasts",
      content: "Schedule events and programmed playlists"
    },
    {
      element: "#djs-link",
      title: "Add djs",
      content: "Add DJ users so other people can stream on your station",
    },
    {
      element: "#broadcasting-help",
      title: "Broadcast Live Guide",
      content: "Learn how to broadcast audio live from your computer here"
      autoscroll: false,
      onShow: () ->
        $("li.dropdown").addClass('forcedopen')
      onHide: () ->
        $("li.dropdown").removeClass('forcedopen')
    },
    {
      element: ".live",
      title: "Broadcasting Info",
      content: "You can view the connection info at any time here"
    },
    {
      title: "Ask for help anytime!",
      content: "If you need help just send us a message! We will respond ASAP. Just click on the 'Contact us' box in the bottom right corner!",
      orphan: true
    },
    {
      element: ".start-tour",
      title: "View tour again",
      content: "You can view the tour again anytime by clicking here",
      autoscroll: false,
      onShow: () ->
        $("li.dropdown").addClass('forcedopen')
      onHide: () ->
        $("li.dropdown").removeClass('forcedopen')
    }],
    backdrop: true,
    backdropContainer: '.side-navbar',
    backdropPadding: 0
  })

  # Initialize the tour
  tour.init()

  # Start the tour
  tour.start()

  $(".start-tour").click (e) ->
    tour.restart()
    e.preventDefault()

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
    listensChart = new Chart(ctx, { type: 'line', data: data, options: options })
