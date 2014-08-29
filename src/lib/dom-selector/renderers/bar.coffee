$ = require('../dom-utils')

module.exports = class BarRenderer
  constructor: (@successCb, @cancelCb) ->
    @_createElement()
    @_createControls()
    @_createList()

  reset: (@items = []) ->
    @list.innerHTML = ''
    $.each @items, (i, item) =>
      @list.appendChild(item.elem)

  show: ->
    document.body.appendChild(@element)

  hide: ->
    document.body.removeChild(@element)

  enableOkControl: ->
    $.removeClass(@okControl, 'dom-selector__ok-control--disabled')
    @okControl.addEventListener('click', @successCb) if @successCb

  disableOkControl: ->
    $.addClass(@okControl, 'dom-selector__ok-control--disabled')
    @okControl.removeEventListener('click', @successCb) if @successCb

  holdsElement: (el) ->
    el == @element || $.hasParent(el, @element)

  _createElement: ->
    @element = document.createElement("div")
    @element.className = "dom-selector__bar"

  _createList: ->
    @list = document.createElement("ul")
    @list.className = "dom-selector__list"
    @element.appendChild(@list)

  _createControls: ->
    content = ok: "&#10003;", cancel: "&#10007;"
    $.each ['cancel', 'ok'], (i, name) =>
      c = @["#{name}Control"] = document.createElement("a")
      c.className = "dom-selector__button dom-selector__control dom-selector__#{name}-control"
      c.innerHTML = content[name]
      @element.appendChild(c)
    @disableOkControl()
    @cancelControl.addEventListener('click', @cancelCb)
