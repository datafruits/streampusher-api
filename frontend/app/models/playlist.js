import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  playlistTracks: DS.hasMany('playlist-track'),
  interpolatedPlaylistTrackIntervalCount: DS.attr(),
  interpolatedPlaylistTrackPlayCount: DS.attr(),
  interpolatedPlaylistId: DS.attr(),
  interpolatedPlaylistEnabled: DS.attr()
});
