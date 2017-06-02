# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('[data-controller=stats][data-action=index]').ready ->
  new Calendar({
    element: $('.daterange--double'),
    earliest_date: '2000-01-1',
    latest_date: moment(),
    start_date: '2015-05-01',
    end_date: '2015-05-31',
    callback: () =>
      start = moment(this.start_date).format('ll')
      end = moment(this.end_date).format('ll')

      console.debug('Start Date: '+ start +'\nEnd Date: '+ end)
  })

