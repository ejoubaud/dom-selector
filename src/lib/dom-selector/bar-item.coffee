BarItemRenderer = require('./renderers/bar-item')

module.exports = class BarItem
  constructor: (@modelEl, @bar, @selection, @barItemSelection, @hover, @barHover) ->
    @renderer = new BarItemRenderer(modelEl)
    @renderer.addListeners(@clickHandler, @hoverHandler, @unhoverHandler)
    @elem = @renderer.elem

  clickHandler: (ev) =>
    ev.stopPropagation()
    @selection.toggle(@modelEl)
    @bar.update()

  hoverHandler: =>
    @hover.toggle(@modelEl)
    @hoverize()

  unhoverHandler: =>
    @hover.unselect()
    @barHover.unselect()

  select: ->
    @barItemSelection.toggle(@renderer.link)

  unselect: ->
    @barItemSelection.unselect()

  hoverize: ->
    @barHover.toggle(@renderer.link)
