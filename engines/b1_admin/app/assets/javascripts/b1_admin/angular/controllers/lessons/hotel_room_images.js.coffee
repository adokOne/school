angular.module("B1Admin").controller 'HotelRoomImagesCtrl', [
  '$scope'
  'FileUploader'
  "$element"
  "$resource"
  "$rootScope"
  "$timeout"
  ($scope, FileUploader,$element,$resource,$rootScope,$timeout) ->
    url = "#{$element.data("image-url")}/:id.json"
    $scope.Image = $resource(url,{},{query:{isArray:false},update:{ method:'PUT' }})
    $scope.images = []
    $scope.image = null
    carousel = angular.element('.carousel')

    set_image_data = ->
      $timeout (
        ->
          el_active = carousel.find('.active')
          id = el_active.data('img-id')
          index = el_active.index()
          console.log id, index
          for image in $scope.images
            $scope.image = image if image.id ==  id
      ), 700
      return false

    $scope.update_image_data = ($event)->
      console.log($scope.image)
      $scope.Image.update {id:$scope.image.id},{item:$scope.image}, (resp) ->
        angular.forEach $scope.images, (image)->
          image.main_image = false unless image.id == $scope.image.id
      return false
    $scope.image_click = ($index, image)->
      $scope.scroll_to_image($index);
      $scope.show_image_popup(image);
      return false


    $scope.scroll_to_image = ($index)->
      carousel.carousel($index)
      set_image_data()
      return false

    $scope.click_image_upload = ->
      angular.element('#hidden-file-input').click();
      return

    $scope.getImages = ->
      $scope.Image.query().$promise.then (data) ->
        $scope.images = data.items
        $scope.image = $scope.images[0]
    $scope.hotel_image_uploader = new FileUploader
      removeAfterUpload : true,
      autoUpload : true

    $scope.hotel_image_uploader.onBeforeUploadItem = (item) ->
      item.url = url.replace(":id", '').replace(".json","upload")
      item.formData.push($scope.fileupload)


    $scope.hotel_image_uploader.onCompleteAll = ->
      $scope.getImages()


    $scope.galleryPrev = ->
      set_image_data()
      carousel.carousel('prev')
      return false


    $scope.galleryNext = ->
      set_image_data()
      carousel.carousel('next')
      return false


    $scope.delete = ($event, item) ->
      $event.preventDefault()
      data =
        id: item.id
        title: $element.data("deleteText")
      $rootScope.confirm(data).result.then ((result) ->
        $rootScope.showLoader()
        $scope.Image.delete {id:item.id}, (resp) ->
          $scope.getImages() if resp.success
      )

    $scope.show_image_popup = (item) ->
      $scope.src_image_popup = item.image_url
      angular.element('#image_popup').modal('show')

]
