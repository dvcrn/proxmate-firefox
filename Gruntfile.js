module.exports = function (grunt) {

    require('load-grunt-tasks')(grunt);

    grunt.initConfig({
        manifest: grunt.file.readJSON('package.json'),
        karma: {
            src: {
                configFile: 'karma.conf.js',
                singleRun: true
            }
        },
        watch: {
            coffee: {
                files: ['src/**/*.coffee'],
                // tasks: ['coffee:src', 'karma']
                tasks: ['coffee:src']
            },
            test: {
                files: ['test/**/*.coffee'],
                tasks: ['coffee:test']
                // tasks: ['coffee:test', 'karma']
            }
        },
        coffee: {
            src: {
                expand: true,
                src: ['**/*.coffee'],
                dest: '.tmp/lib',
                ext: '.js',
                cwd: 'src/',
            },
            test: {
                expand: true,
                src: ['test/**/*.coffee'],
                dest: '.tmp/',
                ext: '.js',
            },
            dist: {
                expand: true,
                src: ['**/*.coffee', '!src/test/**'],
                dest: 'dist/lib',
                ext: '.js',
                cwd: 'src/'
            }
        },
        ngmin: {
            dist: {
                files: [
                    {expand: true, src: ['dist/data/src/pages/**/*.js'], dest: ''},
                ]
            }
        },
        browserify: {
            test: {
                files: {
                    '.tmp/test/test.js': ['.tmp/lib/*.js', '.tmp/test/*.js'],
                }
            }
        },
        uglify: {
            dist: {
                options: {
                    mangle: true,
                    compress: true,
                    banner: '/*\n' +
                            '  ProxMate version <%= manifest.version %> by David Mohl\n' +
                            '  Built on <%= grunt.template.today("yyyy-mm-dd @ HH:MM") %>\n' +
                            '  Please see github.com/dabido/proxmate-firefox/ for infos\n' +
                            '*/\n'
                },
                files: [{
                    expand: true,
                    src: ['dist/**/*.js', '!dist/data/bower_components/**'],
                    dest: ''
                }]
            }
        },
        closurecompiler: {
            dist: {
                options: {
                    compilation_level: 'SIMPLE_OPTIMIZATIONS',
                    banner: '/*\n' +
                            '  ProxMate version <%= manifest.version %> by David Mohl\n' +
                            '  Built on <%= grunt.template.today("yyyy-mm-dd @ HH:MM") %>\n' +
                            '  Please see github.com/dabido/proxmate-firefox/ for infos\n' +
                            '*/\n'
                },
                files: [{
                    expand: true,
                    src: ['dist/**/*.js', '!dist/data/bower_components/**'],
                    dest: ''
                }]
            }
        },
        cssmin: {
            dist: {
                files: [{
                    expand: true,
                    src: ['dist/**/*.css'],
                    dest: ''
                }]
            }
        },
        htmlmin: {
            dist: {
                options: {
                    collapseWhitespace: true,
                    collapseBooleanAttributes: true,
                    removeCommentsFromCDATA: true,
                    removeOptionalTags: true
                },
                files: [{
                    expand: true,
                    src: ['dist/**/*.html'],
                    dest: ''
                }]
            }
        },
        copy: {
            src: {
                files: [{
                        '.tmp/package.json': 'package.json',
                        '.tmp/lib/proxmate.json': 'proxmate.json',
                        '.tmp/data/bower_components/jquery/dist/jquery.js': 'bower_components/jquery/dist/jquery.js',
                        '.tmp/data/bower_components/angular/angular.js': 'bower_components/angular/angular.min.js',
                        '.tmp/data/bower_components/angular-route/angular-route.js': 'bower_components/angular-route/angular-route.min.js',
                        '.tmp/data/bower_components/foundation/css/foundation.min.css': 'bower_components/foundation/css/foundation.min.css',
                        '.tmp/data/bower_components/foundation/css/normalize.css': 'bower_components/foundation/css/normalize.css',
                    },
                    {expand: true, src: ['ressources/**/*'], dest: '.tmp/data'},
                    {expand: true, src: ['pages/**/*'], dest: '.tmp/data'},
                ]
            },
            dist: {
                files: [{
                    'dist/package.json': 'package.json',
                    'dist/lib/proxmate.json': 'proxmate.json',
                    'dist/data/bower_components/jquery/dist/jquery.js': 'bower_components/jquery/dist/jquery.min.js',
                    'dist/data/bower_components/angular/angular.js': 'bower_components/angular/angular.min.js',
                    'dist/data/bower_components/angular-route/angular-route.js': 'bower_components/angular-route/angular-route.min.js',
                    'dist/data/bower_components/foundation/css/foundation.min.css': 'bower_components/foundation/css/foundation.min.css',
                    'dist/data/bower_components/foundation/css/normalize.css': 'bower_components/foundation/css/normalize.css',
                    },
                    {expand: true, src: ['ressources/**/*'], dest: 'dist/data'},
                    {expand: true, src: ['pages/**/*'], dest: 'dist/data'},
                ]
            },
            test: {
                files: [{expand: true, src: ['test/testdata/**'], dest: '.tmp/'},]
            }
        },
        shell: {
            srcpages: {
                command: 'mkdir -p .tmp/data/src && mv .tmp/lib/pages .tmp/data/src/pages'
            },
            srcpageworker: {
                command: 'mkdir -p .tmp/data/src && mv .tmp/lib/page-worker .tmp/data/src/page-worker'
            },
            distpages: {
                command: 'mkdir -p dist/data/src && mv dist/lib/pages dist/data/src/pages'
            },
            distpageworker: {
                command: 'mkdir -p dist/data/src && mv dist/lib/page-worker dist/data/src/page-worker'
            },
        },
        replace: {
            beta: {
                options: {
                    patterns: [{
                        json: grunt.file.readJSON('config/beta.json')
                    }]
                },
                files: [{
                    expand: true,
                    src: ['dist/**/**', '!dist/**/*.png'],
                    dest: ''
                }]
            },
            dev: {
                options: {
                    patterns: [{
                        json: grunt.file.readJSON('config/dev.json')
                    }]
                },
                files: [{
                    expand: true,
                    src: ['.tmp/**/**', '!.tmp/**/*.png'],
                    dest: ''
                }]
            },
            live: {
                options: {
                    patterns: [{
                        json: grunt.file.readJSON('config/live.json')
                    }]
                },
                files: [{
                    expand: true,
                    src: ['dist/**/**', '!dist/**/*.png'],
                    dest: ''
                }]
            },
        },
        clean: {
            src: '.tmp',
            dist: 'dist'
        }
    });

    // Register commands
    grunt.registerTask('src', [
        'clean:src',
        'coffee:src',
        'coffee:test',
        'copy:src',
        'shell:srcpages',
        'shell:srcpageworker',
        'replace:dev'
    ]);

    grunt.registerTask('minify', [
        'ngmin:dist',
        'closurecompiler:dist',
        'cssmin:dist',
        'htmlmin:dist'
    ]);

    grunt.registerTask('build', [
        'clean:dist',
        'coffee:dist',
        'copy:dist',
        'shell:distpages',
        'shell:distpageworker',
    ]);

    grunt.registerTask('build-live', [
        'build',
        'replace:live',
        'minify'
    ]);

    grunt.registerTask('build-beta', [
        'build',
        'replace:beta',
        'minify'
    ]);

    grunt.registerTask('serve', ['src', 'watch']);
    grunt.registerTask('test', ['src', 'copy:test', 'browserify:test', 'karma']);
    grunt.registerTask('default', 'test');
};
