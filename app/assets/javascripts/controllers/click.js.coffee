$.Controller "Click",
  init: ->
    console.log("wefwefw")
    @init_validation()
    @error_owl = @element.find(".owl.error")
    @success_popup = $("#success_popup")
  open: ->
    @element.show()
    $('html, body').scrollTop(@element.find(".form-block").offset().top);
  close: ->
    @error_owl.hide()
    @element.find("form")[0].reset()
    @element.hide()
  init_validation: ->
    self = @
    @element.find("form").each (idx,form) ->
      $(form).validate
        ignore: ""
        highlight: (el, e_cls) ->
          $(el).addClass e_cls
        unhighlight: (el, e_cls) ->
          $(el).removeClass e_cls
        onkeyup: false
        onfocusout: false
        focusCleanup: true
        focusInvalid: false
        minlength: 3

  "#modal-form submit -> click": (ev) ->
    ev.preventDefault();
    form = $(ev.target).parents("form")
    if form.valid()
      @submit_form( form )
    else

  ".close -> click": (ev) ->
    ev.preventDefault();
    @close()

  show_success_owl: ->
    self = @
    self.success_popup.show()
    setTimeout (->
      self.success_popup.hide()
      return
    ), 2000

  submit_form:(form) ->
    self = @
    $.ajax
      type: "POST"
      url: form.attr("action")
      data: form.serialize()
      success: (resp) ->
        if resp.success
          self.close()
          self.show_success_owl()
      error: (resp) ->

