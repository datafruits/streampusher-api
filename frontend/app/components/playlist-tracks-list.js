import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  isEditingSettings: false,
  isEditing: false,
  isSelectingPlaylist: false,
  isSyncingPlaylist: false,
  interpolatedPlaylistIdString: Ember.computed('interpolatedPlaylistId', function(){
    var selectedId = this.get('playlist').get('interpolatedPlaylistId');
    return selectedId.toString();
  }),
  positionDesc: ["position:asc"],
  filteredPlaylistTracks: Ember.computed.filter('playlist.playlistTracks', function(playlistTrack){
    return playlistTrack.get('updatedAt') <= this.get('playlist').get('updatedAt');
  }),
  sortedPlaylistTracks: Ember.computed.sort('filteredPlaylistTracks', 'positionDesc'),
  actions: {
    reorderItems(groupModel, itemModels, draggedModel) {
      var draggedToIndex = itemModels.findIndex(function(element){ return element.id === draggedModel.id; });

      draggedModel.set('position', draggedToIndex);
      this.set('playlist.playlistTracks', itemModels);
      return Ember.RSVP.all([draggedModel.save(), groupModel.save()]);
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
