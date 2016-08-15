import Ember from 'ember';

const { TextField } = Ember;

export default TextField.extend({
  type: 'file',
  file: null,

  change(e) {
    this.get('file').update(e.target.files[0]);
    this.set('filename', e.target.files[0].name)
  }
});
