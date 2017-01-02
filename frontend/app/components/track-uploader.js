import EmberUploader from 'ember-uploader';
import Ember from 'ember';

export default EmberUploader.FileField.extend({
  classNames: ['upload'],
  store: Ember.inject.service(),
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
          alert("Sorry, there was an error uploading this file. This doesn't appear to be a valid audio file.");
          continue;
        }

        let uploader = EmberUploader.S3Uploader.create({
          signingUrl: this.get('signingUrl')
        });
        uploader.track = store.createRecord('track', { isUploading: true, audioFileName: files[i].name, filesize: files[i].size });
        window.onbeforeunload = function(e) {
          var dialogText = "You are currently uploading files. Closing this tab will cancel the upload operation! Are you usure you want to close this tab?";
          e.returnValue = dialogText;
          return dialogText;
        };

        uploader.on('didUpload', function(response) {
          // S3 will return XML with url
          let uploadedUrl = Ember.$(response).find('Location')[0].textContent;
          // http://yourbucket.s3.amazonaws.com/file.png
          uploadedUrl = decodeURIComponent(uploadedUrl);
          window.onbeforeunload = null;
          console.log("UPLOADED ! : " + uploadedUrl);
          this.track.set('audioFileName', uploadedUrl);
          this.track.set('isUploading', false);
          let onSuccess = () =>{
            console.log("track saved!");
          };
          let onFail = () => {
            console.log("track save failed");
          };
          this.track.save().then(onSuccess, onFail);
        });

        uploader.on('progress', function(e){
          // Handle progress changes
          //   // Use `e.percent` to get percentage
          this.track.set("uploadProgress", e.percent);
        });

        uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
          // Handle unsuccessful upload
          window.onbeforeunload = null;
          console.log("ERROR!" + textStatus);
          console.log("ERROR!" + errorThrown);
        });

        uploader.upload(files[i]);
      }
    }
  }
});
