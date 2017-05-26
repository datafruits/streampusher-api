import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  actions: {
    createTag(name){
      let store = this.get('store');
      let label = store.createRecord('label', { name: name });
      let that = this;
      let onSuccess = (label) =>{
        console.log("label saved!");
        this.get('selectedLabels').pushObject(label);
      };
      let onFail = () => {
        console.log("label save failed");
      };
      label.save().then(onSuccess, onFail);
    }
  }
});
