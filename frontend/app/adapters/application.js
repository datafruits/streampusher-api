import DS from 'ember-data';
import Ember from 'ember';

export default DS.RESTAdapter.extend({
  pathForType: function(type) {
    return Ember.String.underscore(type).pluralize();
  }
});
