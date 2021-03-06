$.Controller "Blog",
  init: ->

    @init_validation()
    @init_photo_category()
  init_photo_category: ->
    @element.find('.image-link').magnificPopup
      type: 'image'
      showCloseBtn: false
      gallery:
        enabled: true
        navigateByImgClick: true
  init_validation: ->
    @element.find("form").each (idx,form) ->
      $(form).validate
        ignore: ""
        highlight: (el, e_cls) ->
          $(el).addClass e_cls
        unhighlight: (el, e_cls) ->
          $(el).removeClass e_cls
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
      if $(ev.target).hasClass("not-ajax")
        form[0].submit()
      else
        @submit_form( form )

  show_success_owl: ->
    @success_popup = $("#success_popup").controller()
    self = @
    html= I18n.blog_reg
    self.success_popup.element.find(".bobble").html(html)
    self.success_popup.open()
    $('html, body').scrollTop self.success_popup.element.find(".form-block").offset().top

  submit_form:(form) ->
    self = @
    $.ajax
      type: "POST"
      url: form.attr("action")
      data: form.serialize()
      success: (resp) ->
        if resp.success
          self.show_success_owl()
      error: (resp) ->
