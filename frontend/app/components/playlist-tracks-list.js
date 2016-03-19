import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  playlist: Ember.computed('playlist_id', function() {
    var store = this.get('store');
    var playlist_id = this.get('playlist_id');
    var playlist = store.findRecord('playlist', playlist_id);
    return playlist;
  }),
  parsedPlaylists: Ember.computed('', function() {
    var parsed = JSON.parse(this.get('currentPlaylists'));
    return parsed;
  }),
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
    }
  }
});
