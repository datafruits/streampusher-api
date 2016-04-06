import EmberUploader from 'ember-uploader';
import Ember from 'ember';

export default EmberUploader.FileField.extend({
  classNames: ['upload'],
  store: Ember.inject.service(),
  droppedFile: Ember.inject.service(),
  signingUrl: '/uploader_signature',

  setup: function() {
    this.get('droppedFile').on('fileWasDropped', e => {
      this.filesDidChange(e);
    });
  }.on('init'),


  filesDidChange: function(files) {
    const uploader = EmberUploader.S3Uploader.create({
      signingUrl: this.get('signingUrl')
    });

    var store = this.get('store');
    const track = store.createRecord('track', { isUploading: true, audioFileName: files[0].name });

    uploader.on('didUpload', response => {
      // S3 will return XML with url
      let uploadedUrl = $(response).find('Location')[0].textContent;
      // http://yourbucket.s3.amazonaws.com/file.png
      uploadedUrl = decodeURIComponent(uploadedUrl);
      console.log("UPLOADED ! : " + uploadedUrl);
      // create track record
      track.set('audioFileName', uploadedUrl);
      track.set('isUploading', false);
      var onSuccess = () =>{
        console.log("track saved!");
      };
      var onFail = () => {
        console.log("track save failed");
      };
      track.save().then(onSuccess, onFail);
    });

    uploader.on('progress', e => {
      // Handle progress changes
      //   // Use `e.percent` to get percentage
      track.set("uploadProgress", e.percent);
      console.log(e.percent);
    });

    uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
      // Handle unsuccessful upload
      console.log("ERROR!" + textStatus);
    });

    if (!Ember.isEmpty(files)) {
      uploader.upload(files[0]);
    }
  }
});
