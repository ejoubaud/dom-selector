$ = require('./dom-utils.coffee')
BarItem = require('./bar-item.coffee')

module.exports = class Bar
  constructor: (@selectionMode) ->
    @createElement()
    @visible = false
    @referencedElems = []
    @barElems = []
  createElement: ->
    @element = document.createElement("div")
    @element.className = "dom-selector__bar"
    @createControls()
    @createList()
  createControls: ->
    content = ok: "&#10003;", cancel: "&#10007;"
    $.each ['cancel', 'ok'], (i, name) =>
      c = @["#{name}Control"] = document.createElement("a")
      c.className = "dom-selector__button dom-selector__control dom-selector__#{name}-control"
      c.innerHTML = content[name]
      @element.appendChild(c)
    @disableOkControl()
    @cancelControl.addEventListener('click', @cancel)
  createList: ->
    @list = document.createElement("ul")
    @list.className = "dom-selector__list"
    @element.appendChild(@list)
  enableOkControl: ->
    $.removeClass(@okControl, 'dom-selector__ok-control--disabled')
    @okControl.addEventListener('click', @ok)
  disableOkControl: ->
    $.addClass(@okControl, 'dom-selector__ok-control--disabled')
    @okControl.removeEventListener('click', @ok)
  cancel: =>
    @selectionMode.stop()
  ok: =>
    @selectionMode.stop()
    @successCallback?(@selected)
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
    barItem = new BarItem(el, this, selected)
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
    @enableOkControl() unless @selected
    if @selected == newEl
      @selected = @selectedBarElem = null
      @disableOkControl()
    else if (idx = $.inArray(newEl, @referencedElems)) >= 0
      @selectedBarElem = @barElems[idx]
      @selectedBarElem.select()
      @selected = newEl
    else
      @reset(newEl)
