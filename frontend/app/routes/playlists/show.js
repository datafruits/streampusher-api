import Ember from 'ember';

export default Ember.Route.extend({
  model(params) {
    return Ember.RSVP.hash({
      playlist: this.store.findRecord('playlist', params.id),
      tracks: this.store.findAll('track'),
      playlists: this.store.findAll('playlist')
    });
  }
});
