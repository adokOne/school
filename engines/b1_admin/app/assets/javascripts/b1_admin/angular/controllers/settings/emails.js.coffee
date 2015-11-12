#= require ../base_crud
angular.module("B1Admin").controller 'EmailsController', [
  '$scope'
  '$controller'
  "$element"
  ($scope, $controller,$element) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('CrudController', $scope: $scope,$element: $element)

    $scope.beforeSave = ->
      tags = []
      if $scope.editedItem
        angular.forEach Object.keys($scope.editedItem.tags), ((id) ->
          tags.push(id) if $scope.editedItem.tags[id] && id.length > 1
        )
      $scope.editedItem.available_tags = tags
]
