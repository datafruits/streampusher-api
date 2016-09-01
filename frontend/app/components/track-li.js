import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  ajax: Ember.inject.service(),
  tagName: 'tr',
  classNames: ['track'],
  isEditing: false,
  isSaving: false,
  mixcloudDialog: false,
  soundcloudDialog: false,
  embedDialog: false,
  mixcloudAccount: Ember.computed('', function(){
    return $("#app-data").data('current-user').user.social_identities.find(function(s){ return s.provider === "mixcloud" });
  }),
  hasMixcloudAccount: Ember.computed('', function(){
    return this.get('mixcloudAccount');
  }),
  actions: {
    addToPlaylist(){
      this.sendAction('setIsSyncingPlaylist', true);
      var store = this.get('store');
      var playlist = this.get('playlist');
      var track = this.get('track');
      var playlistTrack = store.createRecord('playlist_track', { track: track, playlist: playlist, dirty: true });
      Ember.RSVP.all([playlistTrack.save(), playlist.save()]).then(() => {
        this.sendAction('setIsSyncingPlaylist', false);
      }),(() => {
        this.sendAction('setIsSyncingPlaylist', false);
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
    }
  }
});
