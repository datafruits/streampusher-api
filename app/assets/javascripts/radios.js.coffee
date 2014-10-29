# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#
$('#main-dashboard').ready ->

  counter = new countUp('odometer', 0, 128, 0, 2.5)
  counter.start()

  $('#calendar').fullCalendar({})
