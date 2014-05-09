define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.directives").directive("points", function () {
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
                    if (newValue === 'undefined' && scope.standard === 'undefined') {
                        return;
                    }

                    newValue = parseInt(newValue);
                    if (newValue > 0) {
                        scope.class = "positive";
                        scope.value = "+" + newValue.toString();
                        return;
                    } else if (newValue === 0) {
                        scope.class = "nil";
                        scope.value = "0";
                        return;
                    }

                    scope.standard = parseInt(scope.standard);
                    if (scope.standard > 0) {
                        scope.class = "positive";
                        scope.value = "+" + scope.standard.toString();
                    } else if (scope.standard === 0) {
                        scope.class = "nil";
                        scope.value = "0";
                    }

                });
            },
            controller: function ($scope) {
                if ($scope.value === 'undefined' && $scope.standard === 'undefined') {
                    return;
                }

                $scope.value = parseInt($scope.value);
                if ($scope.value > 0) {
                    $scope.class = "positive";
                    $scope.value = "+" + $scope.value.toString();
                    return;
                } else if ($scope.value === 0) {
                    $scope.class = "nil";
                    $scope.value = "0";
                    return;
                }

                $scope.standard = parseInt($scope.standard);
                if ($scope.standard > 0) {
                    $scope.class = "positive";
                    $scope.value = "+" + $scope.standard.toString();
                } else if ($scope.standard === 0) {
                    $scope.class = "nil";
                    $scope.value = "0";
                }
            }
        }
    });
});
