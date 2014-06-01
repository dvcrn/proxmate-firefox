// karma.conf.js
module.exports = function(config) {
  config.set({
    // base path, that will be used to resolve files and exclude
    basePath: '.tmp',

    frameworks: ['commonjs', 'mocha', 'sinon-chai'],

    files: [
      {pattern: 'test/test-*.js', included: true},
      {pattern: 'lib/**/*.js', included: true},
    ],

    preprocessors: {
      '**/*.js': ['commonjs']
    },

    browsers: ['PhantomJS'],
  });
};
