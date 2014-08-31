module.exports =
  # TODO: Add attachEvent / addEventListener shim for IE8

  removeClass: (el, clazz) ->
    regex = new RegExp("(^| )" + clazz + '(?=$| )', 'g')
    el.className = el.className.replace(regex, '')

  addClass: (el, clazz) ->
    el.className += ' ' + clazz

  hasParent: (el, parent) ->
    if el.parentNode
      el.parentNode == parent || @hasParent(el.parentNode, parent)
    else
      false

# jQuery can make up for browsers not supporting required ES5 features
# but is not needed for IE9+ compatibility
if @$ && @$.each && @$.inArray
  module.exports.$ = @$
  module.exports.each = @$.each
  module.exports.inArray = @$.inArray
else
  module.exports.$ = (sel) ->
    document.querySelectorAll.call(document, sel)
  module.exports.each = (array, iterator) ->
    Array.prototype.forEach.call array, (idx, elem) ->
      iterator.call(array, elem, idx)
  module.exports.inArray = (val, array, idx) ->
    Array.prototype.indexOf.call(array, val, idx)
