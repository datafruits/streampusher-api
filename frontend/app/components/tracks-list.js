import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  tracks: Ember.computed('playlist_id', function() {
    var store = this.get('store');
    var tracks = store.findAll('track');
    return tracks;
  })
});
