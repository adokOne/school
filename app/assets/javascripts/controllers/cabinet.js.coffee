$.Controller "Cabinet",
  init: ->
    @error_cls = "error"
    @form = @element.find("form")
    @init_validation()

  "input[type=file] -> change": (ev) ->
    el = $(ev.target)
    window.read_url(ev.target, "##{el.data('img-id')}")

  ".zoomlink -> click": (ev) ->
    ev.preventDefault()
    @element.find("input[type=file]").click()
    @element.find(".image").removeClass "error"

  "select -> change": (ev) ->
    $(ev.target).next().removeClass @error_cls



  ".list-icon -> click": (ev) ->
    ev.preventDefault()
    el = $(ev.target)
    @rebuild_contacts(el, 1)

  rebuild_contacts: (el, add) ->
    add = add || false
    self = @
    if add
      row_clone = el.parent().parent().clone()
      count = @element.find("*[data-type=#{row_clone.data('type')}]").size()
      return if count >= 3
      el.parent().parent().parent().after(row_clone)
      el.parent().parent().parent().next().wrap("<li></li>")
      i = 0
      @element.find(".user-contancts .row").each (idx, el) ->
        $(el).find("input").each ->
          $(this).attr("id", $(this).attr("id").replace(/\d+/, i))
          $(this).attr("name", $(this).attr("name").replace(/\d+/, i))
        i++
  init_validation: ->
    self = @
    @form.each (idx,form) ->
      $(form).validate
        ignore: ""
        highlight: (el, e_cls) ->
          sumernote = $(el).next(".note-editor")
          if $(el).next().hasClass("image")
            $(el).next().addClass e_cls
          if el.tagName == "SELECT"
            $(el).next().addClass e_cls
          if sumernote.size()
            sumernote.addClass e_cls
          else
            $(el).addClass e_cls
        unhighlight: (el, e_cls) ->
          sumernote = $(el).next(".note-editor")
          if sumernote.size()
            sumernote.removeClass e_cls
          else
            $(el).removeClass e_cls
        errorPlacement: (err, el) ->
        onkeyup: false
        onfocusout: false
        focusCleanup: true
        focusInvalid: false
        minlength: 3
