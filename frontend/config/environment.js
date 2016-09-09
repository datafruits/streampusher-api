/* jshint node: true */

module.exports = function(environment) {
  var ENV = {
    modulePrefix: 'frontend',
    environment: environment,
    baseURL: '/',
    locationType: 'auto',
    //locationType: 'none',
    EmberENV: {
      FEATURES: {
        // Here you can enable experimental features on an ember canary build
        // e.g. 'with-controller': true
      }
    },

    APP: {
      // Here you can pass flags/options to your application instance
      // when it is created
      rootElement: '#ember-application'
    },

    moment: {
      // Options:
      // 'all' - all years, all timezones
      // '2010-2020' - 2010-2020, all timezones
      // 'none' - no data, just timezone API
      includeTimezone: 'all'
    }
  };

  if (environment === 'development') {
    // ENV.APP.LOG_RESOLVER = true;
    // ENV.APP.LOG_ACTIVE_GENERATION = true;
    // ENV.APP.LOG_TRANSITIONS = true;
    // ENV.APP.LOG_TRANSITIONS_INTERNAL = true;
    // ENV.APP.LOG_VIEW_LOOKUPS = true;
    ENV.paperclip = {
      path: ":base/:attachment/:style/:filename?:updated_at",
      base: "http://s3.amazonaws.com/streampusherdev"
    };
  }

  if (environment === 'test') {
    // Testem prefers this...
    ENV.baseURL = '/';
    ENV.locationType = 'none';

    // keep test console output quieter
    ENV.APP.LOG_ACTIVE_GENERATION = false;
    ENV.APP.LOG_VIEW_LOOKUPS = false;

    ENV.APP.rootElement = '#ember-testing';
    ENV.paperclip = {
      path: ":base/:attachment/:style/:filename?:updated_at",
      base: "http://s3.amazonaws.com/streampushertest"
    };
  }

  if (environment === 'production') {
    ENV.paperclip = {
      path: ":base/:attachment/:style/:filename?:updated_at",
      base: "http://s3.amazonaws.com/streampusher"
    };
  }

  return ENV;
};
