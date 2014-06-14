// karma.conf.js
module.exports = function(config) {
  config.set({
    // base path, that will be used to resolve files and exclude
    basePath: '.tmp',

    frameworks: ['browserify', 'mocha', 'sinon-chai'],

    files: [
      {pattern: 'bower_components/jquery/dist/jquery.js', included: true},
      {pattern: 'test/testdata/**/*.json', included: true},
      {pattern: 'test/test.js', included: true},
    ],

    browsers: ['PhantomJS'],
  });
};
