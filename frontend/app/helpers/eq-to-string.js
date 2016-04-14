import Ember from 'ember';

export function eqToString(params/*, hash*/) {
  if(params[0] === null || params[1] === null){
    return false;
  }else{
    return params[0].toString() === params[1].toString();
  }
}

export default Ember.Helper.helper(eqToString);
