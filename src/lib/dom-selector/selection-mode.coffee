$ = require('./dom-utils')
Bar = require('./bar')

module.exports = class SelectionMode
  constructor: ->
    @selected = null
    @selectedClass = 'dom-selector__selected'
    @bar = new Bar(this)
    @started = false

  start: (successCallback) ->
    document.body.addEventListener('click', @selectDom, true)
    document.body.addEventListener('mouseover', @hover, true)
    document.body.addEventListener('mouseout', @unhover, true)
    @showSelection()
    @bar.successCallback = successCallback
    @bar.show() if @bar.selected
    @started = true

  stop: ->
    document.body.removeEventListener('click', @selectDom, true)
    document.body.removeEventListener('mouseover', @hover, true)
    document.body.removeEventListener('mouseout', @unhover, true)
    @hideSelection()
    @bar.hide()
    @started = false

  toggle: (successCallback) ->
    if @started then @stop() else @start(successCallback)

  selectDom: (ev) =>
    return true if @bar.holdsElement(ev.target)
    ev.stopPropagation()
    ev.preventDefault()
    @bar.newSelection(ev.target)
    @bar.show() unless @bar.visible
    @newSelection(ev.target)

  hover: (ev) =>
    return true if @bar.holdsElement(ev.target)
    @removeHoverClass(@hovered) if @hovered
    @hovered = ev.target
    $.addClass(@hovered, 'dom-selector__hovered')

  unhover: (ev) =>
    @removeHoverClass(ev.target)

  removeHoverClass: (el) ->
    $.removeClass(el, 'dom-selector__hovered')

  newSelection: (newEl) ->
    @hideSelection()
    if @selected == newEl
      @selected = null
    else
      @selected = newEl
      @showSelection()

  hideSelection: ->
    $.removeClass(@selected, @selectedClass) if @selected

  showSelection: ->
    $.addClass(@selected, @selectedClass) if @selected
