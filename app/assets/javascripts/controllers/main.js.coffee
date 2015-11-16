$.Controller "Main",
  init: ->
    @is_blog = @element.find(".search-block").size() > 0
    @lessons = if typeof lessons == "undefined" then {} else lessons
    @init_slideshow();
    @init_calendar();


  init_slideshow: ->
    @element.find('.cycle-slideshow').cycle slides: '.s-item'
    @element.find('.image-link').magnificPopup
      type: 'image'
      showCloseBtn: false
      gallery:
        enabled: true
        navigateByImgClick: true

  init_calendar: ->
    return if @is_blog
    lessons = {}
    Object.keys(@lessons).map((key) ->
      $.extend(lessons,@lessons[key])
    )
    @calendar = @element.find('#calendar').calendario(
      onDayClick: ($el, $contentEl, dateProperties) ->
        lesson = $el.find(".lesson_box")
        if lesson.size()
          id = lesson.data("course-id")
      caldata: lessons
      weeks: I18n.weeks
      weekabbrs: I18n.weekabbrs
      months: I18n.months
      monthabbrs: I18n.monthabbrs
    )
    @month = @element.find('#custom-month').html(@calendar.getMonthName())

  updateMonthYear: ->
    @month.html @calendar.getMonthName()

  updateCourse: (id) ->
    el = @element.find("#course")
    el.selectbox("detach")
    el.val(id)
    el.change()
    el.selectbox("attach")

  '#custom-next -> click': (ev) ->
    ev.preventDefault()
    @calendar.gotoNextMonth @updateMonthYear

  '#custom-prev -> click': (ev) ->
    ev.preventDefault()
    @calendar.gotoPreviousMonth @updateMonthYear

  '#custom-current -> click': (ev) ->
    ev.preventDefault()
    @calendar.gotoNow @updateMonthYear

  ".courses-list a -> click": (ev) ->
    ev.preventDefault()
    @element.find('.course-description').show()
    $('html, body').animate({scrollTop: $('.course-description').offset().top}, 800);

    idx = 0
    @element.find('.cycle-slideshow').cycle(idx);


  "#blog_subscribe -> click": (ev) ->
    ev.preventDefault()
    @blog_subscribe = $("#blog_subscribe_popup").controller()
    @blog_subscribe.open()

  ".vacancy_subscribe -> click": (ev) ->
    ev.preventDefault()
    @blog_subscribe = $("#vavancy_subscribe_popup").controller()
    @blog_subscribe.open()

  ".course_subscribe -> click": (ev) ->
    id = $(ev.target).data("id")
    id = if typeof id == "undefined" then 0 else Number(id)
    ev.preventDefault()
    @course_subscribe = $("#lesson_subscribe_popup").controller()
    @course_subscribe.open()
    @course_subscribe.element.find("#subscriber_course_id").val(id).change()


  "a.schedule -> click": (ev) ->
    ev.preventDefault()
    id = $(ev.target).data("id")
    @updateCourse(id)
    @calendar.gotoNow @updateMonthYear

  ".course-description .close -> click": (ev) ->
    ev.preventDefault()
    @element.find('.course-description').hide()
    $('html, body').animate({scrollTop: $('.courses-block').offset().top}, 800);


  "#course -> change": (ev) ->
    id = $(ev.target).val()
    if 0 == Number(id)
      data = {}
      Object.keys(@lessons).map((key) ->
        $.extend(data,@lessons[key])
      )
    else
      data = @lessons[id]
      data = if data then data else {}
    @calendar.setData(data,data)

