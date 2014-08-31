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
    @textWrapper = document.createElement("span")
    @textWrapper.className = "dom-selector__elem__text-wrapper"
    @textWrapper.appendChild(@_createSpanWithClass(@_name(), "dom-selector__name"))
    @textWrapper.appendChild(@_createSpanWithClass(@_id(), "dom-selector__id")) if @_hasId()
    @textWrapper.appendChild(@_createSpanWithClass(@_classList(), "dom-selector__classes")) if @_hasClasses()
    @link.appendChild(@textWrapper)
    @elem.appendChild(@link)

  _createSpanWithClass: (content, className) ->
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

  _classList: ->
    @modelEl.className.replace(/(^| )+/g, '.')

  _name: ->
    @modelEl.nodeName.toLowerCase()