angular.module("B1Admin").controller 'ModalAddDiapasonController', [
  '$scope'
  '$rootScope'
  "$resource"
  "$timeout"
  "$modalInstance"
  "item"
  ($scope, $rootScope, $resource, $timeout, $modalInstance, item) ->
    alertSelector = "#content-container"
    $scope.editedItem = item
    $timeout (->
      $scope.Item = $resource("#{$scope.url}/:id.json",{},{query:{isArray:false},update:{ method:'PUT' }})
    ), 150


    $scope.open = ($event, type)->
      $event.preventDefault(); $event.stopPropagation();
      $scope[type + '_opened'] = true


    $scope.cancel = ->
      $modalInstance.dismiss "cancel"


    $scope.save = ->

      $scope.itemForm.$setSubmitted()

      if $scope.itemForm.$valid
        $rootScope.showLoader()

        if $scope.editedItem.id
          $scope.Item.update {id:$scope.editedItem.id},{item:$scope.editedItem}, (resp) ->
            $modalInstance.close() if resp.success
          , ->
            $rootScope.error(alertSelector,$rootScope.server_error)
        else
          $scope.Item.save {item:$scope.editedItem}, (resp) ->
            $modalInstance.close() if resp.success
          , ->
            $rootScope.error(alertSelector,$rootScope.server_error)

]
