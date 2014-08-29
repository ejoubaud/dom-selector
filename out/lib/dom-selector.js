(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

/*

dom-selector
https://github.com/ejoubaud/dom-selector

Copyright (c) 2014 Emmanuel Joubaud
Licensed under the MIT license.
 */
'use strict';
var SelectionMode, domSelector, exports;

SelectionMode = require('./dom-selector/selection-mode');

domSelector = new SelectionMode();

if (typeof window === 'undefined') {
  exports = domSelector;
} else {
  window.domSelector = domSelector;
}



},{"./dom-selector/selection-mode":7}],2:[function(require,module,exports){
var BarItem, BarItemRenderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

BarItemRenderer = require('./renderers/bar-item');

module.exports = BarItem = (function() {
  function BarItem(modelEl, bar, selected) {
    this.modelEl = modelEl;
    this.bar = bar;
    this.selected = selected != null ? selected : false;
    this.newSelectionFromBar = __bind(this.newSelectionFromBar, this);
    this.renderer = new BarItemRenderer(modelEl, selected);
    this.renderer.addClickListener(this.newSelectionFromBar);
    this.elem = this.renderer.elem;
  }

  BarItem.prototype.newSelectionFromBar = function(ev) {
    ev.stopPropagation();
    return this.bar.newSelectionFromBar(this.modelEl);
  };

  BarItem.prototype.select = function() {
    this.selected = true;
    return this.renderer.select();
  };

  BarItem.prototype.unselect = function() {
    this.selected = false;
    return this.renderer.unselect();
  };

  return BarItem;

})();



},{"./renderers/bar-item":5}],3:[function(require,module,exports){
var $, Bar, BarItem, BarRenderer,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$ = require('./dom-utils');

BarItem = require('./bar-item');

BarRenderer = require('./renderers/bar');

module.exports = Bar = (function() {
  function Bar(selectionMode) {
    this.selectionMode = selectionMode;
    this.ok = __bind(this.ok, this);
    this.cancel = __bind(this.cancel, this);
    this.renderer = new BarRenderer(this.ok, this.cancel);
    this.visible = false;
    this._resetArrays();
  }

  Bar.prototype.show = function() {
    this.renderer.show();
    return this.visible = true;
  };

  Bar.prototype.hide = function() {
    this.renderer.hide();
    return this.visible = false;
  };

  Bar.prototype.reset = function(newTipEl) {
    this.tip = this.selected = newTipEl;
    this._resetArrays();
    this._generateList(newTipEl);
    return this.renderer.reset(this.barElems);
  };

  Bar.prototype.newSelectionFromBar = function(bodyEl) {
    this.selectionMode.newSelection(bodyEl);
    return this.newSelection(bodyEl);
  };

  Bar.prototype.newSelection = function(newEl) {
    var idx;
    if (this.selectedBarElem) {
      this.selectedBarElem.unselect();
    }
    if (!this.selected) {
      this.renderer.enableOkControl();
    }
    if (this.selected === newEl) {
      this.selected = this.selectedBarElem = null;
      return this.renderer.disableOkControl();
    } else if ((idx = $.inArray(newEl, this.referencedElems)) >= 0) {
      this.selectedBarElem = this.barElems[idx];
      this.selectedBarElem.select();
      return this.selected = newEl;
    } else {
      return this.reset(newEl);
    }
  };

  Bar.prototype.cancel = function() {
    return this.selectionMode.stop();
  };

  Bar.prototype.ok = function() {
    this.selectionMode.stop();
    return typeof this.successCallback === "function" ? this.successCallback(this.selected) : void 0;
  };

  Bar.prototype.holdsElement = function(el) {
    return this.renderer.holdsElement(el);
  };

  Bar.prototype._generateList = function(el) {
    var barItem;
    if (el.parentElement && el.nodeName.toLowerCase() !== 'body') {
      this._generateList(el.parentNode);
    }
    barItem = new BarItem(el, this, this.selected === el);
    this.referencedElems.push(el);
    this.barElems.push(barItem);
    return this.selectedBarElem = barItem;
  };

  Bar.prototype._resetArrays = function() {
    this.referencedElems = [];
    return this.barElems = [];
  };

  return Bar;

})();



},{"./bar-item":2,"./dom-utils":4,"./renderers/bar":6}],4:[function(require,module,exports){
module.exports = {
  removeClass: function(el, clazz) {
    var regex;
    regex = new RegExp("(^| )" + clazz + '($| )', 'g');
    return el.className = el.className.replace(regex, '');
  },
  addClass: function(el, clazz) {
    return el.className += ' ' + clazz;
  },
  hasParent: function(el, potentialParent) {
    if (el.parentNode) {
      return el.parentNode === potentialParent || this.hasParent(el.parentNode, potentialParent);
    } else {
      return false;
    }
  }
};

if (this.$ && this.$.each && this.$.inArray) {
  module.exports.$ = this.$;
  module.exports.each = this.$.each;
  module.exports.inArray = this.$.inArray;
} else {
  module.exports.$ = function(sel) {
    return document.querySelectorAll.call(document, sel);
  };
  module.exports.each = function(array, iterator) {
    return Array.prototype.forEach.call(array, function(idx, elem) {
      return iterator.call(array, elem, idx);
    });
  };
  module.exports.inArray = function(val, array, idx) {
    return Array.prototype.indexOf.call(array, val, idx);
  };
}



},{}],5:[function(require,module,exports){
var $, BarItemRenderer;

$ = require('../dom-utils');

module.exports = BarItemRenderer = (function() {
  function BarItemRenderer(modelEl, selected) {
    this.modelEl = modelEl;
    if (selected == null) {
      selected = false;
    }
    this._createItem(selected);
  }

  BarItemRenderer.prototype.addClickListener = function(listener) {
    return this.link.addEventListener('click', listener);
  };

  BarItemRenderer.prototype.select = function() {
    return $.addClass(this.link, 'dom-selector__elem--selected');
  };

  BarItemRenderer.prototype.unselect = function() {
    return $.removeClass(this.link, 'dom-selector__elem--selected');
  };

  BarItemRenderer.prototype._createItem = function(selected) {
    this.elem = document.createElement("li");
    this.link = document.createElement("a");
    this.link.className = "dom-selector__button dom-selector__elem";
    this.link.appendChild(this._createSpanWithClass(this._name(), "dom-selector__name"));
    if (this._hasId()) {
      this.link.appendChild(this._createSpanWithClass(this._id(), "dom-selector__id"));
    }
    if (this._hasClasses()) {
      this.link.appendChild(this._createSpanWithClass(this._classList(), "dom-selector__classes"));
    }
    this.elem.appendChild(this.link);
    if (selected) {
      return this.select();
    }
  };

  BarItemRenderer.prototype._createSpanWithClass = function(content, className) {
    var nodeNameEl;
    nodeNameEl = document.createElement("span");
    nodeNameEl.className = className;
    nodeNameEl.innerHTML = content;
    return nodeNameEl;
  };

  BarItemRenderer.prototype._hasId = function() {
    return this.modelEl.id !== '';
  };

  BarItemRenderer.prototype._id = function() {
    return "#" + this.modelEl.id;
  };

  BarItemRenderer.prototype._hasClasses = function() {
    return this.modelEl.className.trim() !== '';
  };

  BarItemRenderer.prototype._classList = function() {
    return this.modelEl.className.replace(/(^| )+/g, '.');
  };

  BarItemRenderer.prototype._name = function() {
    return this.modelEl.nodeName.toLowerCase();
  };

  return BarItemRenderer;

})();



},{"../dom-utils":4}],6:[function(require,module,exports){
var $, BarRenderer;

$ = require('../dom-utils');

module.exports = BarRenderer = (function() {
  function BarRenderer(successCb, cancelCb) {
    this.successCb = successCb;
    this.cancelCb = cancelCb;
    this._createElement();
    this._createControls();
    this._createList();
  }

  BarRenderer.prototype.reset = function(items) {
    this.items = items != null ? items : [];
    this.list.innerHTML = '';
    return $.each(this.items, (function(_this) {
      return function(i, item) {
        return _this.list.appendChild(item.elem);
      };
    })(this));
  };

  BarRenderer.prototype.show = function() {
    return document.body.appendChild(this.element);
  };

  BarRenderer.prototype.hide = function() {
    return document.body.removeChild(this.element);
  };

  BarRenderer.prototype.enableOkControl = function() {
    $.removeClass(this.okControl, 'dom-selector__ok-control--disabled');
    if (this.successCb) {
      return this.okControl.addEventListener('click', this.successCb);
    }
  };

  BarRenderer.prototype.disableOkControl = function() {
    $.addClass(this.okControl, 'dom-selector__ok-control--disabled');
    if (this.successCb) {
      return this.okControl.removeEventListener('click', this.successCb);
    }
  };

  BarRenderer.prototype.holdsElement = function(el) {
    return el === this.element || $.hasParent(el, this.element);
  };

  BarRenderer.prototype._createElement = function() {
    this.element = document.createElement("div");
    return this.element.className = "dom-selector__bar";
  };

  BarRenderer.prototype._createList = function() {
    this.list = document.createElement("ul");
    this.list.className = "dom-selector__list";
    return this.element.appendChild(this.list);
  };

  BarRenderer.prototype._createControls = function() {
    var content;
    content = {
      ok: "&#10003;",
      cancel: "&#10007;"
    };
    $.each(['cancel', 'ok'], (function(_this) {
      return function(i, name) {
        var c;
        c = _this["" + name + "Control"] = document.createElement("a");
        c.className = "dom-selector__button dom-selector__control dom-selector__" + name + "-control";
        c.innerHTML = content[name];
        return _this.element.appendChild(c);
      };
    })(this));
    this.disableOkControl();
    return this.cancelControl.addEventListener('click', this.cancelCb);
  };

  return BarRenderer;

})();



},{"../dom-utils":4}],7:[function(require,module,exports){
var $, Bar, SelectionMode,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$ = require('./dom-utils');

Bar = require('./bar');

module.exports = SelectionMode = (function() {
  function SelectionMode() {
    this.selectDom = __bind(this.selectDom, this);
    this.selected = null;
    this.selectedClass = 'dom-selector__selected';
    this.bar = new Bar(this);
    this.started = false;
  }

  SelectionMode.prototype.start = function(successCallback) {
    document.body.addEventListener('click', this.selectDom);
    this.showSelection();
    this.bar.successCallback = successCallback;
    if (this.bar.selected) {
      this.bar.show();
    }
    return this.started = true;
  };

  SelectionMode.prototype.stop = function() {
    document.body.removeEventListener('click', this.selectDom);
    this.hideSelection();
    this.bar.hide();
    return this.started = false;
  };

  SelectionMode.prototype.toggle = function(successCallback) {
    if (this.started) {
      return this.stop();
    } else {
      return this.start(successCallback);
    }
  };

  SelectionMode.prototype.selectDom = function(ev) {
    ev.stopPropagation();
    if (this.bar.holdsElement(ev.target)) {
      return false;
    }
    this.bar.newSelection(ev.target);
    if (!this.bar.visible) {
      this.bar.show();
    }
    return this.newSelection(ev.target);
  };

  SelectionMode.prototype.newSelection = function(newEl) {
    this.hideSelection();
    if (this.selected === newEl) {
      return this.selected = null;
    } else {
      this.selected = newEl;
      return this.showSelection();
    }
  };

  SelectionMode.prototype.hideSelection = function() {
    if (this.selected) {
      return $.removeClass(this.selected, this.selectedClass);
    }
  };

  SelectionMode.prototype.showSelection = function() {
    if (this.selected) {
      return $.addClass(this.selected, this.selectedClass);
    }
  };

  return SelectionMode;

})();



},{"./bar":3,"./dom-utils":4}]},{},[1]);
