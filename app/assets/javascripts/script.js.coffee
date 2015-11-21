$.fn.cycle.defaults.autoSelector = "cycle-slideshow"
Object.values = (obj) ->
  vals = []
  for key of obj
    vals.push obj[key]  if obj.hasOwnProperty(key)
  vals
window.init_selectbox = (elements) ->
  elements.selectbox
    onOpen: (e) ->
      selector = e.settings.classSelector
      e.input.next().find("." + selector).addClass "white"
    onClose: (e) ->
      selector = e.settings.classSelector
      e.input.next().find("." + selector).removeClass "white"

window.init_icheck = (element) ->
  # input[type="radio"],
  element.find('input[type="checkbox"]').iCheck('destroy').iCheck(
    cursor: true
    checkboxClass: 'icheckbox_minimal'
    radioClass: 'iradio_minimal'
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



$(document).ready ->
  $('.cycle-slideshow').cycle slides: '.s-item'
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
    $('body').animate { scrollTop: $(el).offset().top - 50 }, 1500
    false
  $('.burger').click ->
    $(this).toggleClass('active').next('.open-menu').slideToggle()
    false

  $(document).scroll ->
    if $('.burger').hasClass("active")
      $('.burger').toggleClass('active').next('.open-menu').slideToggle()

  $(document).click (e) ->
    target = e.target
    if $(target).hasClass('ui-corner-all') or $(target).parent().hasClass('ui-corner-all')
      return
    if !$(target).hasClass('hasDatepicker') && !$(target).parents('.ui-datepicker').size() && $('#ui-datepicker-div').is(':visible')
      $('.hasDatepicker').datepicker 'hide'
    return


  # #Firefox
  # $(document).bind 'DOMMouseScroll', (e) ->
  #   if e.originalEvent.detail > 0
  #     if $('.burger').hasClass("active")
  #       $('.burger').toggleClass('active').next('.open-menu').slideToggle()
  #   else
  #     #scroll up
  #   #prevent page fom scrolling

  # #IE, Opera, Safari
  # $(document).bind 'mousewheel', (e) ->
  #   if e.originalEvent.wheelDelta < 0
  #     if $('.burger').hasClass("active")
  #       $('.burger').toggleClass('active').next('.open-menu').slideToggle()
  #   else
  #     #scroll up



