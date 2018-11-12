import { get } from '@ember/object';
import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  store: service(),
  flashMessages: service(),
  isEditingSettings: false,
  isEditing: false,
  isSelectingPlaylist: false,
  isSyncingPlaylist: false,
  actions: {
    deletePlaylist(){
      if(confirm("Are you sure you want to delete this playlist?")){
        var playlist = this.get('playlist');
        this.set('isEditingSettings', false);
        playlist.destroyRecord().then(() => {
          this.get('transitionAfterDelete')();
        });
      }
    },
    reorderItems(groupModel, itemModels, draggedModel) {
      this.get('setIsSyncingPlaylist')(true);

      this.get('playlist.playlistTracks').map(function(playlistTrack){
        let newPosition = itemModels.findIndex(function(item){ return item.id == playlistTrack.id });
        playlistTrack.set('position', newPosition);
      });
      draggedModel.save().then(() => {
        this.set('playlist.playlistTracks', itemModels);
        console.log("reorderItems success");
        this.get('setIsSyncingPlaylist')(false);
      }).catch((error) => {
        console.log("error");
        console.log(error);
        get(this, 'flashMessages').danger("Sorry, something went wrong!");
        this.get('setIsSyncingPlaylist')(false);
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
        get(this, 'flashMessages').danger('Something went wrong!');
      };
      playlist.save().then(onSuccess, onFail);
    },
    save() {
      let playlist = this.get('playlist');
      let onSuccess = () =>{
        this.set('isEditing', false);
      };
      let onFail = () =>{
        console.log("playlist save failed");
        get(this, 'flashMessages').danger('Something went wrong!');
      };
      playlist.save().then(onSuccess, onFail);
    }
  }
});
