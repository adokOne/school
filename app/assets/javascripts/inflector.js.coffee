window.inflector =
  direct_desc: (translates,count) ->
    count = Number(count)
    key = (if count is 0 then "zero" else (if count < 2 then "one" else (if count < 5 then "few" else "many")))
    return sprintf(translates[key],count)