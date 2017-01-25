# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#= require player

$(".jp-jplayer").ready ->
  new Player("#navbar_jp_container").start()

$('[data-controller=radios][data-action=index]').ready ->
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
