#= require ../base_crud
angular.module("B1Admin").controller 'EmailsController', [
  '$scope'
  '$controller'
  "$element"
  ($scope, $controller,$element) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('', $scope: $scope,$element: $element)

]
