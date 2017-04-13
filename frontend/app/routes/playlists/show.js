import Ember from 'ember';

export default Ember.Route.extend({
  actions: {
    setIsSyncingPlaylist(val){
      console.log(val);
      this.get('controller').set('isSyncingPlaylist', val);
    }
  },
  setupController(controller, model){
    this._super(controller, model);
    controller.set('isSyncingPlaylist', false);
  },
  model(params) {
    return Ember.RSVP.hash({
      playlist: this.store.findRecord('playlist', params.id),
      tracks: this.store.findAll('track'),
      playlists: this.store.findAll('playlist'),
      labels: this.store.findAll('label')
    });
  }
});
