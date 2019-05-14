import Component from '@ember/component';
import { isEmpty } from '@ember/utils';
import { inject as service } from '@ember/service';
import { get } from '@ember/object';

export default Component.extend({
  isUploading: false,
  flashMessages: service(),
  ajax: service(),
  willRender(){
    if(!isEmpty($("#app-data").data('connected-accounts'))){
      const mixcloudAccount = $("#app-data").data('connected-accounts').filter(function(s){ return s.provider === "mixcloud" })[0];
      if(mixcloudAccount){
        this.set('hasMixcloudAccount', true);
        this.set('mixcloudAccountName', mixcloudAccount.name);
      }
    }
  },
  actions: {
    uploadToMixcloud(){
      let trackId = this.get('track').get('id');
      let url = `/tracks/${trackId}/mixcloud_uploads`;
      return this.get('ajax').request(url, {
        method: 'POST'
      }).then(response => {
        console.log(response);
        if(response.status === 200){
          this.get('track').set('mixcloudUploadStatus', 'mixcloud_uploading');
        }else{
          get(this, 'flashMessages').danger('Something went wrong!');
        }
      });
    },
  }
});
