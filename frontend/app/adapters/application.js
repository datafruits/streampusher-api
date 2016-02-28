import DS from 'ember-data';

export default DS.RESTAdapter.extend({
  pathForType: function(type) {
    var underscored = Ember.String.underscore(type);
    return Ember.String.pluralize(underscored);
  }
});
