define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.controllers").controller("AppCtrl", [
        "$rootScope",
        function ($rootScope) {
            $rootScope.customers = [];
        }
    ]);
});
