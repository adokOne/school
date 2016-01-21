AdminApp = angular.module("B1Admin", [
  "ngRoute"
  "ngResource"
  "ui.tree"
  "ui.bootstrap"
  "ngTable"
  "NgSwitchery"
  "pwCheck"
  "angucomplete"
  "ui.bootstrap.datetimepicker"
  "cgBusy"
  "flow"
  "ngSanitize"
  'ui.select'
  "angularFileUpload"
  "xeditable"
  ])

AdminApp.run [
    "$location"
    "$rootElement"
    "$rootScope"
    "$timeout"
    "$modal"
    "$http"
    "$compile"
    "$injector"
    ($location, $rootElement,$rootScope,$timeout,$modal,$http,$compile,$injector) ->
      #$rootElement.off "click"
      $rootScope.server_error = "Server Error"
      $rootScope.required =
        langs:
          ru: false
          en: false
          pl: false
          uk: false

      loadPluguns = ->
        $rootScope.updateSelect()
        angular.forEach angular.element("[data-switchery]"), (elem) -> new Switchery(elem)

      sendFile = (file, editor ) ->
        data = new FormData
        data.append 'file', file
        $.ajax
          data: data
          type: 'POST'
          xhr: ->
            $.ajaxSettings.xhr()
          url: '/admin/content/uploads'
          cache: false
          contentType: false
          processData: false
          success: (data) ->
            console.log(editor)
            editor.summernote('insertNode',$('<img>').attr('src', data.url)[0]);
            return
        return

      #Set xeditable directive elements ui theme
      editableOptions = $injector.get('editableOptions')
      editableThemes = $injector.get('editableThemes')
      editableThemes.bs3.inputClass = 'input-sm'
      editableThemes.bs3.buttonsClass = 'btn-sm'
      editableOptions.theme = 'bs3'







      errEl = $(".alert.alert-danger").clone()
      $rootScope.error = (selector,text) ->
      	errEl.find(".text").text(text)
      	errEl.addClass("in").show()
      	$(selector).prepend(errEl)

      sucEl = $(".alert.alert-success").clone()
      $rootScope.info = (selector,text) ->
        sucEl.find(".text").text(text)
        sucEl.addClass("in").show()
        $(selector).prepend(sucEl)

      $rootScope.updateSelect = (timeout) ->
        timeout = timeout or 100
        $timeout (->
          $('.selectpicker').selectpicker("refresh");
        ), timeout

      $rootScope.confirm = (data) ->
        $modal.open(
          templateUrl: "confirmModal.html"
          controller: "ConfirmController"
          resolve:
            params: -> data
        )
      $rootScope.showLoader = ->
        Pace.restart()

      $rootScope.setRoute = (path) ->
        $location.path(path)
        $http.get("#{path}?only_template").success (resp) ->
          if /remember_me/.test(resp)
            window.location.href = angular.element("#logout").data("href")
          angular.element("#content-container").remove()
          angular.element("#aside-container").remove()
          $content = angular.element("#main_content")
          $content.append resp
          scope = $content.scope()
          $compile($content.contents()) scope
          if angular.element("#aside-container").length
            angular.element("#container").addClass("aside-in aside-left aside-bright")
          else
            angular.element("#container").removeClass("aside-in aside-left aside-bright")
          loadPluguns()

      $rootScope.initTextRedactor = ->
        angular.element(".summernote").each ->
          summernote = $(this)
          summernote.summernote
            height: 500
            callbacks:
              onImageUpload: (files, editor, welEditable) ->
                sendFile files[0], summernote
                return

      $rootScope.changeLang = (lang) ->
        lang_element_header = angular.element(".langs-dropdown .lang-li-#{lang}")
        langs_dropdown = angular.element(".langs-dropdown .lang-selector")
        langs_dropdown.find(".lang-flag").attr("src", lang_element_header.data("src"))
        langs_dropdown.find(".lang-name").text(lang_element_header.data("name"))

        lang_elements = angular.element('.lang')
        lang_elements.hide()

        angular.forEach $rootScope.required.langs, (_, _lang)-> $rootScope.required.langs[_lang] = false
        $rootScope.required.langs[lang] = true

        angular.element(".lang_#{lang}").show()
        return

      loadPluguns()
  ]
  .config ['$logProvider', ($logProvider) ->
    $logProvider.debugEnabled true
  ]
  .config ['$locationProvider', ($locationProvider) ->
    $locationProvider.html5Mode
      enabled: true
      requireBase: false
  ]

AdminApp.factory "Config", ->
  with_locales: false
  perPage: 25
  dateFormat: "DD.MM.YYYY HH:mm"
  availableLangs: ["ru","pl","en","uk"]
  availableProviders: ["54523fbe7573652d75000000", "54929b466c6f630da9000000", "54c8fe616c6f6301381e0000", "54f0383c6c6f6376b8000000"]
AdminApp.filter 'isempty', ->
  (input, replaceText) ->
    if input
      return input
    replaceText

AdminApp.filter 'asDate', ->
  (input) ->
    new Date(input * 1000)

AdminApp.directive 'stringToNumber', ->
  {
  require: 'ngModel'
  link: (scope, element, attrs, ngModel) ->
    ngModel.$parsers.push (value) ->
      '' + value
    ngModel.$formatters.push (value) ->
      parseFloat value, 10
    return

  }
$(document).ready ->
  $(".mainnav-toggle").click (ev) ->
    $("#container").toggleClass("mainnav-sm mainnav-lg")

  $('body').on 'click', '.filter-toggler', (ev)->
    $('#content-container, aside').toggleClass('collapse_aside')
