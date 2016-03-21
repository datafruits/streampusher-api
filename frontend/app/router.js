import Ember from 'ember';
import config from './config/environment';

const Router = Ember.Router.extend({
  location: config.locationType
});

Router.map(function() {
  this.route('playlists', function() {
    this.route('show', {path: '/playlists/:id'});
  });
});

export default Router;
