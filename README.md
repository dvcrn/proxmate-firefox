# Code has been moved. This version here is not maintained anymore.

## ProxMate for Firefox

Extension store version here - https://chrome.google.com/webstore/detail/proxmate/ifalmiidchkjjmkkbkoaibpmoeichmki

## Building

ProxMate is using grunt for building. To build a dist file (completely minified through googles clojurecompiler, cssmin and htmlmin) run `grunt build-live` or `grunt build-beta`.

Run `cfx run` inside the resulting folder to load the extension into firefox. 
