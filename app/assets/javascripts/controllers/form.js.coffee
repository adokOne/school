$.Controller "Form",
  init: ->
    @init_validation()
    @error_owl = @element.find(".owl.error")
    @success_popup = $("#success_popup").controller()
    @type = @element.data("type")
  open: ->
    @element.show()
    $('html, body').scrollTop(@element.find(".form-block").offset().top);
  close: ->
    @error_owl.hide()
    form = @element.find("form")[0]
    if form
      form.reset()
    @element.hide()
  init_validation: ->
    self = @
    @element.find("form").each (idx,form) ->
      $(form).validate
        debug: true
        ignore: ""
        highlight: (el, e_cls) ->
          self.error_owl.removeClass("hidden")
          if $(el).parents(".new_survey_attempt").size() > 0
            $(el).addClass e_cls
            unless self.scroller
              self.scroller = true
              $('html, body').animate
                  scrollTop: $(".error:first").offset().top
              , 2000
          if $(el).parents(".table").size() > 0
            $(el).parents(".table").find("p").addClass e_cls
        unhighlight: (el, e_cls) ->
          if $(el).parents(".new_survey_attempt").size() > 0
            $(el).removeClass e_cls
          if $(el).parents(".table").size() > 0
            $(el).parents(".table").find("p").removeClass e_cls

        errorPlacement: (err, el) ->
          self.error_owl.removeClass("hidden")

        invalidHandler: (event, validator) ->
          self.error_owl.removeClass("hidden")

        onkeyup:  ->
          self.error_owl.addClass("hidden")
        onfocusout: false
        focusCleanup: true
        focusInvalid: false
        minlength: 3



  ".close -> click": (ev) ->
    ev.preventDefault();
    @close()

  ".js-submit-with-file -> click": (ev) ->
    self = @
    ev.preventDefault()
    form = $(ev.target).parents("form")
    if form.valid()
      formData = new FormData(form[0])
      $.ajax
        url: form.attr("action")
        type: 'POST'
        success: (resp) ->
          if resp.success
            self.close()
            self.show_success_owl()
        error: (resp) ->
          console.log(resp)
        data: formData
        cache: false
        contentType: false
        processData: false

  ".js-submit -> click": (ev) ->
    ev.preventDefault();
    @scroller = false
    form = $(ev.target).parents("form")
    if form.valid()
      if $(ev.target).hasClass("not-ajax")
        form[0].submit()
      else
        @submit_form( form )

  ".show-cv-form -> click": (ev) ->
    ev.preventDefault();
    @close()
    @cv_form = $("#vavancy_subscribe_popup").controller()
    @cv_form.open()

  show_success_owl: ->
    self = @
    html= I18n["#{@type}_reg"]
    self.success_popup.element.find(".bobble").html(html)
    self.success_popup.open()
    $('html, body').scrollTop($("#success_popup").find(".form-block").offset().top - 200);
    # setTimeout (->
    #   self.success_popup.hide()
    #   return
    # ), 2000

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
