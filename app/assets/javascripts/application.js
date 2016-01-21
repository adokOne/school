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




//= require jquery-1.9.1.min
//= require jquery-ui
//= require bootstrap
//= require jquery-1.7.2.min
//= require jquery-ui-1.10.4.custom.min



//= require icheck
//= require jquery.selectbox-0.2.min
//= require jquery.mask

//= require ./summernote
//= require jquery.validate
//= require ./protos
//= require ./inflector
//= require ./i18n
//= require validation_rules
//= require ./controllers/jquery.mvc
//= require_tree ./controllers
//= require ./script.js
//= require input_functions
//= require ./theme/cherry-api
//= require_tree ./theme

Array.prototype.list = function()
{
    var
        limit = this.length,
        orphans = arguments.length - limit,
        scope = orphans > 0  && typeof(arguments[arguments.length-1]) != "string" ? arguments[arguments.length-1] : window
    ;

    while(limit--) scope[arguments[limit]] = this[limit];

    if(scope != window) orphans--;

    if(orphans > 0)
    {
        orphans += this.length;
        while(orphans-- > this.length) scope[arguments[orphans]] = null;
    }
}
$(".wpcf7-phone").mask("+38(999) 999 99 99");
