import Evented from '@ember/object/evented';
import Service from '@ember/service';

export default Service.extend(Evented, {
  sendDroppedFile: function(file){
    console.log(file);
    this.trigger('fileWasDropped', file);
  }
});
