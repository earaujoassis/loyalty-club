define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.controllers").controller("CustomersController", [
        "$scope",
        "$rootScope",
        "$location",
        "CustomersService",
        function ($scope, $rootScope, $location, CustomersService) {
            $scope.customer = {};

            $scope.saveCustomer = function (customer) {
                customer = angular.copy(customer);
                CustomersService
                    .create(customer)
                    .then(function (value) {
                        if (!!value.id) {
                            $scope.customer = {};
                            $rootScope.customers.unshift(value);
                            $location.path("/");
                        }
                    });
            };
        }
    ]);
});
