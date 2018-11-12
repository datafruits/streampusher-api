import { sort } from '@ember/object/computed';
import $ from 'jquery';
import { inject as service } from '@ember/service';
import Component from '@ember/component';
import { set, computed } from '@ember/object';

export default Component.extend({
  store: service(),
  filterText: '',
  selectedLabels: [],
  isSearching: computed('filterText', 'selectedLabels', function() {
    return this.get('filterText') !== "" || this.get('selectedLabels').length !== 0;
  }),
  filteredResults: computed('filterText', 'selectedLabels', function() {
    let filter = this.get('filterText');
    let labelIds = this.get('selectedLabels').map(function(label){
      return parseInt(label.get('id'));
    });
    return this.get('tracks').filter(function(item) {
      if(item.get('isUploading')){
        return false;
      }
      if(labelIds.length != 0){
        if(_.intersection(item.get('labelIds'), labelIds).length !== labelIds.length){
          return false
        }
      }
      return item.get('displayName').toLowerCase().indexOf(filter) !== -1;
    });
  }),
  droppedFile: service(),
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
  },
  sortedTracks: sort('tracks', function(a, b){
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
