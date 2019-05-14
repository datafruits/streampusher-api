import Component from '@ember/component';
import { isEmpty } from '@ember/utils';
import { inject as service } from '@ember/service';
import { get } from '@ember/object';

export default Component.extend({
  isUploading: false,
  flashMessages: service(),
  ajax: service(),
  didInsertElement(){
    if(!isEmpty($("#app-data").data('connected-accounts'))){
      this.set('hasMixcloudAccount', $("#app-data").data('connected-accounts').any(function(s){ return s.provider === "mixcloud" }));
      this.set('hasSoundcloudAccount', $("#app-data").data('connected-accounts').any(function(s){ return s.provider === "soundcloud" }));
    }
  },
  actions: {
    uploadToSoundcloud(){
      this.set('isUploading', true)
      let trackId = this.get('track').get('id');
      let url = `/tracks/${trackId}/soundcloud_uploads`;
      return this.get('ajax').request(url, {
        method: 'POST'
      }).then(response => {
        console.log(response);
        this.set('isUploading', false)
        if(response.status === 200){
          this.get('track').set('soundcloudUploadStatus', 'soundcloud_uploading');
        }else{
          get(this, 'flashMessages').danger('Something went wrong!');
        }
      });
    },
  }
});
