$.Controller "Main",
  init: ->
    @curse_dates = []
    @is_blog = @element.find(".calendar-block").size() < 1
    @lessons = if typeof lessons == "undefined" then {} else lessons
    @init_slideshow();
    @init_calendar();
    @init_datepicker()
    @selected_course_id = 0;


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
    el = $(ev.target)
    el = if el.hasClass("js-link") then el else el.parents(".js-link")
    cls = el.data("cls")
    @element.find('.course-description').show()
    $('html, body').animate({scrollTop: $('.course-description').offset().top}, 800);
    idx = @element.find('.cycle-slideshow .s-item').index(@element.find(".cycle-slideshow .#{cls}"))
    console.log(".cycle-slideshow .#{cls}")
    console.log(idx)
    @element.find('.cycle-slideshow').cycle(idx);


  "#blog_subscribe -> click": (ev) ->
    ev.preventDefault()
    @blog_subscribe = $("#blog_subscribe_popup").controller()
    @blog_subscribe.open()

  ".vacancy_subscribe -> click": (ev) ->
    ev.preventDefault()
    self = @
    $.ajax
      type: "get"
      url: "/show_vacancy"
      data: {id: $(ev.target).data("id")}
      success: (resp) ->
        if resp.success
          $("body").append(resp.html)
          ctrl = $("#vacancy_desc_popup").attachForm().controller()
          ctrl.open()
      error: (resp) ->

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
    $('html, body').animate({scrollTop: $('.calendar-block').offset().top}, 800);

  ".course-description .close -> click": (ev) ->
    ev.preventDefault()
    @element.find('.course-description').hide()
    $('html, body').animate({scrollTop: $('.courses-block').offset().top}, 800);

  ".advertising .close -> click": (ev) ->
    ev.preventDefault()
    @element.find(".advertising").remove()

  ".fc-calendar-event -> click":(ev) ->
    ev.preventDefault();
    el = if $(ev.target).hasClass("fc-calendar-event") then $(ev.target) else $(ev.target).parents(".fc-calendar-event")
    @selected_course_id =  el.find(".lesson_box").data("course-id")
    @curse_dates = Object.keys(@lessons[@selected_course_id])
    date = el.find(".lesson_box").data("date")
    @selected_date = date;
    @course_subscribe = $("#lesson_subscribe_popup").controller()
    @course_subscribe.open()
    $("#subscriber_date").change()
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

  "#group-selector -> change":(ev) ->
    ev.preventDefault()
    id = Number($(ev.target).val())
    @selected_course_id = id
    @element.find("#subscriber_course_id").val(id).change()
    @curse_dates = Object.keys(@lessons[id])
    @element.find('#subscriber_date').datepicker('refresh');

  "#subscriber_date -> change": (ev) ->
    old = @selected_date#$(ev.target).val()
    $(ev.target).val("#{old}, #{courses_names[@selected_course_id]}")

  init_datepicker: ->
    self = @
    dateToday = new Date();
    @element.find('#subscriber_date').datepicker
      dateFormat: 'dd.mm.yy'
      onSelect: (date) ->
        self.selected_date = date
        $("#subscriber_date").change()
        #self.curse_dates = []
      beforeShowDay: (date) ->
        return self.unavailable(date)
      minDate: dateToday,
      onChangeMonthYear: ->
        self.regenerate_datepicker(10)
      beforeShow: ->
        self.regenerate_datepicker(100)



  regenerate_datepicker: (timeout) ->
    self = @
    setTimeout (->
      self.generate_courses_options()
      $('#group-selector').selectbox()
    ), timeout

  generate_courses_options: ->
    $.each courses, (index, obj) ->
      $('#group-selector').append $('<option/>',
        value: obj.id
        text: obj.name)
    $("#group-selector option[value=#{@selected_course_id}]").attr('selected','selected');
    return

  unavailable: (date) ->
    dmy = ("0" + (date.getMonth() + 1)).slice(-2)  + '-' + ("0" + date.getDate()).slice(-2)  + '-' + date.getFullYear()
    if @curse_dates.length != 0 && !($.inArray(dmy, @curse_dates) < 0)
      return [true,"yellow",""]
    else
      return [false,"",""]
