import Ember from 'ember';

export default Ember.Component.extend({
  store: Ember.inject.service(),
  actions: {
    createTag(name){
      let store = this.get('store');
      let label = store.createRecord('label', { name: name });
      let onSuccess = () =>{
        console.log("label saved!");
      };
      let onFail = () => {
        console.log("label save failed");
      };
      label.save().then(onSuccess, onFail);
    }
  }
});
