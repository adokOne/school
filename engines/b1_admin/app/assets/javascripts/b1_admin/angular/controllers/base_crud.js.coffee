angular.module("B1Admin").controller "CrudController", [
  "$scope"
  "ngTableParams"
  "$resource"
  "$element"
  "Config"
  "$rootScope"
  "$anchorScroll"
  "$http"
  "$timeout"
  ($scope,ngTableParams,$resource,$element,Config,$rootScope,$anchorScroll,$http,$timeout) ->

    window.CrudController = $scope
    alertSelector = "#content-container"
    $scope.filters = {}
    $scope.trueFalseArr = [{id:true, name:'Да'}, {id:false, name:'Нет'}]
    filtersClone = angular.copy $scope.filters
    text_area_name = "desc"
    $scope.statusColors =
      1: "#4EAE32"
      2: "#EED80B"
      3: "#D85C28"
      4: "#FF0101"

    $scope.today = new Date();
    $scope.end_year = moment().add(1, 'year');
    $scope.dateOptions =
      formatYear: 'yy',
      startingDay: 1


    $scope.status =
      opened: false
    $scope.format = 'dd.MM.yyyy'
    $scope.maximum_cloned_rows = 10
    $scope.open = ($event)->
      $event.preventDefault(); $event.stopPropagation();
      $scope.status.opened = true


    $scope.Item = $resource("#{$element.data("url")}/:id.json",{},{query:{isArray:false},update:{ method:'PUT' }})
    if angular.element("#itemsTable").length
      $scope.itemsTable = new ngTableParams(
        page: 1
        count: Config.perPage
        total: 0
      ,
        counts: []
        getData: ($defer, params) ->
          $scope.itemsPromise = $scope.Item.query(
              filters: $scope.filters
              page: params.page()
            ).$promise.then (data) ->
            params.total(data.total)
            $scope.data = data.items

      )

    setItem = (item) ->
      $scope.editedItem = item

    loadItems = ->
      $scope.itemsTable.reload()

    $scope.openupload = ->
      $timeout (->
        angular.element("#logo").click()
      ), 200

    $scope.readfile = (input) ->
      console.log(input.files)
      if input.files and input.files[0]
        reader = new FileReader

        reader.onload = (e) ->
          $(".thumbnail img").attr 'src', e.target.result
          $scope.editedItem.file = e.target.result
          $("#file").val(e.target.result)
          return

        reader.readAsDataURL input.files[0]

        # reader = new FileReader

        # reader.onload = (e) ->
        #   $scope.editedItem.file = btoa(e.target.result)
        #   return


        # reader.readAsBinaryString(input.files[0]);

        console.log( $scope.editedItem )

    saveCallback = (resp,clear) ->
      if resp.success
        $scope.itemForm.$setPristine() unless clear
        $scope.itemForm.$setUntouched() unless clear
        setItem({}) unless clear
        $rootScope.info(alertSelector,resp.msg)
        if resp.href?
          $rootScope.setRoute(resp.href)
        else
          $rootScope.setRoute($element.data("url"))
      else
        $rootScope.error(alertSelector,resp.msg)
      $anchorScroll()

    $scope.edit = (id)->
      $scope.Item.get {id:id}, (resp) ->
        setItem(resp)
      , ->
        $rootScope.error(alertSelector,$rootScope.server_error)

    $scope.destroy = (item) ->
      data =
        id: item.id
        title: "#{$element.data("deleteText")} - #{item.name}"
      $rootScope.confirm(data).result.then ((result) ->
        $rootScope.showLoader()
        $scope.Item.delete {id:item.id}, (resp) ->
          loadItems() if resp.success
          $rootScope.info(alertSelector,resp.msg)
          $anchorScroll()
      )

    $scope.save = ->
      setFromEditor()
      $scope.beforeSave()
      $scope.itemForm.$setSubmitted()
      console.log($scope.itemForm)
      if $scope.itemForm.$valid
        $rootScope.showLoader()

        if $scope.editedItem.id
          console.log($scope.editedItem.id)
          $scope.Item.update {id:$scope.editedItem.id},{item:$scope.editedItem}, (resp) ->
            saveCallback(resp,true)
          , ->
            $rootScope.error(alertSelector,$rootScope.server_error)
        else
          $scope.Item.save {item:$scope.editedItem}, (resp) ->
            saveCallback(resp)
          , ->
            $rootScope.error(alertSelector,$rootScope.server_error)
    $scope.filter = ->
      $scope.itemsTable.page(1)
      $scope.itemsTable.reload()

    $scope.reset = ->
      $scope.itemsTable.page(1)
      $scope.filters = angular.copy filtersClone
      $scope.itemsTable.reload()
      $rootScope.updateSelect(200)

    setFromEditor = ->
      text_area_name = if $scope.editedItem && $scope.editedItem.text_area_name then $scope.editedItem.text_area_name else text_area_name
      angular.forEach angular.element(".summernote"), ((item) ->
        item = angular.element(item)
        if Config.with_locales || $scope.withLocales
          if $scope.editedItem && $scope.editedItem.is_mongoid_localize
            $scope.editedItem["#{text_area_name}_translations"]["#{item.data("lang")}"] = item.summernote( "code" )
          else
            $scope.editedItem["#{text_area_name}_#{item.data("lang")}"] = item.summernote( "code" )
        else
          $scope.editedItem[text_area_name] = item.summernote( "code" )
      )
    setToEditor = ->
      text_area_name = if $scope.editedItem && $scope.editedItem.text_area_name then $scope.editedItem.text_area_name else text_area_name
      angular.forEach angular.element(".summernote"), ((item) ->
        item = angular.element(item)
        if Config.with_locales || $scope.withLocales
          if $scope.editedItem.is_mongoid_localize
            item.summernote( "code", $scope.editedItem["#{text_area_name}_translations"]["#{item.data("lang")}"]) unless $scope.editedItem is undefined
          else
            item.summernote( "code", $scope.editedItem["#{text_area_name}_#{item.data("lang")}"]) unless $scope.editedItem is undefined
        else
          item.summernote( "code", $scope.editedItem[text_area_name]) unless $scope.editedItem is undefined
      )
    $rootScope.initTextRedactor()
    $timeout (->
      setToEditor()
    ), 150

    if $scope.step_id == '5'
      $timeout (->
        loadMedia()
      ), 150

    $scope.clone_row = ($event,type,key) ->
      $scope.editedItem[type].push("") if $scope.editedItem[type].length <= $scope.maximum_cloned_rows


    $scope.delete_cloned_row = ($event,type, key) ->
      $scope.editedItem[type].pop() if $scope.editedItem[type].length > 1


    $scope.beforeSave = ->
      unless $scope.clonerTypes is undefined
        angular.forEach $scope.clonerTypes, ((k,v) ->
          $scope.editedItem[k] = $scope.editedItem[v].join("|||")
        )

]
