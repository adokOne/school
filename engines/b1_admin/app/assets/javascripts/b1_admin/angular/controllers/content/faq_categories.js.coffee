#= require ../base_crud
angular.module("B1Admin").controller 'FaqCatController', [
  '$scope'
  '$controller'
  "$element"
  ($scope, $controller,$element) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('CrudController', $scope: $scope,$element: $element)

    getRootNodesScope = ->
      angular.element(document.getElementById("tree-root")).scope()

    loadItems = ->
      $scope.Item.query().$promise.then (data) ->
        $scope.items = data.items
        $scope.itemsClone = angular.copy($scope.items)

    $scope.collapse = ->
      scope = getRootNodesScope()
      scope.collapseAll()

    $scope.expand = ->
      scope = getRootNodesScope()
      scope.expandAll()

    $scope.revert = ->
      $scope.items = angular.copy($scope.itemsClone)

    $scope.show = (item) ->
      scope = angular.element(document.getElementById("items")).scope()
      scope.filters.category_id = item.id
      scope.itemsTable.reload()

    loadItems()
]
