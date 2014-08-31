BarItemRenderer = require('./renderers/bar-item')

module.exports = class BarItem
  constructor: (@modelEl, @bar, @selection, @barItemSelection) ->
    @renderer = new BarItemRenderer(modelEl)
    @renderer.addClickListener(@clickHandler)
    @elem = @renderer.elem

  clickHandler: (ev) =>
    ev.stopPropagation()
    @selection.toggle(@modelEl)
    @bar.update()

  select: ->
    @barItemSelection.toggle(@renderer.link)

  unselect: ->
    @barItemSelection.unselect()
