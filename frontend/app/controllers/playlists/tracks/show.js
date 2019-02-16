import Controller from '@ember/controller';

export default Controller.extend({
  isSaving: false,
  mixcloudDialog: false,
  soundcloudDialog: false,
  embedDialog: false,
  actions: {
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
    },
    mixcloud(){
      this.set('isEditing', false);
      this.toggleProperty('mixcloudDialog');
    },
    embed(){
      this.set('isEditing', false);
      this.toggleProperty('embedDialog');
    },
  }
});
