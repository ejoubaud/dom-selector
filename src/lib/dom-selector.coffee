###

dom-selector
https://github.com/ejoubaud/dom-selector

Copyright (c) 2014 Emmanuel Joubaud
Licensed under the MIT license.

###

'use strict'

# jQuery can make up for browsers not supporting required ES5 features (forEach, querySelectorAll),
# but is not needed for IE9+ compatibility
$ = $ || (sel) -> document.querySelectorAll.call(document, sel)
$.each = $.each || (array, iterator) -> Array.prototype.forEach.call(array, (idx, elem) -> iterator.call(array, elem, idx))
$.inArray = $.inArray || (val, array, idx) -> Array.prototype.indexOf.call(array, val, idx)

removeClass = (el, clazz) ->
  regex = new RegExp("(^| )" + clazz + '($| )', 'g')
  el.className = el.className.replace(regex, '')
addClass = (el, clazz) -> el.className += ' ' + clazz
hasParent = (el, potentialParent) -> if el.parentNode then el.parentNode == potentialParent || hasParent(el.parentNode, potentialParent) else false

class Bar
  constructor: (@selectionMode, options = {}) ->
    barClass = options.barClass || 'dom-selector__bar'
    listClass = options.listClass || 'dom-selector__list'
    @createElement(barClass, listClass)
    @activeClass = barClass + '--active'
    @barItem = options.barItemConstructor || BarItem
    @visible = false
    @referencedElems = []
    @barElems = []
  createElement: (barClass, listClass) ->
    @element = document.createElement("div")
    addClass(@element, barClass)
    @list = document.createElement("ul")
    addClass(@list, listClass)
    @element.appendChild(@list)
  show: ->
    document.body.appendChild(@element)
    @visible = true
  hide: ->
    document.body.removeChild(@element)
    @visible = false
  reset: (newEl) ->
    @referencedElems = []
    @barElems = []
    @tip = @selected = newEl
    @list.innerHTML = ''
    @generateListFrom(newEl)
  generateListFrom: (el, selected = true) ->
    if el.parentElement && el.nodeName.toLowerCase() != 'body'
      @generateListFrom(el.parentNode, false)
    barItem = new @barItem(el, this, selected)
    barElem = barItem.elem
    @referencedElems.push(el)
    @barElems.push(barItem)
    @selectedBarElem = barItem
    @list.appendChild(barElem)
  newSelectionFromBar: (bodyEl) ->
    @selectionMode.newSelection(bodyEl)
    @newSelection(bodyEl)
  newSelection: (newEl) ->
    @selectedBarElem.unselect() if @selectedBarElem
    if @selected == newEl
      @selected = @selectedBarElem = null
    else if (idx = $.inArray(newEl, @referencedElems)) >= 0
      @selectedBarElem = @barElems[idx]
      @selectedBarElem.select()
      @selected = newEl
    else
      @reset(newEl)

class BarItem
  constructor: (@modelEl, @bar, @selected = false) ->
    @createItem()
  createSpanWithClass: (content, className) ->
    nodeNameEl = document.createElement("span")
    nodeNameEl.className = className
    nodeNameEl.innerHTML = content
    nodeNameEl
  hasId: ->
    @modelEl.id != ''
  id: ->
    "##{@modelEl.id}"
  hasClasses: ->
    @modelEl.className.trim() != ''
  classList: ->
    @modelEl.className.replace(/(^| )+/g, '.')
  name: ->
    @modelEl.nodeName.toLowerCase()
  createItem: ->
    @elem = document.createElement("li")
    @elem.className = "dom-selector__elem"
    @elem.appendChild(@createSpanWithClass(@name(), "dom-selector__name"))
    @elem.appendChild(@createSpanWithClass(@id(), "dom-selector__id")) if @hasId()
    @elem.appendChild(@createSpanWithClass(@classList(), "dom-selector__classes")) if @hasClasses()
    @elem.addEventListener('click', @newSelectionFromBar)
    @showSelected() if @selected
  newSelectionFromBar: (ev) =>
    ev.stopPropagation()
    @bar.newSelectionFromBar(@modelEl)
  select: ->
    @selected = true
    @showSelected()
  unselect: ->
    @selected = false
    removeClass(@elem, 'dom-selector__selected')
  showSelected: ->
    addClass(@elem, 'dom-selector__selected')

class SelectionMode
  constructor: ->
    @selected = null
    @selectedClass = 'dom-selector__selected'
    @bar = new Bar(this)
    @started = false
  start: ->
    document.body.addEventListener('click', @selectDom)
    @showSelection()
    @bar.show() if @bar.selected
    @started = true
  stop: ->
    document.body.removeEventListener('click', @selectDom)
    @hideSelection()
    @bar.hide()
    @started = false
  toggle: ->
    if @started then @stop() else @start()
  selectDom: (ev) =>
    ev.stopPropagation()
    return false if hasParent(ev.target, @bar.element)
    @bar.newSelection(ev.target)
    @bar.show() unless @bar.visible
    @newSelection(ev.target)
  newSelection: (newEl) ->
    @hideSelection()
    if @selected == newEl
      @selected = null
    else
      @selected = newEl
      @showSelection()
  hideSelection: ->
    removeClass(@selected, @selectedClass) if @selected
  showSelection: ->
    addClass(@selected, @selectedClass) if @selected

domSelector = new SelectionMode()
if typeof exports == 'undefined'
  window.domSelector = domSelector
else
  exports.modules = domSelector
