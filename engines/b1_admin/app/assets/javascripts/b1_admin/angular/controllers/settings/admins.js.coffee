#= require ../base_crud
angular.module("B1Admin").controller 'AdminsController', [
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

    $scope.statusColors = 
      1: "#4EAE32"
      2: "#EED80B"
      3: "#D85C28"
      4: "#FF0101"
      
    if angular.element("#subitemsTable").length
      $scope.subitemsTable = new ngTableParams(
        page: 1 
        count: Config.perPage
        total: 0
      ,
        counts: []
        getData: ($defer, params) ->
          $http.post($element.data("historyUrl"), {id: $scope.editedItem.id,page: params.page()}).success (resp) ->
            if resp.success
              params.total(resp.total)
              $scope.subData = resp.items

      )

    setChecked = (modId,type) ->
      type = type or false
      angular.forEach $scope.roles, ((role) ->
        delete($scope.editedItem.roles[role.id]) unless type
        $scope.editedItem.roles[role.id] = true if type
      )


    $scope.uncheckAll = (roleId) ->
      setChecked(roleId)
    $scope.checkAll = (roleId) ->
      setChecked(roleId,true)

    $scope.beforeSave = ->
      $scope.editedItem.role_ids = Object.keys($scope.editedItem.roles).filter (key) -> $scope.editedItem.roles[key] is true

]