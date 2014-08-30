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
    @showSelection()
    @bar.successCallback = successCallback
    @bar.show() if @bar.selected
    @started = true

  stop: ->
    document.body.removeEventListener('click', @selectDom, true)
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
