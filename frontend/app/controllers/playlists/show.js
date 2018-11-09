import Controller from '@ember/controller';

export default Controller.extend({
  actions: {
    setIsSyncingPlaylist(val){
      this.set('isSyncingPlaylist', val);
    },
  }
});
