import Ember from 'ember';

export default Ember.Service.extend(Ember.Evented, {
  sendDroppedFile: function(file){
    console.log(file);
    this.trigger('fileWasDropped', file);
  }
});
