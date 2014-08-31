Bar = require('./bar')
Selection = require('./selection')

module.exports = class SelectionMode
  constructor: ->
    @selection = new Selection('dom-selector__selected')
    @hover = new Selection('dom-selector__hovered')
    @bar = new Bar(this, @selection, @hover)
    @started = false

  start: (successCallback) ->
    document.body.addEventListener('click', @clickHandler, true)
    document.body.addEventListener('mouseover', @hoverHandler, true)
    document.body.addEventListener('mouseout', @unhoverHandler, true)
    @selection.show()
    @bar.successCallback = successCallback
    @bar.show() if @bar.selected
    @started = true

  stop: ->
    document.body.removeEventListener('click', @clickHandler, true)
    document.body.removeEventListener('mouseover', @hoverHandler, true)
    document.body.removeEventListener('mouseout', @unhoverHandler, true)
    @selection.hide()
    @bar.hide()
    @started = false

  toggle: (successCallback) ->
    if @started then @stop() else @start(successCallback)

  clickHandler: (ev) =>
    return true if @bar.holdsElement(ev.target)
    ev.stopPropagation()
    ev.preventDefault()
    @selection.toggle(ev.target)
    @bar.update()
    @bar.show() unless @bar.visible

  hoverHandler: (ev) =>
    return true if @bar.holdsElement(ev.target)
    @hover.toggle(ev.target)
    @bar.updateHover()

  unhoverHandler: =>
    @hover.unselect()
    @bar.updateHover()
