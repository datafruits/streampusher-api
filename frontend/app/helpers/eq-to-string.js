import Ember from 'ember';

export function eqToString(params/*, hash*/) {
  return params[0].toString() === params[1].toString();
}

export default Ember.Helper.helper(eqToString);
