import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  playlistTracks: DS.hasMany('playlistTrack')
});
