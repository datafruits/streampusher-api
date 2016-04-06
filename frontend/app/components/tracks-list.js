import Ember from 'ember';

var { set } = Ember;

export default Ember.Component.extend({
  store: Ember.inject.service(),
  droppedFile: Ember.inject.service(),
  classNames        : [ 'draggableDropzone' ],
  classNameBindings : [ 'dragClass' ],
  dragClass         : 'deactivated',

  dragLeave(event) {
    event.preventDefault();
    set(this, 'dragClass', 'deactivated');
    $(".uploader-icon").hide();
  },

  dragOver(event) {
    event.preventDefault();
    set(this, 'dragClass', 'activated');
    $(".uploader-icon").show();
  },

  drop(event) {
    this.get('droppedFile').sendDroppedFile(event.dataTransfer.files);
    //event.dataTransfer.files[0]
    //var data = event.dataTransfer.getData('text/data');
    //this.sendAction('dropped', data);

    set(this, 'dragClass', 'deactivated');
    $(".uploader-icon").hide();
    event.preventDefault();
  }
});
