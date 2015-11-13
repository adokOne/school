$.Controller "Form",
  init: ->
    @init_validation()
    @error_owl = @element.find(".owl.error")
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
          self.error_owl.show()
          #$(el).addClass e_cls
        unhighlight: (el, e_cls) ->
          #$(el).removeClass e_cls
          self.error_owl.hide()
        errorPlacement: (err, el) ->
        onkeyup: false
        onfocusout: false
        focusCleanup: true
        focusInvalid: false
        minlength: 3

  ".js-submit -> click": (ev) ->
    ev.preventDefault();
    form = $(ev.target).parents("form")
    if form.valid()
      form.submit()
    else

  ".close -> click": (ev) ->
    ev.preventDefault();
    @close()
