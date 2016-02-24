import DS from 'ember-data';

export default DS.Model.extend({
  podcastPublishedDate: DS.attr(),
  playlist: DS.belongsTo('playlist'),
  track: DS.belongsTo('track'),
  playlist_id: DS.attr(),
  track_id: DS.attr()
});
