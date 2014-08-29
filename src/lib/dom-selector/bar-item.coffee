$ = require('./dom-utils')

module.exports = class BarItem
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
    @link = document.createElement("a")
    @link.className = "dom-selector__button dom-selector__elem"
    @link.appendChild(@createSpanWithClass(@name(), "dom-selector__name"))
    @link.appendChild(@createSpanWithClass(@id(), "dom-selector__id")) if @hasId()
    @link.appendChild(@createSpanWithClass(@classList(), "dom-selector__classes")) if @hasClasses()
    @link.addEventListener('click', @newSelectionFromBar)
    @elem.appendChild(@link)
    @showSelected() if @selected
  newSelectionFromBar: (ev) =>
    ev.stopPropagation()
    @bar.newSelectionFromBar(@modelEl)
  select: ->
    @selected = true
    @showSelected()
  unselect: ->
    @selected = false
    $.removeClass(@link, 'dom-selector__elem--selected')
  showSelected: ->
    $.addClass(@link, 'dom-selector__elem--selected')
