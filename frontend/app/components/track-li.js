import { htmlSafe } from '@ember/template';
import { computed, get } from '@ember/object';
import { inject as service } from '@ember/service';
import { isEmpty } from '@ember/utils';
import Component from '@ember/component';

export default Component.extend({
  store: service(),
  ajax: service(),
  flashMessages: service(),
  tagName: 'tr',
  classNames: ['track'],
  isEditing: false,
  isSaving: false,
  mixcloudDialog: false,
  soundcloudDialog: false,
  embedDialog: false,
  isAddingNewPlaylist: computed('playlist.id', function(){
    let playlist = this.get('playlist');
    return playlist.get('isNew');
  }),
  didInsertElement(){
    if(!isEmpty($("#app-data").data('connected-accounts'))){
      this.set('hasMixcloudAccount', $("#app-data").data('connected-accounts').any(function(s){ return s.provider === "mixcloud" }));
      this.set('hasSoundcloudAccount', $("#app-data").data('connected-accounts').any(function(s){ return s.provider === "soundcloud" }));
    }
  },
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
    editTrack(){
      this.toggleProperty('isEditing');
    },
    focusEmbedCode(){
      this.select();
    },
    mixcloud(){
      this.set('isEditing', false);
      this.toggleProperty('mixcloudDialog');
    },
    embed(){
      this.set('isEditing', false);
      this.toggleProperty('embedDialog');
    },
    uploadToMixcloud(){
      let trackId = this.get('track').get('id');
      let url = `/tracks/${trackId}/mixcloud_uploads`;
      return this.get('ajax').request(url, {
        method: 'POST'
      }).then(response => {
        console.log(response);
        if(response.status === 200){
          this.get('track').set('mixcloudUploadStatus', 'mixcloud_uploading');
        }else{
          get(this, 'flashMessages').danger('Something went wrong!');
        }
      });

    },
    uploadToSoundcloud(){
      let trackId = this.get('track').get('id');
      let url = `/tracks/${trackId}/soundcloud_uploads`;
      return this.get('ajax').request(url, {
        method: 'POST'
      }).then(response => {
        console.log(response);
        if(response.status === 200){
          this.get('track').set('soundcloudUploadStatus', 'soundcloud_uploading');
        }else{
          get(this, 'flashMessages').danger('Something went wrong!');
        }
      });

    },
    save(){
      this.set('isSaving', true);
      var track = this.get('track');
      var onSuccess = () =>{
        this.set('isEditing', false);
        this.set('isSaving', false);
      };
      var onFail = () =>{
        console.log("track save failed");
        get(this, 'flashMessages').danger('Something went wrong!');
        this.set('isSaving', false);
      };
      track.save().then(onSuccess, onFail);
    },
    cancel(){
      this.set('isEditing', false);
    },
    destroy(){
      if(confirm("Are you sure you want to delete this track?")){
        var track = this.get('track');
        // FIXME does this get removed from the playlist as well?
        track.destroyRecord();
      }
    },
    soundcloud(){
      this.set('isEditing', false);
      this.toggleProperty('soundcloudDialog');
    }
  }
});
