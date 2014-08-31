$ = require('../dom-utils')

module.exports = class BarItemRenderer
  constructor: (@modelEl, selected = false) ->
    @_createItem()

  addClickListener: (listener) ->
    @link.addEventListener('click', listener)

  _createItem: ->
    @elem = document.createElement("li")
    @link = document.createElement("a")
    @link.className = "dom-selector__button dom-selector__elem"
    @textWrap = document.createElement("span")
    @textWrap.className = "dom-selector__elem__text-wrapper"
    @textWrap.appendChild(@_createSpan(@_name(), "dom-selector__name"))
    if @_hasId()
      @textWrap.appendChild(@_createSpan(@_id(), "dom-selector__id"))
    if @_hasClasses()
      @textWrap.appendChild(@_createSpan(@_classes(), "dom-selector__classes"))
    @link.appendChild(@textWrap)
    @elem.appendChild(@link)

  _createSpan: (content, className) ->
    nodeNameEl = document.createElement("span")
    nodeNameEl.className = className
    nodeNameEl.innerHTML = content
    nodeNameEl

  _hasId: ->
    @modelEl.id != ''

  _id: ->
    "##{@modelEl.id}"

  _hasClasses: ->
    @modelEl.className.trim() != ''

  _classes: ->
    @modelEl.className.replace(/(^| )+/g, '.')

  _name: ->
    @modelEl.nodeName.toLowerCase()