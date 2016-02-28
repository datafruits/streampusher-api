import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  actions: {
    addToPlaylist: function(){
      var store = this.get('store');
      var playlist = store.peekRecord('playlist', this.get('playlist_id'));
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist });
      playlistTrack.save();
    },
  }
});
