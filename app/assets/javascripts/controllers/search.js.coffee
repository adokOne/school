$.Controller "Search",
  init: ->

  ".js-submit -> click": (ev) ->
    ev.preventDefault();
    form = $(ev.target).parents("form")
    if form.valid()
      @submit_form( form )
    else

  submit_form:(form) ->
    self = @
    $.ajax
      type: "POST"
      url: form.attr("action")
      data: form.serialize()
      success: (resp) ->
        if resp.success
          window.location.href = resp.url
      error: (resp) ->

