import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  actions: {
    addToPlaylist: function(){
      var store = this.get('store');
      var playlist_id = this.get('playlist_id');
      var track_id = this.get('track').id;
      var playlistTrack = store.createRecord('playlist_track', { track_id: track_id, playlist_id: playlist_id });
      playlistTrack.save();
    },
  }
});
