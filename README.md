# dom-selector [![Build Status](https://secure.travis-ci.org/ejoubaud/dom-selector.png?branch=master)](http://travis-ci.org/ejoubaud/dom-selector)

A nice UI for users to select dom elements

## Getting Started
Install the module with: `npm install dom-selector`

```javascript
var dom-selector = require('dom-selector');
dom-selector.awesome(); // "awesome"
```

## Documentation
_(Coming soon)_

## Examples
_(Coming soon)_

## Compatibility

Works out of the box for IE>8 and recent browsers. It's easy enough to add support for IE8, all you need is to load either [es5-shim](https://github.com/es-shims/es5-shim) or [jQuery 1.x](http://jquery.com/) before the dom-selector script.

### Known issues

On IE8, we can't prevent existing events on an element to be triggered when it is selected, so some of the page original behaviour may be triggered while in selection mode. That's because IE8 doesn't support event capturing. However, dom-selector can and will stop the default behaviour (like following a link when clicking one) while in selection mode, so this will only be a problem on elements whose behaviour is handled by JS events.

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Grunt](http://gruntjs.com/).

## Release History
_(Nothing yet)_

## License
Copyright (c) 2014 Emmanuel Joubaud. Licensed under the MIT license.
