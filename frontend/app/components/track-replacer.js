import S3Uploader from 'ember-uploader/uploaders/s3';
import { inject as service } from '@ember/service';
import { isEmpty } from '@ember/utils';
import { get } from '@ember/object';
import TrackUploaderComponent from './track-uploader';

export default TrackUploaderComponent.extend({
  filesDidChange: function(files) {

    const store = this.get('store');
    const _this = this;
    if (!isEmpty(files)) {
      for(let i = 0; i< files.length; i++){
        console.log(files[i].type);
        if(!this.validMimeTypes.includes(files[i].type)){
          console.log("invalid mime type: " + files[i].type);
          get(this, 'flashMessages').danger("Sorry, there was an error uploading this file. This doesn't appear to be a valid audio file.");
          continue;
        }

        let mimeType;
        if(files[i].type == "audio/mp3"){
          mimeType = "audio/mpeg";
        }else{
          mimeType = files[i].type;
        }

        console.log(mimeType);

        let uploader = S3Uploader.create({
          signingUrl: this.get('signingUrl'),
          method: "PUT",
          ajaxSettings: {
            headers: {
              'Content-Type': mimeType,
              'x-amz-acl': 'public-read'
            }
          }
        });
        //uploader.track = store.createRecord('track', { isUploading: true, audioFileName: files[i].name, filesize: files[i].size });
        this.track.set('isUploading', true);
        this.track.set('audioFileName', files[i].name);
        uploader.track = this.track;
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
        });

        uploader.on('progress', function(e){
          this.track.set("uploadProgress", e.percent);
        });

        uploader.on('didError', (jqXHR, textStatus, errorThrown) => {
          window.onbeforeunload = null;
          get(_this, 'flashMessages').danger("Sorry, something went wrong!");
          console.log("ERROR!" + textStatus);
          console.log("ERROR!" + errorThrown);
        });

        uploader.upload(files[i]);
      }
    }
  }
});
