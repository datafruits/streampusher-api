import { helper as buildHelper } from '@ember/component/helper';

export function eqToString(params/*, hash*/) {
  if(params[0] === null || params[1] === null){
    return false;
  }else{
    return params[0].toString() === params[1].toString();
  }
}

export default buildHelper(eqToString);
