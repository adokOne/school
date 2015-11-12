#= require ../base_crud
angular.module("B1Admin").controller 'RolesController', [
  '$scope'
  '$controller'
  "$element"
  ($scope, $controller,$element) ->
    # Initialize the super class and extend it.
    $.extend this, $controller('CrudController', $scope: $scope,$element: $element)

    setChecked = (modId,type) ->
      type = type or false
      angular.forEach $scope.modules, ((mod) ->
        angular.forEach mod.childs, ((mod) ->
          if mod.id is modId
            angular.forEach mod.permissions, ((perm) ->
              delete($scope.editedItem.permissions[perm.id]) unless type
              $scope.editedItem.permissions[perm.id] = true if type
            )
        )
      )

    $scope.uncheckAll = (modId) ->
      setChecked(modId)
    $scope.checkAll = (modId) ->
      setChecked(modId,true)

    $scope.beforeSave = ->
      modules = []
      permissions = []
      _permissions = []
      angular.forEach Object.keys($scope.editedItem.permissions), ((id) ->
        _permissions.push(id) if $scope.editedItem.permissions[id]
      )
      angular.forEach $scope.modules, ((parentMod) ->
        angular.forEach parentMod.childs, ((mod) ->
          angular.forEach mod.permissions, ((perm) ->
            if _permissions.indexOf(String(perm.id)) >= 0
              modules.push(parentMod.id)
              modules.push(mod.id)
              permissions.push(perm.id)
          )
        )
      )
      $scope.editedItem.permission_ids = permissions
      $scope.editedItem.module_ids     = modules.unique()
]