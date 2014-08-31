$ = require('./dom-utils')
BarItem = require('./bar-item')
BarRenderer = require('./renderers/bar')
Selection = require('./selection')

module.exports = class Bar
  constructor: (@selectionMode, @selection, @hover) ->
    @barItemSelection = new Selection('dom-selector__elem--selected')
    @barHover = new Selection('dom-selector__elem--hovered')
    @renderer = new BarRenderer(@okHandler, @cancelHandler)
    @visible = false
    @_resetArrays()

  show: ->
    @renderer.show()
    @visible = true

  hide: ->
    @renderer.hide()
    @visible = false

  update: ->
    if @selection.selected
      @_select()
    else
      @barItemSelection.unselect()
      @renderer.disableOkControl()

  updateHover: ->
    hoveredEl = @hover.selected
    if hoveredEl && (barItem = @_barElemIfShownAlready(hoveredEl))
      barItem.hoverize()
    else
      @barHover.unselect()

  holdsElement: (el) ->
    @renderer.holdsElement(el)

  _reset: ->
    @tip = @selection.selected
    @_resetArrays()
    @_generateList(@selection.selected)
    @renderer.reset(@barElems)

  _select: ->
    @renderer.enableOkControl()
    if (barItem = @_barElemIfShownAlready(@selection.selected))
      barItem.select()
    else
      @_reset()

  _barElemIfShownAlready: (el) ->
    idx = $.inArray(el, @referencedElems)
    if idx >= 0 then @barElems[idx] else null

  cancelHandler: =>
    @selectionMode.stop()

  okHandler: =>
    @selectionMode.stop()
    @successCallback?(@selection.selected)

  _generateList: (el) ->
    if el.parentElement && el.nodeName.toLowerCase() != 'body'
      @_generateList(el.parentNode)
    barItem = new BarItem(el, this, @selection, @barItemSelection, @hover, @barHover)
    barItem.select() if @selection.selected == el
    @referencedElems.push(el)
    @barElems.push(barItem)

  _resetArrays: ->
    @referencedElems = []
    @barElems = []

