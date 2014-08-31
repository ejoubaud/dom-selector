$ = require('../dom-utils')

module.exports = class ClassRenderer
  constructor: (@el, @class) ->

  show: ->
    $.addClass(@el, @class)

  hide: ->
    $.removeClass(@el, @class)
