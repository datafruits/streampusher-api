import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'td',
  classNames: ['track', 'playlist-track'],
  isEditing: false,
  actions: {
    deleteFromPlaylist(){
      var playlistTrack = this.get('playlistTrack');
      playlistTrack.deleteRecord();
      playlistTrack.save();
    },
    editPlaylistTrack(){
      this.set('isEditing', true);
    },
    save(){
      var playlistTrack = this.get('playlistTrack');
      playlistTrack.save();
      this.set('isEditing', false);
    },
    cancel(){
      this.set('isEditing', false);
    }
  }
});
