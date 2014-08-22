(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

/*

dom-selector
https://github.com/ejoubaud/dom-selector

Copyright (c) 2014 Emmanuel Joubaud
Licensed under the MIT license.
 */
'use strict';
var SelectionMode, domSelector, exports;

SelectionMode = require('./dom-selector/selection-mode.coffee');

domSelector = new SelectionMode();

if (typeof window === 'undefined') {
  exports = domSelector;
} else {
  window.domSelector = domSelector;
}



},{"./dom-selector/selection-mode.coffee":5}],2:[function(require,module,exports){
var $, BarItem,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$ = require('./dom-utils.coffee');

module.exports = BarItem = (function() {
  function BarItem(modelEl, bar, selected) {
    this.modelEl = modelEl;
    this.bar = bar;
    this.selected = selected != null ? selected : false;
    this.newSelectionFromBar = __bind(this.newSelectionFromBar, this);
    this.createItem();
  }

  BarItem.prototype.createSpanWithClass = function(content, className) {
    var nodeNameEl;
    nodeNameEl = document.createElement("span");
    nodeNameEl.className = className;
    nodeNameEl.innerHTML = content;
    return nodeNameEl;
  };

  BarItem.prototype.hasId = function() {
    return this.modelEl.id !== '';
  };

  BarItem.prototype.id = function() {
    return "#" + this.modelEl.id;
  };

  BarItem.prototype.hasClasses = function() {
    return this.modelEl.className.trim() !== '';
  };

  BarItem.prototype.classList = function() {
    return this.modelEl.className.replace(/(^| )+/g, '.');
  };

  BarItem.prototype.name = function() {
    return this.modelEl.nodeName.toLowerCase();
  };

  BarItem.prototype.createItem = function() {
    this.elem = document.createElement("li");
    this.link = document.createElement("a");
    this.link.className = "dom-selector__button dom-selector__elem";
    this.link.appendChild(this.createSpanWithClass(this.name(), "dom-selector__name"));
    if (this.hasId()) {
      this.link.appendChild(this.createSpanWithClass(this.id(), "dom-selector__id"));
    }
    if (this.hasClasses()) {
      this.link.appendChild(this.createSpanWithClass(this.classList(), "dom-selector__classes"));
    }
    this.link.addEventListener('click', this.newSelectionFromBar);
    this.elem.appendChild(this.link);
    if (this.selected) {
      return this.showSelected();
    }
  };

  BarItem.prototype.newSelectionFromBar = function(ev) {
    ev.stopPropagation();
    return this.bar.newSelectionFromBar(this.modelEl);
  };

  BarItem.prototype.select = function() {
    this.selected = true;
    return this.showSelected();
  };

  BarItem.prototype.unselect = function() {
    this.selected = false;
    return $.removeClass(this.link, 'dom-selector__elem--selected');
  };

  BarItem.prototype.showSelected = function() {
    return $.addClass(this.link, 'dom-selector__elem--selected');
  };

  return BarItem;

})();



},{"./dom-utils.coffee":4}],3:[function(require,module,exports){
var $, Bar, BarItem;

$ = require('./dom-utils.coffee');

BarItem = require('./bar-item.coffee');

module.exports = Bar = (function() {
  function Bar(selectionMode, options) {
    this.selectionMode = selectionMode;
    if (options == null) {
      options = {};
    }
    this.createElement();
    this.barItem = options.barItemConstructor || BarItem;
    this.visible = false;
    this.referencedElems = [];
    this.barElems = [];
  }

  Bar.prototype.createElement = function() {
    this.element = document.createElement("div");
    this.element.className = "dom-selector__bar";
    this.createControls();
    return this.createList();
  };

  Bar.prototype.createControls = function() {
    var content;
    content = {
      ok: "&#10003;",
      cancel: "&#10007;"
    };
    return $.each(['cancel', 'ok'], (function(_this) {
      return function(i, name) {
        var c;
        c = _this["" + name + "Control"] = document.createElement("a");
        c.className = "dom-selector__button dom-selector__control dom-selector__" + name + "-control";
        c.innerHTML = content[name];
        return _this.element.appendChild(c);
      };
    })(this));
  };

  Bar.prototype.createList = function() {
    this.list = document.createElement("ul");
    this.list.className = "dom-selector__list";
    return this.element.appendChild(this.list);
  };

  Bar.prototype.show = function() {
    document.body.appendChild(this.element);
    return this.visible = true;
  };

  Bar.prototype.hide = function() {
    document.body.removeChild(this.element);
    return this.visible = false;
  };

  Bar.prototype.reset = function(newEl) {
    this.referencedElems = [];
    this.barElems = [];
    this.tip = this.selected = newEl;
    this.list.innerHTML = '';
    return this.generateListFrom(newEl);
  };

  Bar.prototype.generateListFrom = function(el, selected) {
    var barElem, barItem;
    if (selected == null) {
      selected = true;
    }
    if (el.parentElement && el.nodeName.toLowerCase() !== 'body') {
      this.generateListFrom(el.parentNode, false);
    }
    barItem = new this.barItem(el, this, selected);
    barElem = barItem.elem;
    this.referencedElems.push(el);
    this.barElems.push(barItem);
    this.selectedBarElem = barItem;
    return this.list.appendChild(barElem);
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
    if (this.selected === newEl) {
      return this.selected = this.selectedBarElem = null;
    } else if ((idx = $.inArray(newEl, this.referencedElems)) >= 0) {
      this.selectedBarElem = this.barElems[idx];
      this.selectedBarElem.select();
      return this.selected = newEl;
    } else {
      return this.reset(newEl);
    }
  };

  return Bar;

})();



},{"./bar-item.coffee":2,"./dom-utils.coffee":4}],4:[function(require,module,exports){
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
var $, Bar, SelectionMode,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$ = require('./dom-utils.coffee');

Bar = require('./bar.coffee');

module.exports = SelectionMode = (function() {
  function SelectionMode() {
    this.selectDom = __bind(this.selectDom, this);
    this.selected = null;
    this.selectedClass = 'dom-selector__selected';
    this.bar = new Bar(this);
    this.started = false;
  }

  SelectionMode.prototype.start = function() {
    document.body.addEventListener('click', this.selectDom);
    this.showSelection();
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

  SelectionMode.prototype.toggle = function() {
    if (this.started) {
      return this.stop();
    } else {
      return this.start();
    }
  };

  SelectionMode.prototype.selectDom = function(ev) {
    ev.stopPropagation();
    if ($.hasParent(ev.target, this.bar.element) || ev.target === this.bar.element) {
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



},{"./bar.coffee":3,"./dom-utils.coffee":4}]},{},[1]);