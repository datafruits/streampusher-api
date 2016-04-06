import DS from 'ember-data';

export default DS.Model.extend({
  audioFileName: DS.attr(),
  displayName: DS.attr(),
  artist: DS.attr(),
  title: DS.attr(),
  album: DS.attr(),
  isUploading: false,
  uploadProgress: 0,
  roundedUploadProgress: Ember.computed('uploadProgress', function(){
    return Math.round(this.get('uploadProgress'));
  })
});
