$.Controller "Cabinet",
  init: ->
    @error_cls = "error"
    @form = @element.find("form")
    @init_validation()
    @init_dialog()

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

  "#create_transaction -> click": (ev) ->
    ev.preventDefault()
    @dialog.dialog('open')

  ".comment-reply-link -> click": (ev) ->
    ev.preventDefault()
    @element.find(".comment-form-author").hide()
    @element.find(".comment-form-author input").removeAttr("required")
    @element.find("#message_message_id").val($(ev.target).data("id"))
    $('html, body').animate({scrollTop: $('#respond').offset().top}, 800);


  "#new_transaction input[type=submit] -> click": (ev) ->
    ev.preventDefault()
    self = @
    form = $(ev.target).parents("form")
    $.ajax
      type: "POST"
      url: form.attr("action")
      data: form.serialize()
      success: (resp) ->
        if resp.success
          $("body").append($(resp.form))
          $("form:last").submit()
      error: (resp) ->



  "#create_order -> click": (ev) ->
    ev.preventDefault()
    self = @
    form = $(ev.target).parents("form")
    $.ajax
      type: "POST"
      url: form.attr("action")
      data: form.serialize()
      success: (resp) ->
        if resp.success
          console.log(resp)
      error: (resp) ->


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

  init_dialog: ->
    @dialog = @element.find('#dialog').dialog autoOpen: false
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
