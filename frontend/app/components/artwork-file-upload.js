import TextField from '@ember/component/text-field';

export default TextField.extend({
  type: 'file',
  file: null,

  change(e) {
    this.get('file').update(e.target.files[0]);
    this.set('filename', e.target.files[0].name)
  }
});
