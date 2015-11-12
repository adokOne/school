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
    console.log(ev)
    ev.preventDefault();
    form = $(ev.target).parents("form")
    if form.valid()
      form.submit()
    else

