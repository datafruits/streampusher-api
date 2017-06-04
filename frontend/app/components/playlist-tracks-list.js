import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditingSettings: false,
  isEditing: false,
  isSelectingPlaylist: false,
  isSyncingPlaylist: false,
  actions: {
    reorderItems(groupModel, itemModels, draggedModel) {
      this.sendAction('setIsSyncingPlaylist', true);
      var draggedToIndex = itemModels.findIndex(function(element){ return element.id === draggedModel.id; });

      draggedModel.set('position', draggedToIndex);
      this.set('playlist.playlistTracks', itemModels);
      draggedModel.save().then(() => {
        groupModel.save();
        console.log("reorderItems success");
        this.sendAction('setIsSyncingPlaylist', false);
      }).catch((error) => {
        console.log("error");
        console.log(error);
        this.sendAction('setIsSyncingPlaylist', false);
      });
    },
    selectPlaylist(){
      this.toggleProperty('isSelectingPlaylist');
    },
    editPlaylist(){
      this.toggleProperty('isEditing');
    },
    cancelEditing(){
      this.toggleProperty('isEditing');
      if(this.playlist.get('isNew')){
        this.set('playlist', this.get('oldPlaylist'));
      }
    },
    editPlaylistSettings(){
      this.toggleProperty('isEditingSettings');
    },
    newPlaylist(){
      var store = this.get('store');
      var playlist = store.createRecord('playlist');
      this.set('oldPlaylist', this.get('playlist'));
      this.set('playlist', playlist);
      this.set('isEditing', true);
    },
    selectInterpolatedPlaylistId(playlistId) {
      var playlist = this.get('playlist');
      playlist.set('interpolatedPlaylistId', playlistId);
    },
    saveSettings() {
      var playlist = this.get('playlist');
      var onSuccess = () =>{
        this.set('isEditingSettings', false);
      };
      var onFail = () =>{
        console.log("playlist settings save failed");
      };
      playlist.save().then(onSuccess, onFail);
      //$("#edit-playlist-modal").modal("toggle");
    },
    save() {
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
