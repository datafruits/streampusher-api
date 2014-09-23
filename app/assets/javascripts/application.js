// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require countUp.js
//= require d3
//= require nvd3
//= require moment
//= require fullcalendar/fullcalendar.js
//= require_tree .

var data = function() {
  var sin = [],
      cos = [];

  for (var i = 0; i < 100; i++) {
    sin.push({x: i, y: Math.sin(i/10)});
    cos.push({x: i, y: .5 * Math.cos(i/10)});
  }

  return [
    {
      values: sin,
      key: 'Sine Wave',
      color: '#ff7f0e'
    },
    {
      values: cos,
      key: 'Cosine Wave',
      color: '#2ca02c'
    }
  ];
}


$(document).ready(function(){
  var counter = new countUp('odometer', 0, 128, 0, 2.5);
  counter.start();

  nv.addGraph(function() {
    var chart = nv.models.lineChart()
      .useInteractiveGuideline(true)
      ;

    chart.xAxis
      .axisLabel('Time (ms)')
      .tickFormat(d3.format(',r'))
      ;

    chart.yAxis
      .axisLabel('Voltage (v)')
      .tickFormat(d3.format('.02f'))
      ;

    d3.select('#chart svg')
      .datum(data())
      .transition().duration(500)
      .call(chart)
      ;

    nv.utils.windowResize(chart.update);

    return chart;
  });

});
