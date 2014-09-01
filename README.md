# dom-selector [![Build Status](https://secure.travis-ci.org/ejoubaud/dom-selector.png?branch=master)](http://travis-ci.org/ejoubaud/dom-selector)

A friendly UI to let users to select dom elements.

## Getting Started

Include `dom-selector.js` and `dom-selector.css` and start the selection by running:

```javascript
domSelector.start(function(selectedElement) {
	doStuffWithTheUserSelectedElement();
});
```

## Compatibility

Works out of the box for IE>8 and recent browsers. It should eventually be easy enough to add support for IE8, just by loading either [es5-shim](https://github.com/es-shims/es5-shim) or [jQuery 1.x](http://jquery.com/) before the dom-selector script.

### Known issues

On IE8, we can't prevent existing events on an element to be triggered when it is selected, so some of the page original behaviour may be triggered while in selection mode. That's because IE8 doesn't support event capturing. However, dom-selector can and will stop the default behaviour (like following a link when clicking one) while in selection mode, so this will only be a problem on elements whose behaviour is handled by JS events.

## Contributing
In lieu of a formal styleguide, take care to maintain the existing coding style. Add unit tests for any new or changed functionality. Lint and test your code using [Gulp](http://gulpjs.com/).

## Release History

- v0.1.0: MVP release

## Roadmap:

- Add screenshots to the README.
- Add integration tests
- Ensure IE8 compatibility with jQuery or es5-shim
- Add parameters:
  - Cancel callback
  - Selection callback (for any selection, not just the final submitted one)
  - Bar element renderer
  - CSS class names?

## License
Copyright (c) 2014 Emmanuel Joubaud. Licensed under the MIT license.
