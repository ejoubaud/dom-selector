(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){

/*

dom-selector
https://github.com/ejoubaud/dom-selector

Copyright (c) 2014 Emmanuel Joubaud
Licensed under the MIT license.
 */
'use strict';
var $, Bar, BarItem, SelectionMode, addClass, domSelector, hasParent, removeClass,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$ = $ || function(sel) {
  return document.querySelectorAll.call(document, sel);
};

$.each = $.each || function(array, iterator) {
  return Array.prototype.forEach.call(array, function(idx, elem) {
    return iterator.call(array, elem, idx);
  });
};

$.inArray = $.inArray || function(val, array, idx) {
  return Array.prototype.indexOf.call(array, val, idx);
};

removeClass = function(el, clazz) {
  var regex;
  regex = new RegExp("(^| )" + clazz + '($| )', 'g');
  return el.className = el.className.replace(regex, '');
};

addClass = function(el, clazz) {
  return el.className += ' ' + clazz;
};

hasParent = function(el, potentialParent) {
  if (el.parentNode) {
    return el.parentNode === potentialParent || hasParent(el.parentNode, potentialParent);
  } else {
    return false;
  }
};

Bar = (function() {
  function Bar(selectionMode, options) {
    var barClass, listClass;
    this.selectionMode = selectionMode;
    if (options == null) {
      options = {};
    }
    barClass = options.barClass || 'dom-selector__bar';
    listClass = options.listClass || 'dom-selector__list';
    this.createElement(barClass, listClass);
    this.activeClass = barClass + '--active';
    this.barItem = options.barItemConstructor || BarItem;
    this.visible = false;
    this.referencedElems = [];
    this.barElems = [];
  }

  Bar.prototype.createElement = function(barClass, listClass) {
    this.element = document.createElement("div");
    addClass(this.element, barClass);
    this.list = document.createElement("ul");
    addClass(this.list, listClass);
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

BarItem = (function() {
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
    this.elem.className = "dom-selector__elem";
    this.elem.appendChild(this.createSpanWithClass(this.name(), "dom-selector__name"));
    if (this.hasId()) {
      this.elem.appendChild(this.createSpanWithClass(this.id(), "dom-selector__id"));
    }
    if (this.hasClasses()) {
      this.elem.appendChild(this.createSpanWithClass(this.classList(), "dom-selector__classes"));
    }
    this.elem.addEventListener('click', this.newSelectionFromBar);
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
    return removeClass(this.elem, 'dom-selector__selected');
  };

  BarItem.prototype.showSelected = function() {
    return addClass(this.elem, 'dom-selector__selected');
  };

  return BarItem;

})();

SelectionMode = (function() {
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
    if (hasParent(ev.target, this.bar.element)) {
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
      return removeClass(this.selected, this.selectedClass);
    }
  };

  SelectionMode.prototype.showSelection = function() {
    if (this.selected) {
      return addClass(this.selected, this.selectedClass);
    }
  };

  return SelectionMode;

})();

domSelector = new SelectionMode();

if (typeof exports === 'undefined') {
  window.domSelector = domSelector;
} else {
  exports.modules = domSelector;
}



},{}]},{},[1]);