import EmberUploader from 'ember-uploader';

export default EmberUploader.FileField.extend({
  signingUrl: '/uploader_signature',

  filesDidChange: function(files) {
    const uploader = EmberUploader.S3Uploader.create({
      signingUrl: this.get('signingUrl')
    });

    uploader.on('didUpload', response => {
      // S3 will return XML with url
      let uploadedUrl = $(response).find('Location')[0].textContent;
      // http://yourbucket.s3.amazonaws.com/file.png
      uploadedUrl = decodeURIComponent(uploadedUrl);
      console.log("UPLOADED ! : " + uploadedUrl);
    });

    if (!Ember.isEmpty(files)) {
      uploader.upload(files[0]);
    }
  },

  cleanFilename: function() {
  }
});
