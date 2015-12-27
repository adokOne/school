#= require ../base_crud
angular.module("B1Admin").controller 'PagesController', [
  '$scope'
  '$controller'
  "$element"
  "ngTableParams"
  "Config"
  "$http"
  "$rootScope"
  "$modal"
  ($scope, $controller,$element,ngTableParams,Config,$http,$rootScope,$modal) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('CrudController', $scope: $scope,$element: $element)
    $scope.showReviews = (item) ->
      modalInstance = $modal.open(
        templateUrl: 'modal_reviews.html'
        controller: 'ReviewsController'
        resolve:
          item: -> item
      )
      modalInstance.result.then -> $scope.init()





]
angular.module("B1Admin").controller 'ReviewsController', [
  '$scope'
  '$controller'
  "ngTableParams"
  "Config"
  "$http"
  "$rootScope"
  "$modal"
  "$modalInstance"
  "item"
  "$resource"
  "$timeout"
  ($scope, $controller,ngTableParams,Config,$http,$rootScope,$modal,$modalInstance,item,$resource,$timeout) ->
    # Initialize the super class and extend it.





    console.log(item)



    $timeout (->

      $scope.Item = $resource("#{$scope.url}/:id.json",{},{query:{isArray:false},update:{ method:'PUT' }})
      if angular.element("#modalitemsTable").length
        $scope.itemsTable = new ngTableParams(
          page: 1
          count: Config.perPage
          total: 0
        ,
          counts: []
          getData: ($defer, params) ->
            $scope.itemsPromise = $scope.Item.query(
                filters:
                  page_id: item.id
                page: params.page()
              ).$promise.then (data) ->
              params.total(data.total)
              $scope.data = data.items

        )


    ), 150

    loadItems = ->
      $scope.itemsTable.reload()

    $scope.page = item


    $scope.cancel = ->
      $modalInstance.dismiss "cancel"

    $scope.accept = (item) ->
      $scope.Item.update {id:item.id},{item:item}, (resp) ->
        loadItems() if resp.success
      , ->
        $rootScope.error(alertSelector,$rootScope.server_error)

    $scope.destroy = (item) ->
      console.log(item)
      data =
        id: item.id
        title: "Точно удалить отзыв?"
      $rootScope.confirm(data).result.then ((result) ->
        $rootScope.showLoader()
        $scope.Item.delete {id:item.id}, (resp) ->
          loadItems() if resp.success
          $rootScope.info(alertSelector,resp.msg)
          $anchorScroll()
      )

]

