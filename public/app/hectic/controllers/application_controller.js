define(["angular", "async", "moment", "hectic"], function (angular, async, moment) {
    "use strict";

    angular.module("app.controllers").controller("AppCtrl", [
        "$rootScope",
        "CustomersService",
        "PointsService",
        function ($rootScope, CustomersService, PointsService) {
            moment.lang('en', {
                relativeTime : {
                    future: "in %s",
                    past: "%s",
                    s:  "sec",
                    m:  "1m",
                    mm: "%dm",
                    h:  "1h",
                    hh: "%dh",
                    d:  "1d",
                    dd: "%dd",
                    M:  "1m",
                    MM: "%dm",
                    y:  "1y",
                    yy: "%dy"
                }
            });

            $rootScope.customers = [];
            $rootScope.moment = moment;

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
