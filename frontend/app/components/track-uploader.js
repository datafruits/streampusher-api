import EmberUploader from 'ember-uploader';
import Ember from 'ember';

export default EmberUploader.FileField.extend({
  classNames: ['upload'],
  store: Ember.inject.service(),
  flashMessages: Ember.inject.service(),
  droppedFile: Ember.inject.service(),
  multiple: true,
  signingUrl: '/uploader_signature',
  validMimeTypes: ["audio/mp3", "audio/mpeg"],

  setup: function() {
    this.get('droppedFile').on('fileWasDropped', e => {
      this.filesDidChange(e);
    });
  }.on('init'),

  findBaseName: function(url) {
    var fileName = url.substring(url.lastIndexOf('/') + 1);
    var dot = fileName.lastIndexOf('.');
    return dot === -1 ? fileName : fileName.substring(0, dot);
  },

  filesDidChange: function(files) {

    let store = this.get('store');
    if (!Ember.isEmpty(files)) {
      for(let i = 0; i< files.length; i++){
        console.log(files[i].type);
        if(!this.validMimeTypes.includes(files[i].type)){
          console.log("invalid mime type: " + files[i].type);
          Ember.get(this, 'flashMessages').danger("Sorry, there was an error uploading this file. This doesn't appear to be a valid audio file.");
          continue;
        }

        let mimeType;
        if(files[i].type == "audio/mp3"){
          mimeType = "audio/mpeg";
        }else{
          mimeType = files[i].type;
        }

        console.log(mimeType);

        let uploader = EmberUploader.S3Uploader.create({
          signingUrl: this.get('signingUrl'),
          method: "PUT",
          ajaxSettings: {
            headers: {
              'Content-Type': mimeType,
              'x-amz-acl': 'public-read'
            }
          }
        });
        uploader.track = store.createRecord('track', { isUploading: true, audioFileName: files[i].name, filesize: files[i].size });
        window.onbeforeunload = function(e) {
          var dialogText = "You are currently uploading files. Closing this tab will cancel the upload operation! Are you usure you want to close this tab?";
          e.returnValue = dialogText;
          return dialogText;
        };

        uploader.on('didSign', function(response) {
          uploader.finalFileName = response.endpoint.split("?")[0];
        });

        uploader.on('didUpload', function(response) {
          window.onbeforeunload = null;
          this.track.set('audioFileName', this.finalFileName);
          this.track.set('isUploading', false);
          let onSuccess = () =>{
            console.log("track saved!");
          };
          let onFail = () => {
            console.log("track save failed");
            Ember.get(this, 'flashMessages').danger("Sorry, something went wrong uploading this file!");
          };
          this.track.save().then(onSuccess, onFail);
        });

        uploader.on('progress', function(e){
          this.track.set("uploadProgress", e.percent);
        });

        uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
          window.onbeforeunload = null;
          Ember.get(this, 'flashMessages').danger("Sorry, something went wrong!");
          console.log("ERROR!" + textStatus);
          console.log("ERROR!" + errorThrown);
        });

        uploader.upload(files[i]);
      }
    }
  }
});
