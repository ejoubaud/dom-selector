$ = require('./dom-utils.coffee')
BarItem = require('./bar-item.coffee')

module.exports = class Bar
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
    @element.className = barClass
    @list = document.createElement("ul")
    @list.className = listClass
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
