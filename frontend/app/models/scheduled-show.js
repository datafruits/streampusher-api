import DS from 'ember-data';
import { computed } from '@ember/object';

export default DS.Model.extend({
  tracks: DS.hasMany('track'),
  startAt: DS.attr(),
  endAt: DS.attr(),
  start: DS.attr(),
  end: DS.attr(),
  title: DS.attr(),
  imageFilename: DS.attr(),
  tweetContent: DS.attr(),
  description: DS.attr(),
  timezone: DS.attr(),
  recurringInterval: DS.attr(),

  formattedDate: computed('start', function(){
    return moment(this.get('start')).format()
  }),
  displayTitle: computed('title', 'formattedDate', function(){
    return `${this.title} - ${this.formattedDate}`;
  })
});
