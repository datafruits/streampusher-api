function Player(cssSelectorAncestor){
  this.cssSelectorAncestor = cssSelectorAncestor;
  this.radioTitle = function() {
    var radioName, url;
    url = $(".jp-jplayer").data('icecast-json').toString();
    radioName = $(".jp-jplayer").data('radio-name').toString();
    return $.get(url, function(data) {
      var myRadios, title, artist;
      myRadios = data.icestats.source.filter((function(_this) {
	return function(s) {
	  return (s.server_name === (radioName + ".mp3") || s.server_name === (radioName + ".ogg"));
	};
      })(this));
      if(myRadios.length){
        title = myRadios[0].title;
        artist = myRadios[0].artist;
        if($("#odometer").length){
          var listeners = 0;
          var oldListeners = parseInt($("#odometer").text());
          console.log(oldListeners);
          var peak = 0;
          var oldPeak = parseInt($("#peak-odometer").text());
          $.each(myRadios, function(key, data){
            listeners += data.listeners;
            peak += data.listener_peak;
          });
          var counter = new CountUp('odometer', oldListeners, listeners, 0, 2.5);
          counter.start();
          var peakCounter = new CountUp('peak-odometer', oldPeak, peak, 0, 2.5);
          peakCounter.start();
        }
        jpTitle = "";
        if(artist){
          jpTitle = artist+" - "+title;
        }else{
          jpTitle = title;
        }
        return $('.jp-title').html(jpTitle);
      }
    });
  };

  this.start = function() {
    var mp3;
    var stream = {
      mp3: $(".jp-jplayer").data('mp3').toString()
    }

    var _this = this;
    $("#jquery_jplayer_1").jPlayer({
      ready: function() {
	return $(this).jPlayer("setMedia", stream);
      },
      playing: function(e) {
	return $('.jp-loading').hide();
      },
      pause: function(e) {
        //if (_this.get('playingPodcast') === false) {
          $(this).jPlayer("clearMedia");
          $(this).jPlayer("setMedia", stream);
        //}
      },
      error: function(event) {
	console.log('jPlayer error: ' + event.jPlayer.error.type);
	$('jp-pause').hide();
	return $('jp-loading').hide();
      },
      waiting: function(e) {
	$('.jp-loading').show();
	$('.jp-play').hide();
	return $('.jp-pause').hide();
      },
      loadeddata: function(e) {
	return $('.jp-loading').hide();
      },
      cssSelectorAncestor: this.cssSelectorAncestor,
      swfPath: "/assets/flash/jplayer",
      supplied: "mp3",
      useStateClassSkin: true,
      autoBlur: false,
      smoothPlayBar: true,
      keyEnabled: true,
      remainingDuration: true,
      toggleDuration: true
    });
    setTimeout(function() {
      return _this.radioTitle();
    }, 500);

    setInterval(function() {
      return _this.radioTitle();
    }, 1000);
  };
};
