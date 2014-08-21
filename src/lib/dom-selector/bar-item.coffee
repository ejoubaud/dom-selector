$ = require('./dom-utils.coffee')

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
    $.removeClass(@elem, 'dom-selector__selected')
  showSelected: ->
    $.addClass(@elem, 'dom-selector__selected')
