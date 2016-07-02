import Ember from 'ember';

var { set } = Ember;

export default Ember.Component.extend({
  store: Ember.inject.service(),
  filterText: '',
  isSearching: Ember.computed('filterText', function() {
    return this.get('filterText') !== "";
  }),
  filteredResults: Ember.computed('filterText', function() {
    var filter = this.get('filterText');
    return this.get('tracks').filter(function(item) {
      return item.get('displayName').toLowerCase().indexOf(filter) !== -1;
    });
  }),
  droppedFile: Ember.inject.service(),
  classNames        : [ 'draggableDropzone' ],
  classNameBindings : [ 'dragClass' ],
  dragClass         : 'deactivated',

  dragLeave(event) {
    event.preventDefault();
    set(this, 'dragClass', 'deactivated');
    Ember.$(".uploader-icon").hide();
  },

  dragOver(event) {
    event.preventDefault();
    set(this, 'dragClass', 'activated');
    Ember.$(".uploader-icon").show();
  },

  drop(event) {
    this.get('droppedFile').sendDroppedFile(event.dataTransfer.files);
    //event.dataTransfer.files[0]
    //var data = event.dataTransfer.getData('text/data');
    //this.sendAction('dropped', data);

    set(this, 'dragClass', 'deactivated');
    Ember.$(".uploader-icon").hide();
    event.preventDefault();
  },
  sortedTracks: Ember.computed.sort('tracks', function(a, b){
    if(a.isUploading || b.isUploading){
      if(a.isUploading && b.isUploading){
        return 0;
      } else if(a.isUploading){
        return -1;
      } else if(b.isUploading){
        return 1;
      }
    } else {
      if(a.get('createdAt') === b.get('createdAt')){
      } else if(a.get('createdAt') > b.get('createdAt')){
        return -1;
      } else if(a.get('createdAt') < b.get('createdAt')){
        return 1;
      }
    }
  }),
  actions: {
    clearSearch(){
      this.set('filterText','');
    }
  }
});
