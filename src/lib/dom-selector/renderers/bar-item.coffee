$ = require('../dom-utils')

module.exports = class BarItemRenderer
  constructor: (@modelEl, selected = false) ->
    @_createItem(selected)

  addClickListener: (listener) ->
    @link.addEventListener('click', listener)

  select: ->
    $.addClass(@link, 'dom-selector__elem--selected')

  unselect: ->
    $.removeClass(@link, 'dom-selector__elem--selected')

  _createItem: (selected) ->
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
    @select() if selected

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