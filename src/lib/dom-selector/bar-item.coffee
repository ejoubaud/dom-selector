BarItemRenderer = require('./renderers/bar-item')

module.exports = class BarItem
  constructor: (@modelEl, @bar, @selection) ->
    @renderer = new BarItemRenderer(modelEl)
    @renderer.addClickListener(@newSelectionFromBar)
    @elem = @renderer.link

  newSelectionFromBar: (ev) =>
    ev.stopPropagation()
    @bar.newSelectionFromBar(@modelEl)

  select: ->
    @selection.toggle(@elem)

  unselect: ->
    @selection.unselect()
