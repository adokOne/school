$.Controller "Main",
  init: ->
    @init_slideshow();
    @init_calendar();
    $('.courses-list a').click ->
      $('.course-description').show()
      $('html, body').scrollTop $('.course-description').offset().top
      false


  init_slideshow: ->
    $('.cycle-slideshow').cycle slides: '.s-item'
    $('.image-link').magnificPopup
      type: 'image'
      showCloseBtn: false
      gallery:
        enabled: true
        navigateByImgClick: true
  init_calendar: ->
    codropsEvents =
      '10-02-2015': '<p>Reading group</p> <b>19:00</b>'
      '10-03-2015': '<p>English through Games</p> <b>19:00</b>'
      '10-04-2015': '<p>Reading group</p> <b>19:00</b>'
      '12-31-2015': '<span>New Year\'s Eve</span>'

    cal = $('#calendar').calendario(
      onDayClick: ($el, $contentEl, dateProperties) ->
        for key of dateProperties
          console.log key + ' = ' + dateProperties[key]
        return
      caldata: codropsEvents
      weeks: [
        'Неділя'
        'Понеділок'
        'Вівторок'
        'Середа'
        'Четвер'
        'Пятниця'
        'Субота'
      ]
      weekabbrs: [
        'Нед'
        'Пон'
        'Вівт'
        'Сер'
        'Чет'
        'Пятн'
        'Суб'
      ]
      months: [
        'січень'
        'Лютий'
        'Березень'
        'Квітень'
        'Травень'
        'Червень'
        'Липень'
        'Серпень'
        'Вересень'
        'Жовтень'
        'Листопад'
        'Грудень'
      ]
      monthabbrs: [
        'Січ'
        'Лют'
        'Бер'
        'Кві'
        'Тра'
        'Чер'
        'Лип'
        'Серп'
        'Вер'
        'Жовт'
        'Лист'
        'Гру'
      ])
    $month = $('#custom-month').html(cal.getMonthName())
    $('#custom-next').on 'click', ->
      cal.gotoNextMonth updateMonthYear
      return
    $('#custom-prev').on 'click', ->
      cal.gotoPreviousMonth updateMonthYear
      return
    $('#custom-current').on 'click', ->
      cal.gotoNow updateMonthYear
      return
