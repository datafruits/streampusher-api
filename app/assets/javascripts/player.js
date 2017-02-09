
function Player(cssSelectorAncestor){
  this.cssSelectorAncestor = cssSelectorAncestor;
  this.radioTitle = function() {
    var radioName, url;
    url = $(".jp-jplayer").data('icecast-json').toString();
    radioName = $(".jp-jplayer").data('radio-name').toString();
    return $.get(url, function(data) {
      var myRadio, title;
      myRadio = data.icestats.source.find((function(_this) {
	return function(s) {
	  return s.server_name === (radioName + ".mp3");
	};
      })(this));
      if(myRadio){
        title = myRadio.title;
        if($("#odometer").length){
          var listeners = 0;
          $.each(data.icestats.source, function(key, data){
            listeners += data.listeners;
          });
          var counter = new countUp('odometer', 0, listeners, 0, 2.5);
          counter.start();
          console.log('listeners: '+listeners);
        }
        return $('.jp-title').html(title);
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
    }, 10000);
  };


};
