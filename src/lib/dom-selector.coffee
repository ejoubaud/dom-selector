###

dom-selector
https://github.com/ejoubaud/dom-selector

Copyright (c) 2014 Emmanuel Joubaud
Licensed under the MIT license.

###

'use strict'

SelectionMode = require('./dom-selector/selection-mode')

domSelector = new SelectionMode()
if typeof window == 'undefined'
  exports = domSelector
else
  window.domSelector = domSelector
