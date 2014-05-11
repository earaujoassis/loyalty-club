define(["angular", "async", "hectic"], function (angular, async) {
    "use strict";

    angular.module("app.controllers").controller("CustomersController", [
        "$scope",
        "$rootScope",
        "$location",
        "CustomersService",
        "PointsService",
        function ($scope, $rootScope, $location, CustomersService, PointsService) {
            $scope.customer = {};

            CustomersService
                .findAll()
                .then(function (value) {
                    $rootScope.customers = value;

                    async.mapSeries($rootScope.customers, function (customer, callback) {
                        PointsService
                            .getLatest(customer.id)
                            .then(function (value) {
                                customer.points = value;
                                callback(null, customer);
                            });
                    }, function (err, results) {
                        if (!err) {
                            $rootScope.customers = results;
                        }
                    });
                });

            $scope.saveCustomer = function (customer) {
                customer = angular.copy(customer);
                CustomersService
                    .create(customer)
                    .then(function (value) {
                        if (!!value.id) {
                            $scope.customer = {};
                            //$rootScope.customers.unshift(value);
                            $location.path("/");
                        }
                    });
            };
        }
    ]);
});
