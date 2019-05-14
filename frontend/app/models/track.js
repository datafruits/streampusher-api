import { htmlSafe } from '@ember/template';
import { equal, or } from '@ember/object/computed';
import { computed } from '@ember/object';
import DS from 'ember-data';

export default DS.Model.extend({
  labels: DS.hasMany('labels'),
  scheduledShow: DS.belongsTo('scheduled-show'),
  uploadedBy: DS.attr(),
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

  roundedUploadProgress: computed('uploadProgress', function(){
    return Math.round(this.get('uploadProgress'));
  }),
  mixcloudNotUploaded: equal('mixcloudUploadStatus', 'mixcloud_not_uploaded'),
  mixcloudUploading: equal('mixcloudUploadStatus', 'mixcloud_uploading'),
  mixcloudUploadComplete: equal('mixcloudUploadStatus', 'mixcloud_upload_complete'),
  mixcloudUploadFailed: equal('mixcloudUploadStatus', 'mixcloud_upload_failed'),
  mixcloudNotUploadedOrUploadFailed: or('mixcloudNotUploaded', 'mixcloudUploadFailed'),

  soundcloudNotUploaded: equal('soundcloudUploadStatus', 'soundcloud_not_uploaded'),
  soundcloudUploading: equal('soundcloudUploadStatus', 'soundcloud_uploading'),
  soundcloudUploadComplete: equal('soundcloudUploadStatus', 'soundcloud_upload_complete'),
  soundcloudUploadFailed: equal('soundcloudUploadStatus', 'soundcloud_upload_failed'),
  soundcloudNotUploadedOrUploadFailed: or('soundcloudNotUploaded', 'soundcloudUploadFailed'),

  embedCode: computed('embedLink', function(){
    return `<iframe width="100%" height="100" frameborder="no" scrolling="no" src="${this.get('embedLink')}"></iframe>`;
  }),

  embedCodeSafe: computed('embedLink', function(){
    return htmlSafe(`<iframe width="100%" height="100%" frameborder="no" scrolling="no" src="${this.get('embedLink')}"></iframe>`);
  })
});
