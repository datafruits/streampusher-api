import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  playlists: Ember.computed('radio_id', function() {
    var store = this.get('store');
    var playlists = store.findAll('playlist');
    return playlists;
  })
});
