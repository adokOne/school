Object.values = (obj) ->
  vals = []
  for key of obj
    vals.push obj[key]  if obj.hasOwnProperty(key)
  vals
window.init_selectbox = (elements) ->
  elements.selectbox
    onOpen: (e,f) ->
      selector = e.settings.classSelector
      e.input.next().removeClass "error"
      e.input.next().find("." + selector).addClass "white"
    onClose: (e) ->
      selector = e.settings.classSelector
      e.input.next().find("." + selector).removeClass "white"

window.init_icheck = (element) ->
  element.find('input[type="radio"], input[type="checkbox"]').iCheck('destroy').iCheck(
    cursor: true
    checkboxClass: 'icheckbox_square-blue'
    radioClass: 'iradio_square-blue'
  )
  element.find('input[type="radio"], input[type="checkbox"]').on "ifClicked", (ev) ->
    $(ev.target).change()


window.parseQuery = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))

window.toQueryString = (obj) ->
  parts = []
  for i of obj
    parts.push encodeURIComponent(i) + "=" + (obj[i])  if obj.hasOwnProperty(i)
  parts.join "&"
window.get_sizes = ->
  width: (if isNaN(window.innerWidth) then window.clientWidth else window.innerWidth)
  height: (if isNaN(window.innerHeight) then window.clientHeight else window.innerHeight)
window.get_top_offset = ->
  window.pageYOffset || document.documentElement.scrollTop
window.IsNumeric = (input) ->
  (input - 0) is input and ("" + input).replace(/^\s+|\s+$/g, "").length > 0

window.show_msg = (msg) ->
  msg = if typeof(msg) is "string" then msg else msg.join("\n\n")
  alert(msg)


window.read_url = (input, img_selector) ->
  if input.files and input.files[0]
    reader = new FileReader

    reader.onload = (e) ->
      $('img').show()
      $(img_selector).attr 'src', e.target.result
      return

    reader.readAsDataURL input.files[0]

window.htmlDecode = (input) ->
  e = document.createElement('div')
  e.innerHTML = input
  if e.childNodes.length == 0 then '' else e.childNodes[0].nodeValue

$(document).ready ->
  # Enable controllers for elements
  $("*[data-ctrl]").each ->
    controllers = $(this).data("ctrl").split(" ")
    i = 0
    while i < controllers.length
      result = plg.call($(this))  if plg = $(this)["attach" + controllers[i]]
      i++
  window.init_selectbox $("select")
  window.init_icheck $(document)

  $('.open-menu a').click ->
    el = $(this).attr('href')
    $('body').animate { scrollTop: $(el).offset().top }, 1500
    false
  $('.burger').click ->
    $(this).toggleClass('active').next('.open-menu').slideToggle()
    false
  $('#summernote').each ->
    text = $(this).html()
    sumernote = $(this).summernote
      callbacks:
        onFocus: ($editable, sHtml) ->
          $($editable.target).parents(".note-editor").removeClass "error"
          return
    sumernote.data('summernote').code(window.htmlDecode(text))
