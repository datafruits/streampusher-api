import { hash } from 'rsvp';
import Route from '@ember/routing/route';

export default Route.extend({
  model(params){
    return hash({
      track: this.store.findRecord('track', params.id),
      labels: this.store.findAll('label')
    });
  }
});
