import DS from 'ember-data';

export default DS.Model.extend({
  podcastPublishedDate: DS.attr(),
  podcastPublishedYear: DS.attr(),
  podcastPublishedMonth: DS.attr(),
  podcastPublishedDay: DS.attr(),
  displayName: DS.attr(),
  title: DS.attr(),
  playlist: DS.belongsTo('playlist'),
  track: DS.belongsTo('track')
});
