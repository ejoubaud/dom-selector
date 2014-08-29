$ = require('../dom-utils')

module.exports = class BarItemRenderer
  constructor: (@modelEl, selected = false) ->
    @createItem(selected)

  createItem: (selected) ->
    @elem = document.createElement("li")
    @link = document.createElement("a")
    @link.className = "dom-selector__button dom-selector__elem"
    @link.appendChild(@_createSpanWithClass(@_name(), "dom-selector__name"))
    @link.appendChild(@_createSpanWithClass(@_id(), "dom-selector__id")) if @_hasId()
    @link.appendChild(@_createSpanWithClass(@_classList(), "dom-selector__classes")) if @_hasClasses()
    @elem.appendChild(@link)
    @select() if selected

  addClickListener: (listener) ->
    @link.addEventListener('click', listener)

  select: ->
    $.addClass(@link, 'dom-selector__elem--selected')

  unselect: ->
    $.removeClass(@link, 'dom-selector__elem--selected')

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