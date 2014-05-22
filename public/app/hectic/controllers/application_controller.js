define(["angular", "async", "hectic"], function (angular, async) {
    "use strict";

    angular.module("app.controllers").controller("AppCtrl", [
        "$rootScope",
        "CustomersService",
        "PointsService",
        function ($rootScope, CustomersService, PointsService) {
            $rootScope.customers = [];

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
        }
    ]);
});
