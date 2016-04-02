import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditingSettings: false,
  isEditing: false,
  actions: {
    editPlaylist: function(){
      this.toggleProperty('isEditing');
      //$("#edit-playlist-modal").modal("toggle");
    },
    editPlaylistSettings: function(){
      this.toggleProperty('isEditingSettings');
      //$("#edit-playlist-modal").modal("toggle");
    },
    newPlaylist: function(){
      var store = this.get('store');
      var playlist = store.createRecord('playlist');
      this.set('playlist', playlist);
      this.set('isEditing', true);
    },
    selectInterpolatedPlaylistId: function(playlistId) {
      this.set('interpolatedPlaylistId', playlistId);
    },
    saveSettings: function() {
      var playlist = this.get('playlist');
      playlist.set('interpolatedPlaylistId', this.get('interpolatedPlaylistId'));
      var onSuccess = () =>{
        this.set('isEditingSettings', false);
      };
      var onFail = () =>{
        console.log("playlist settings save failed");
      };
      playlist.save().then(onSuccess, onFail);
      //$("#edit-playlist-modal").modal("toggle");
    },
    save: function() {
      var playlist = this.get('playlist');
      var onSuccess = () =>{
        this.set('isEditing', false);
      };
      var onFail = () =>{
        console.log("playlist save failed");
      };
      playlist.save().then(onSuccess, onFail);
    }
  }
});
