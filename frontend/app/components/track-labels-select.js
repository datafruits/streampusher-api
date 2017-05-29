import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  actions: {
    setSelectedLabels(labels){
      this.set('track.labels', labels);
      let labelIds = labels.map((label) => {
        return label.get('id');
      });
      this.get('track').set('labelIds', labelIds)
    },
    createTag(name){
      let store = this.get('store');
      let label = store.createRecord('label', { name: name });
      let onSuccess = (label) =>{
        console.log("label saved!");
        this.get('track.labels').pushObject(label);
        this.get('track.labelIds').pushObject(label.get('id'));
      };
      let onFail = (response) => {
        this.set('error', "Failed to save tag: " + response.errors[0].detail)
        console.log("label save failed");
      };
      label.save().then(onSuccess, onFail);
    }
  }
});
