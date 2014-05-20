define(["angular", "jquery", "perfectScrollbar", "hectic"], function (angular, jQuery) {
    "use strict";

    angular.module("app.directives").directive("perfectScrollbar", function () {
        return {
            restrict: "A",
            link: function (scope, elem, attrs) {
                jQuery(elem).perfectScrollbar();
            }
        }
    });
});
