// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//




//= require ./click/jquery-1.11.3.min
//= require ./click/jquery-migrate-1.2.1.min
//= require ./click/bootstrap
//= require ./click/lightslider
//= require ./click/script
//= require ./click/jquery.mb.YTPlayer
//= require ./click/jquery.slicknav.min
//= require ./click/jquery.validate.min
//= require ./controllers/jquery.mvc
//= require ./controllers/click
//= require_self

$(document).ready(function() {
  return $("*[data-ctrl]").each(function() {
    var controllers, i, plg, result, results;
    controllers = $(this).data("ctrl").split(" ");
    i = 0;
    results = [];
    while (i < controllers.length) {
      if (plg = $(this)["attach" + controllers[i]]) {
        result = plg.call($(this));
      }
      results.push(i++);
    }
    return results;
  });
});
