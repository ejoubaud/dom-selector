Bar = require('./bar')
Selection = require('./selection')

module.exports = class SelectionMode
  constructor: ->
    @selection = new Selection('dom-selector__selected')
    @hover = new Selection('dom-selector__hovered')
    @bar = new Bar(this, @selection)
    @started = false

  start: (successCallback) ->
    document.body.addEventListener('click', @selectDom, true)
    document.body.addEventListener('mouseover', @hoverHandler, true)
    document.body.addEventListener('mouseout', @unhoverHandler, true)
    @selection.show()
    @bar.successCallback = successCallback
    @bar.show() if @bar.selected
    @started = true

  stop: ->
    document.body.removeEventListener('click', @selectDom, true)
    document.body.removeEventListener('mouseover', @hoverHandler, true)
    document.body.removeEventListener('mouseout', @unhoverHandler, true)
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

  hoverHandler: (ev) =>
    return true if @bar.holdsElement(ev.target)
    @hover.unselect()
    @hover.select(ev.target)

  unhoverHandler: =>
    @hover.unselect()
