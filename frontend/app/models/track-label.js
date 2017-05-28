import DS from 'ember-data';
import Ember from 'ember';

export default DS.Model.extend({
  track: DS.belongsTo('track'),
  label: DS.belongsTo('label')
});
