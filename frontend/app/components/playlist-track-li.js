import Ember from 'ember';

export default Ember.Component.extend({
  isEditing: false,
  actions: {
    deleteFromPlaylist: function(){
      var playlistTrack = this.get('playlistTrack');
      playlistTrack.deleteRecord();
      playlistTrack.save();
    },
    editPlaylistTrack: function(){
      this.set('isEditing', true);
    },
    save: function(){
      var playlistTrack = this.get('playlistTrack');
      playlistTrack.save();
      this.set('isEditing', false);
    },
    cancel: function(){
      this.set('isEditing', false);
    }
  }
});
