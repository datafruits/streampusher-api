import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  tagName: 'tr',
  classNames: ['track'],
  isEditing: false,
  actions: {
    addToPlaylist(){
      var store = this.get('store');
      var playlist = this.get('playlist');
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist });
      Ember.RSVP.all([playlistTrack.save(), playlist.save()]);
      //playlistTrack.save();
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
