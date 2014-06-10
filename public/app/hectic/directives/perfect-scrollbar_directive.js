define(["angular", "jquery", "perfectScrollbar", "hectic"], function (angular, jQuery) {
    "use strict";

    angular.module("app.directives").directive("perfectScrollbar", [
        '$parse',
        function ($parse) {
            return {
                link: function (scope, elem, attrs) {
                    var invoker = $parse(attrs.invoke);
                    jQuery(elem).perfectScrollbar();
                    if (!!invoker) {
                        invoker(scope, { elem: elem });
                    }
                }
            }
        }
    ]);
});
