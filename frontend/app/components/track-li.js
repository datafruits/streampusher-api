import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditing: false,
  actions: {
    addToPlaylist: function(){
      var store = this.get('store');
      var playlist = store.peekRecord('playlist', this.get('playlist_id'));
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist });
      playlistTrack.save();
    },
    editTrack: function(){
      this.set('isEditing', true);
    },
    save: function(){
      var track = this.get('track');
      track.save();
      this.set('isEditing', false);
    },
    cancel: function(){
      this.set('isEditing', false);
    }
  }
});
