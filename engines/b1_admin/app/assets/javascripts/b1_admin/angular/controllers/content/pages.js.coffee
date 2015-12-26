#= require ../base_crud
angular.module("B1Admin").controller 'PagesController', [
  '$scope'
  '$controller'
  "$element"
  "ngTableParams"
  "Config"
  "$http"
  "$rootScope"
  ($scope, $controller,$element,ngTableParams,Config,$http,$rootScope) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('CrudController', $scope: $scope,$element: $element)

    $scope.beforeSave = ->
      $scope.editedItem.categories_ids = Object.keys($scope.editedItem.categories).filter (key) -> $scope.editedItem.categories[key] is true
      $scope.editedItem.cities_ids = Object.keys($scope.editedItem.cities).filter (key) -> $scope.editedItem.cities[key] is true

]
