import resolver from './helpers/resolver';
import './helpers/flash-message';

import {
  setResolver
} from 'ember-qunit';
import { start } from 'ember-cli-qunit';
import Application from '../app';
import config from '../config/environment';
import { setApplication } from '@ember/test-helpers';

setApplication(Application.create(config.APP));

start();
