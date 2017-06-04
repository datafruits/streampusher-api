import Ember from 'ember';

export default Ember.Component.extend({
  tagName: 'td',
  classNames: ['track', 'playlist-track'],
  isEditing: false,
  actions: {
    deleteFromPlaylist(){
      let playlistTrack = this.get('playlistTrack');
      playlistTrack.destroyRecord();
    },
    editPlaylistTrack(){
      this.set('isEditing', true);
    },
    save(){
      let playlistTrack = this.get('playlistTrack');
      playlistTrack.save();
      this.set('isEditing', false);
    },
    cancel(){
      this.set('isEditing', false);
    }
  }
});
