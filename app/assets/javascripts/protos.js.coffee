Array::inArray = (comparer) ->
  i = 0
  while i < @length
    return true  if comparer(this[i])
    i++
  false

Array::pushIfNotExist = (element, comparer) ->
  @push element  unless @inArray(comparer)
  return
Array::max = ->
  Math.max.apply null, this

Array::min = ->
  Math.min.apply null, this
Array::push_or_remove = (elem) ->
  removed = false
  i = @length - 1
  while i >= 0
    if this[i] is elem
      removed = true
      @splice i, 1
    i--
  @push elem  unless removed
  this
Number::between = (a, b) ->
  min = Math.min.apply(Math, [
    a
    b
  ])
  max = Math.max.apply(Math, [
    a
    b
  ])
  this > min and this < max

Array::sum = ->
  sum = 0
  @map (item) ->
    sum += item
    return
  sum
