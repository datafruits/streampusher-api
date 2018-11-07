import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  labels: DS.hasMany('labels'),
  labelIds: DS.attr(),
  createdAt: DS.attr(),
  updatedAt: DS.attr(),
  audioFileName: DS.attr(),
  filesize: DS.attr(),
  displayName: DS.attr(),
  artist: DS.attr(),
  title: DS.attr(),
  album: DS.attr(),
  artwork: DS.attr('file'),
  artworkFilename: DS.attr(),
  mixcloudUploadStatus: DS.attr(),
  mixcloudKey: DS.attr(),
  soundcloudUploadStatus: DS.attr(),
  soundcloudKey: DS.attr(),
  embedLink: DS.attr(),
  isUploading: false,
  uploadProgress: 0,

  roundedUploadProgress: Ember.computed('uploadProgress', function(){
    return Math.round(this.get('uploadProgress'));
  }),
  mixcloudNotUploaded: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_not_uploaded'),
  mixcloudUploading: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_uploading'),
  mixcloudUploadComplete: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_upload_complete'),
  mixcloudUploadFailed: Ember.computed.equal('mixcloudUploadStatus', 'mixcloud_upload_failed'),
  mixcloudNotUploadedOrUploadFailed: Ember.computed.or('mixcloudNotUploaded', 'mixcloudUploadFailed'),

  soundcloudNotUploaded: Ember.computed.equal('soundcloudUploadStatus', 'soundcloud_not_uploaded'),
  soundcloudUploading: Ember.computed.equal('soundcloudUploadStatus', 'soundcloud_uploading'),
  soundcloudUploadComplete: Ember.computed.equal('soundcloudUploadStatus', 'soundcloud_upload_complete'),
  soundcloudUploadFailed: Ember.computed.equal('soundcloudUploadStatus', 'soundcloud_upload_failed'),
  soundcloudNotUploadedOrUploadFailed: Ember.computed.or('soundcloudNotUploaded', 'soundcloudUploadFailed'),

  embedCode: Ember.computed('embedLink', function(){
    return `<iframe width="100%" height="100" frameborder="no" scrolling="no" src="${this.get('embedLink')}"></iframe>`;
  }),

  embedCodeSafe: Ember.computed('embedLink', function(){
    return Ember.String.htmlSafe(`<iframe width="100%" height="100%" frameborder="no" scrolling="no" src="${this.get('embedLink')}"></iframe>`);
  })
});
