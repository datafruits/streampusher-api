import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  createdAt: DS.attr(),
  audioFileName: DS.attr(),
  filesize: DS.attr(),
  displayName: DS.attr(),
  artist: DS.attr(),
  title: DS.attr(),
  album: DS.attr(),
  artwork: DS.attr('file'),
  artworkFilename: DS.attr(),
  mixcloudUploadStatus: DS.attr(),
  isUploading: false,
  uploadProgress: 0,

  roundedUploadProgress: Ember.computed('uploadProgress', function(){
    return Math.round(this.get('uploadProgress'));
  }),
  mixcloudNotUploaded: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_not_uploaded'),
  mixcloudUploading: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_uploading'),
  mixcloudUploadComplete: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_upload_complete')
});
