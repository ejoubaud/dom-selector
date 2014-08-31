ClassRenderer = require('./renderers/class')

module.exports = class Selection
  constructor: (@className) ->

  toggle: (el) ->
    old = @selected
    @unselect() if @selected
    @select(el) unless @old == el

  select: (element) ->
    @renderer = new ClassRenderer(element, @className)
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

