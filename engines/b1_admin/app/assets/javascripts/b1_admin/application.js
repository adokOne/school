//= require jquery
//= require underscore
//= require angular
//= require angular-animate
//= require angular-resource
//= require angular-route
//= require angular-ui-bootstrap
//= require angular-ui-bootstrap-tpls
//= require ./angular-locale_uk-ua
//= require ./vendor/moment-with-locales
//= require ./vendor/moment-range
//= require ./vendor/pace.min
//= require ./vendor/angular-ui-tree
//= require ./vendor/bootstrap.min
//= require ./vendor/plug
//= require ./vendor/ng-table
//= require ./vendor/angular-bootstrap-switch
//= require ./vendor/angular-sanitize
//= require ./vendor/compareTo
//= require ./vendor/angular-busy
//= require ./vendor/datetimepicker
//= require ./vendor/daterangepicker
//= require ./vendor/angular-autocomplete
//= require ./vendor/ng-flow-standalone.min
//= require ./vendor/angular-file-upload
//= require ./vendor/select
//= require ./vendor/dropdown-enhancement
//= require ./vendor/xeditable.min
//= require ./angular/app
//= require_tree ./angular/.
//= require_self



Array.prototype.unique = function() {
    var newArr = [],
        origLen = this.length,
        found, x, y;

    for (x = 0; x < origLen; x++) {
        found = undefined;
        for (y = 0; y < newArr.length; y++) {
            if (this[x] === newArr[y]) {
                found = true;
                break;
            }
        }
        if (!found) {
            newArr.push(this[x]);
        }
    }
    return newArr;
};

window.paceOptions = {
  // Disable the 'elements' source
  elements: false,

  // Only show the progress on regular and ajax-y page navigation,
  // not every request
  restartOnRequestAfter: false
}
