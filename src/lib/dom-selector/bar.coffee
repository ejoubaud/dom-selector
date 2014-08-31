$ = require('./dom-utils')
BarItem = require('./bar-item')
BarRenderer = require('./renderers/bar')
Selection = require('./selection')

module.exports = class Bar
  constructor: (@selectionMode, @bodySelection) ->
    @barSelection = new Selection('dom-selector__elem--selected')
    @renderer = new BarRenderer(@ok, @cancel)
    @visible = false
    @_resetArrays()

  show: ->
    @renderer.show()
    @visible = true

  hide: ->
    @renderer.hide()
    @visible = false

  newSelectionFromBar: (bodyEl) ->
    @bodySelection.toggle(bodyEl)
    @update()

  update: ->
    @selectedBarElem?.unselect()
    if @bodySelection.selected
      @_select()
    else
      @_unselect()

  holdsElement: (el) ->
    @renderer.holdsElement(el)

  _reset: ->
    @tip = @bodySelection.selected
    @_resetArrays()
    @_generateList(@bodySelection.selected)
    @renderer.reset(@barElems)

  _select: ->
    @renderer.enableOkControl()
    if (barItem = @_barElemIfShownAlready())
      @_highlight(barItem)
    else
      @_reset()

  _unselect: ->
    @selectedBarElem = null
    @renderer.disableOkControl()

  _highlight: (newSelectedBarItem) ->
    @selectedBarElem.unselect()
    @selectedBarElem = newSelectedBarItem
    @selectedBarElem.select()

  _barElemIfShownAlready: ->
    idx = $.inArray(@bodySelection.selected, @referencedElems)
    if idx >= 0 then @barElems[idx] else null

  cancel: =>
    @selectionMode.stop()

  ok: =>
    @selectionMode.stop()
    @successCallback?(@bodySelection.selected)

  _generateList: (el) ->
    if el.parentElement && el.nodeName.toLowerCase() != 'body'
      @_generateList(el.parentNode)
    barItem = new BarItem(el, this, @barSelection)
    barItem.select() if @bodySelection.selected == el
    @referencedElems.push(el)
    @barElems.push(barItem)
    @selectedBarElem = barItem

  _resetArrays: ->
    @referencedElems = []
    @barElems = []

