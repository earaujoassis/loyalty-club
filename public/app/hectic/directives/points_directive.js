define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.directives").directive("points", function () {
        var apply = function (scope, value, standard) {
            if (value === 'undefined' && standard === 'undefined') {
                return;
            }

            var values = [value, standard];
            for (var i = 0, length = values.length; i < length; i += 1) {
                var element = parseInt(values[i]);
                if (element > 0) {
                    scope.class = "positive";
                    scope.value = "+" + element.toString();
                    return;
                } else if (element === 0) {
                    scope.class = "nil";
                    scope.value = "0";
                    return;
                }
            }
        };

        return {
            scope: {
                value: "=",
                standard: "=?"
            },
            restrict: "AE",
            replace: true,
            template: '<span class="number {{ class }}">{{ value }}</span>',
            link: function (scope, elem, attrs) {
                scope.$watch("value", function (newValue) {
                    return apply(scope, newValue, scope.standard);
                });
            },
            controller: function ($scope) {
                return apply($scope, $scope.value, $scope.standard);
            }
        }
    });
});
