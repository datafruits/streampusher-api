import { sort } from '@ember/object/computed';
import DS from 'ember-data';
import { validator, buildValidations } from 'ember-cp-validations';
const Validations = buildValidations({
  name: validator('presence', { presence: true, message: "cannot be blank"}),
});


export default DS.Model.extend(Validations, {
  name: DS.attr(),
  createdBy: DS.attr(),
  playlistTracks: DS.hasMany('playlist-track'),
  interpolatedPlaylistTrackIntervalCount: DS.attr(),
  interpolatedPlaylistTrackPlayCount: DS.attr(),
  interpolatedPlaylistId: DS.attr(),
  interpolatedPlaylistEnabled: DS.attr(),
  noCueOut: DS.attr(),
  updatedAt: DS.attr('date'),
  shuffle: DS.attr(),

  positionDesc: ["position:asc"],
  sortedPlaylistTracks: sort('playlistTracks', 'positionDesc')
});
