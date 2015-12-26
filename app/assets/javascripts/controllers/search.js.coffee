$.Controller "Search",
  init: ->
    self = @
    $(document).click (ev) ->
      if $(ev.target).parents(".sbOptions.cats").size() < 1 &&  $(ev.target).parents(".sbHolder.custom").size() < 1 && $(".sbOptions.cats").is(":visible")
        self.closeSelect( $(".sbOptions.cats:visible").parents(".sbHolder")  )




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

  ".sbHolder.custom .sbSelector, .sbHolder.custom .sbToggle -> click": (ev) ->
    @closeSelect( $(ev.target).parents(".sbHolder") )


  closeSelect: (holder) ->
    el = holder.find(".sbOptions")
    toogle = holder.find(".sbToggle")
    toogle.toggleClass("sbToggleOpen")
    el.slideToggle 100, ->
