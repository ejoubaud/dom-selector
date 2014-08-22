$ = require('./dom-utils.coffee')
Bar = require('./bar.coffee')

module.exports = class SelectionMode
  constructor: ->
    @selected = null
    @selectedClass = 'dom-selector__selected'
    @bar = new Bar(this)
    @started = false
  start: ->
    document.body.addEventListener('click', @selectDom)
    @showSelection()
    @bar.show() if @bar.selected
    @started = true
  stop: ->
    document.body.removeEventListener('click', @selectDom)
    @hideSelection()
    @bar.hide()
    @started = false
  toggle: ->
    if @started then @stop() else @start()
  selectDom: (ev) =>
    ev.stopPropagation()
    return false if $.hasParent(ev.target, @bar.element) || ev.target == @bar.element
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
