SelectionRenderer = require('./renderers/selection')

module.exports = class Selection
  constructor: (@selectionMode) ->

  toggle: (el) ->
    old = @selected
    @unselect() if @selected
    @select(el) unless @old == el

  select: (element) ->
    @renderer = new SelectionRenderer(element)
    @renderer.show()
    @selected = element

  unselect: ->
    @renderer.hide()
    @selected = null
    @renderer = null

  show: ->
    @renderer?.show()

  hide: ->
    @renderer?.hide()

