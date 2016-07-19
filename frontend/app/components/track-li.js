import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  tagName: 'tr',
  classNames: ['track'],
  isEditing: false,
  actions: {
    addToPlaylist(){
      this.sendAction('setIsSyncingPlaylist', true);
      var store = this.get('store');
      var playlist = this.get('playlist');
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist, dirty: true });
      Ember.RSVP.all([playlistTrack.save(), playlist.save()]).then(() => {
        console.log("track save succeeded ");
        this.sendAction('setIsSyncingPlaylist', false);
      }),(() => {
        console.log("track save failed");
        this.sendAction('setIsSyncingPlaylist', false);
      });
    },
    editTrack(){
      this.set('isEditing', true);
    },
    save(){
      var track = this.get('track');
      var onSuccess = () =>{
        this.set('isEditing', false);
      };
      var onFail = () =>{
        console.log("track save failed");
      };
      track.save().then(onSuccess, onFail);
    },
    cancel(){
      this.set('isEditing', false);
    },
    destroy(){
      if(confirm("Are you sure you want to delete this track?")){
        var track = this.get('track');
        track.destroyRecord();
      }
    }
  }
});
