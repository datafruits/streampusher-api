import Ember from 'ember';

export default Ember.Component.extend({
  actions: {
    deleteFromPlaylist: function(){
      var playlistTrack = this.get('playlistTrack');
      playlistTrack.deleteRecord();
      playlistTrack.save();
    },
    editPlaylistTrack: function(){
    }
  }
});
