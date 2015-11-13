#= require ./base_crud
angular.module("B1Admin").controller 'LessonsController', [
  '$scope'
  '$controller'
  "$element"
  "$resource"
  "$timeout"
  "$rootScope"
  "$modal"
  ($scope, $controller, $element, $resource, $timeout, $rootScope, $modal) ->
# Initialize the super class and extend it.
    window.TariffController = $scope
    $.extend this, $controller('CrudController', $scope: $scope, $element: $element)

    $scope.date_delta = {weeks: 2}
    $scope.date_start = moment()
    $scope.today = new Date();
    $scope.date_end   = $scope.date_start.clone().add($scope.date_delta)
    $resource("#{$element.data("courses-url")}.json").get {}, (response)->
      $scope.courses = response.items


    $scope.init = ->
      $scope.itemsPromise = $scope.Item.query().$promise.then (data) ->
        $scope.lessons = data.items
      $timeout (->
        $scope.build_calendar()
      ), 300

      return

    $scope.set_month = (month)->
      $scope.date_start = month.clone()
      $scope.date_end = $scope.date_start.clone().add($scope.date_delta)
      $scope.init()
      return

    $scope.build_calendar = ->
      $scope.calendar =
        months: []
        header_months: []

      last_year = null
      moment.range(moment().startOf('month'), moment().add(12, 'months').endOf('month')).by 'month', (month)->
        curr_year = month.format('YYYY')
        _month =
          year: if last_year == curr_year then '' else curr_year
          month: month.format('MMM')
          moment: month
        last_year = curr_year

        $scope.calendar.header_months.push _month

      moment.range($scope.date_start, $scope.date_end).by 'day', (day)->
        month_code = day.format('YYYY-MM')
        [...,last_month] = $scope.calendar.months
        if not last_month? || (last_month? and last_month.code isnt month_code)
          $scope.calendar.months.push
            code: month_code
            moment: day.clone()
            days: []
          [...,last_month] = $scope.calendar.months
        last_month.days.push day.clone()
        return
      return $scope.calendar


    $scope.is_blocked_day = (day)->
      day.isBefore($scope.today, 'day')

    $scope.mouse_select = { is_mouse_down: false, tariff_id: '' }
    $scope.mousedown = ($event, day)->
      return if $scope.is_blocked_day day
      element = angular.element($event.target)
      cell = element.closest('td')
      $scope.mouse_select.is_mouse_down = true
      $scope.mouse_select.tariff_id = element.data('tariff_id')
      cell.addClass('selected')
      return



    $scope.mouseup = ($event)->
      return if $scope.mouse_select.is_mouse_down == false
      $scope.mouse_select.is_mouse_down = false
      first_element = angular.element('.tariffs td.selected div.tariff').first()
      item = first_element.data("item")
      angular.element('table.tariffs td.selected').removeClass('selected')
      $scope.show_modal_add_diapason(item)
      return



    $scope.mouseover = ($event)->
      element = angular.element($event.target)
      if $scope.mouse_select.is_mouse_down and $scope.mouse_select.tariff_id == element.data('tariff_id')
        cell = element.closest('td')
        cell.addClass('selected')
      return


    $scope.lesson_for_day_and_course = (date, course)->
      unless $scope.lessons
        $scope.itemsPromise = $scope.Item.query().$promise.then (data) ->
          $scope.lessons = data.items

      lesson = $scope.lessons[course.id]
      lesson = if lesson then lesson[date] else false
      lesson = if lesson then lesson.list else false
      id = if lesson then lesson.id else false
      date = if lesson then lesson.date else date
      time = if lesson then lesson.time else "00:00"
      item =
        course_name: course.name
        course_id: course.id
        date: date
        time: time
        id: id

      return item

    $scope.show_modal_add_diapason = (item)->
      modalInstance = $modal.open(
        templateUrl: 'modal_add_diapason.html'
        controller: 'ModalAddDiapasonController'
        resolve:
          item: -> item

      )
      modalInstance.result.then -> $scope.init()
      return


    $scope.filter = ->
      $scope.hotel_id = $scope.filters.hotel_id
      $scope.init()
      return

    $scope.is_weekend = (date)->
      if date.weekday() in [5, 6] then true else false


    $scope.scroll_left = ->
      $scope.date_start.subtract($scope.date_delta)
      $scope.date_end.subtract($scope.date_delta)
      $scope.init()
      return

    $scope.scroll_right = ->
      $scope.date_start.add($scope.date_delta)
      $scope.date_end.add($scope.date_delta)
      $scope.init()
      return


    $scope.destroy_tariff = (tariff)->
      return unless confirm $element.data("delete-text")
      Tariff = $resource("#{$element.data("url")}/#{$scope.hotel_id}.json", {tariff_id: tariff.id}, {destroy: {method: 'DELETE'}})
      new Tariff()
      .$destroy (response)->
        $scope.init()
        return
      return

    $timeout (->
      $scope.init()
    ), 100


]

