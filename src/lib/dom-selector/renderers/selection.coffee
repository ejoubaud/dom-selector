$ = require('../dom-utils')

module.exports = class SelectionRenderer
  constructor: (@el) ->
    @selectedClass = 'dom-selector__selected'

  show: ->
    $.addClass(@el, @selectedClass)

  hide: ->
    $.removeClass(@el, @selectedClass)
