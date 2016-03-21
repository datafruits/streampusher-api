import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditing: false,
  actions: {
    editPlaylist: function(){
      this.toggleProperty('isEditing');
      //$("#edit-playlist-modal").modal("toggle");
    },
    selectInterpolatedPlaylistId: function(playlistId) {
      this.set('interpolatedPlaylistId', playlistId);
    },
    save: function() {
      var playlist = this.get('playlist');
      playlist.set('interpolatedPlaylistId', this.get('interpolatedPlaylistId'));
      var onSuccess = () =>{
        this.set('isEditing', false);
      };
      var onFail = () =>{
        console.log("track save failed");
      };
      playlist.save().then(onSuccess, onFail);
      //$("#edit-playlist-modal").modal("toggle");
    }
  }
});
