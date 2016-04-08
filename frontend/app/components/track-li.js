import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  tagName: 'tr',
  classNames: ['track'],
  isEditing: false,
  actions: {
    addToPlaylist: function(){
      var store = this.get('store');
      var playlist = this.get('playlist')
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist });
      playlistTrack.save();
    },
    editTrack: function(){
      this.set('isEditing', true);
    },
    save: function(){
      var track = this.get('track');
      var onSuccess = () =>{
        this.set('isEditing', false);
      };
      var onFail = () =>{
        console.log("track save failed");
      };
      track.save().then(onSuccess, onFail);
    },
    cancel: function(){
      this.set('isEditing', false);
    },
    destroy: function(){
      if(confirm("Are you sure you want to delete this track?")){
        var track = this.get('track');
        track.destroyRecord();
      }
    }
  }
});
