module.exports = function (grunt) {

    require('load-grunt-tasks')(grunt);

    grunt.initConfig({
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
                src: ['src/**/*.coffee'],
                dest: 'dist/',
                ext: '.js'
            }
        },
        ngmin: {
            dist: {
                files: [
                    {expand: true, src: ['dist/src/pages/**/*.js'], dest: ''},
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
                            '  <%= manifest.name %> version <%= manifest.version %> by David Mohl\n' +
                            '  Built on <%= grunt.template.today("yyyy-mm-dd @ HH:MM") %>\n' +
                            '  Please see github.com/dabido/proxmate-chrome/ for infos\n' +
                            '*/\n'
                },
                files: [{
                    expand: true,
                    src: ['dist/**/*.js', '!dist/bower_components/**'],
                    dest: ''
                }]
            }
        },
        closurecompiler: {
            dist: {
                options: {
                    compilation_level: 'SIMPLE_OPTIMIZATIONS',
                    banner: '/*\n' +
                            '  <%= manifest.name %> version <%= manifest.version %> by David Mohl\n' +
                            '  Built on <%= grunt.template.today("yyyy-mm-dd @ HH:MM") %>\n' +
                            '  Please see github.com/dabido/proxmate-firefox/ for infos\n' +
                            '*/\n'
                },
                files: [{
                    expand: true,
                    src: ['dist/**/*.js', '!dist/bower_components/**'],
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
                        '.tmp/bower_components/jquery/dist/jquery.js': 'bower_components/jquery/dist/jquery.js',
                    },
                ]
            },
            test: {
                files: [{expand: true, src: ['test/testdata/**'], dest: '.tmp/'},]
            }
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
        'copy:src'
    ])

    grunt.registerTask('build', [
        'clean:dist',
        'coffee:dist',
        'copy:dist',
        'ngmin:dist',
        'closurecompiler:dist',
        'cssmin:dist',
        'htmlmin:dist'
    ])

    grunt.registerTask('serve', ['src', 'watch'])
    grunt.registerTask('test', ['src', 'copy:test', 'browserify:test','karma']);
    grunt.registerTask('default', 'test');
};
