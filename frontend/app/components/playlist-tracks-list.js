import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  //isEditing: false,
  actions: {
    editPlaylist: function(){
      //this.toggleProperty('isEditing');
      $("#edit-playlist-modal").modal("toggle");
    },
    selectInterpolatedPlaylistId: function(playlistId) {
      this.set('interpolatedPlaylistId', playlistId);
    },
    save: function() {
      var store = this.get('store');
      var playlist_id = this.get('playlist_id');
      var playlist = store.peekRecord('playlist', playlist_id);
      playlist.set('interpolatedPlaylistId', this.get('interpolatedPlaylistId'));
      playlist.save();
      $("#edit-playlist-modal").modal("toggle");
    }
  }
});
