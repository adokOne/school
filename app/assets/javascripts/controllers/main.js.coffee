$.Controller "Main",
  init: ->
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
    self = @
    @calendar = @element.find('#calendar').calendario(
      onDayClick: ($el, $contentEl, dateProperties) ->
        for key of dateProperties
          console.log key + ' = ' + dateProperties[key]
        return
      caldata: self.lessons
      weeks: I18n.weeks
      weekabbrs: I18n.weekabbrs
      months: I18n.months
      monthabbrs: I18n.monthabbrs
    )
    @month = @element.find('#custom-month').html(@calendar.getMonthName())

  updateMonthYear: ->
    @month.html @calendar.getMonthName()

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
    $('html, body').scrollTop $('.course-description').offset().top

  "#blog_subscribe -> click": (ev) ->
    ev.preventDefault()
    @blog_subscribe = $("#blog_subscribe_popup").controller()
    @blog_subscribe.open()

  ".vacancy_subscribe -> click": (ev) ->
    ev.preventDefault()
    @blog_subscribe = $("#vavancy_subscribe_popup").controller()
    @blog_subscribe.open()
