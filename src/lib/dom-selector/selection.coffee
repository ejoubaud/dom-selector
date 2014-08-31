ClassRenderer = require('./renderers/class')

module.exports = class Selection
  constructor: (@className) ->

  toggle: (el) ->
    old = @selected
    @unselect()
    @select(el) unless old == el

  select: (element) ->
    @renderer = new ClassRenderer(element, @className)
    @renderer.show()
    @selected = element

  unselect: ->
    if @selected
      @renderer.hide()
      @selected = null
      @renderer = null

  show: ->
    @renderer?.show()

  hide: ->
    @renderer?.hide()

