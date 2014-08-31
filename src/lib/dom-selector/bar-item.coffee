BarItemRenderer = require('./renderers/bar-item')

module.exports = class BarItem
  constructor: (@modelEl, @bar, @selected = false) ->
    @renderer = new BarItemRenderer(modelEl, selected)
    @renderer.addClickListener(@newSelectionFromBar)
    @elem = @renderer.elem

  newSelectionFromBar: (ev) =>
    ev.stopPropagation()
    @bar.newSelectionFromBar(@modelEl)

  select: ->
    @renderer.select()

  unselect: ->
    @renderer.unselect()
