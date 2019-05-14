import { htmlSafe } from '@ember/template';
import { computed, get } from '@ember/object';
import { inject as service } from '@ember/service';
import Component from '@ember/component';

export default Component.extend({
  store: service(),
  ajax: service(),
  flashMessages: service(),
  tagName: 'tr',
  classNames: ['track'],
  isAddingNewPlaylist: computed('playlist.id', function(){
    let playlist = this.get('playlist');
    return playlist.get('isNew');
  }),
  uploadProgressStyle: computed('track.roundedUploadProgress', function(){
    return htmlSafe(`width: ${this.get('track.roundedUploadProgress')}%;`);
  }),
  actions: {
    addToPlaylist(){
      this.get('setIsSyncingPlaylist')(true);
      let store = this.get('store');
      let playlist = this.get('playlist');
      let track = this.get('track');
      playlist.get('playlistTracks').map(function(playlistTrack){
        let position = playlistTrack.get('position');
        playlistTrack.set('position', position+1);
      });
      let playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist, position: 0, displayName: track.get('displayName') });
      playlist.get('playlistTracks').pushObject(playlistTrack);
      playlistTrack.save().then(() => {
        playlist.save().then(() => {
          console.log("addToPlaylist success");
          this.get('setIsSyncingPlaylist')(false);
        });
      }).catch((error) => {
        console.log("error");
        console.log(error);
        this.get('setIsSyncingPlaylist')(false);
        get(this, 'flashMessages').danger('Something went wrong!');
      });
    },
  }
});
