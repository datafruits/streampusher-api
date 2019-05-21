import Controller from '@ember/controller';
import { inject as service } from '@ember/service';
import { computed } from '@ember/object';
import { htmlSafe } from '@ember/template';
import { debounce } from '@ember/runloop';
import RSVP from 'rsvp';

export default Controller.extend({
  currentPlaylist: service(),
  flashMessages: service(),
  isSaving: false,
  mixcloudDialog: false,
  soundcloudDialog: false,
  embedDialog: false,
  uploadProgressStyle: computed('model.track.roundedUploadProgress', function(){
    return htmlSafe(`width: ${this.model.track.roundedUploadProgress}%;`);
  }),
  _performSearch(term, resolve, reject){
    this.store.query('scheduledShow', { term: term })
      .then((scheduledShows) => {
        return resolve(scheduledShows);
      }, reject);
  },
  actions: {
    searchShows(term){
      return new RSVP.Promise((resolve, reject) => {
        debounce(this, this._performSearch, term, resolve, reject, 600);
      });
    },

    focusEmbedCode(){
      this.select();
    },
    selectScheduledShow(scheduledShow){
      this.set('model.track.scheduledShow', scheduledShow);
    },
    save(){
      this.set('isSaving', true);
      let track = this.model.track;
      let currentPlaylist = this.get('currentPlaylist.playlist');
      const onSuccess = () =>{
        this.set('isSaving', false);
        this.transitionToRoute('playlists.show', currentPlaylist.id);
      };
      const onFail = () => {
        console.log("track save failed");
        this.get('flashMessages').danger('Something went wrong!');
        this.set('isSaving', false);
      };
      track.save().then(onSuccess, onFail);
    },
    destroy(){
      if(confirm("Are you sure you want to delete this track?")){
        let track = this.model.track;
        // FIXME does this get removed from the playlist as well?
        track.destroyRecord();
      }
    },
    soundcloud(){
      this.toggleProperty('soundcloudDialog');
    },
    mixcloud(){
      this.toggleProperty('mixcloudDialog');
    },
    embed(){
      this.toggleProperty('embedDialog');
    },
  }
});
