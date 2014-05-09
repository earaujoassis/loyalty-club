define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.controllers").controller("CustomersController", [
        "$rootScope",
        "CustomersService",
        function ($rootScope, CustomersService) {
            CustomersService
                .findAll()
                .then(function (value) {
                    $rootScope.customers = value;
                });
        }
    ]);
});
