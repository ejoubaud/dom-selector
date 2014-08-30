$ = require('./dom-utils')
Bar = require('./bar')
Selection = require('./selection')

module.exports = class SelectionMode
  constructor: ->
    @selection = new Selection(this)
    @bar = new Bar(this, @selection)
    @started = false

  start: (successCallback) ->
    document.body.addEventListener('click', @selectDom, true)
    document.body.addEventListener('mouseover', @hover, true)
    document.body.addEventListener('mouseout', @unhover, true)
    @selection.show()
    @bar.successCallback = successCallback
    @bar.show() if @bar.selected
    @started = true

  stop: ->
    document.body.removeEventListener('click', @selectDom, true)
    document.body.removeEventListener('mouseover', @hover, true)
    document.body.removeEventListener('mouseout', @unhover, true)
    @selection.hide()
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
    @selection.toggle(ev.target)

  hover: (ev) =>
    return true if @bar.holdsElement(ev.target)
    @removeHoverClass(@hovered) if @hovered
    @hovered = ev.target
    $.addClass(@hovered, 'dom-selector__hovered')

  unhover: (ev) =>
    @removeHoverClass(ev.target)

  removeHoverClass: (el) ->
    $.removeClass(el, 'dom-selector__hovered')
