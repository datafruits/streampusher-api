import DS from 'ember-data';
import Emebr from 'ember';

export default DS.Model.extend({
  track: DS.belongsTo('track'),
  label: DS.belongsTo('label')
});
