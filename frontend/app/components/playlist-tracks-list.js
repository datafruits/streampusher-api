import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  playlist: Ember.computed('playlist_id', function() {
    var store = this.get('store');
    var playlist_id = this.get('playlist_id');
    var playlist = store.findRecord('playlist', playlist_id);
    return playlist;
  }),
  isEditing: false,
  actions: {
    editPlaylist: function(){
      //this.toggleProperty('isEditing');
      $("#edit-playlist-modal").modal("toggle");
    },
    selectInterpolatedPlaylistId: function(playlistId) {
      this.set('interpolatedPlaylistId', playlistId);
    },
  }
});
