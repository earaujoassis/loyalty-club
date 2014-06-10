define(["angular", "async", "moment", "jquery", "hectic"], function (angular, async, moment, jQuery) {
    "use strict";

    var CUSTOMERS_BROADCAST = "e:customers";

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
                    M:  "1mo",
                    MM: "%dmo",
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
                        $rootScope.$broadcast(CUSTOMERS_BROADCAST);
                        if (!err) {
                            $rootScope.customers = results;
                        }
                    });
                });

            $rootScope.renderCustomersList = function (elem) {
                if (jQuery(elem).is(".scrollbar-container")) {
                    var windowHeight = jQuery(window).height()
                      , mainHeaderHeight = jQuery(".main-header").outerHeight()
                      , parent = jQuery(elem)
                      , updateContent = function () {
                            var length = jQuery(".customer-container", parent).length
                              , customersUlHeight = jQuery(".customers", parent).outerHeight();
                            jQuery(".content", parent).css("height", ((customersUlHeight) + "px"));
                            jQuery(elem).perfectScrollbar("update");
                      };

                    parent.css("max-height", ((windowHeight - mainHeaderHeight) + "px"));
                    $rootScope.$on(CUSTOMERS_BROADCAST, function () {
                        updateContent();
                    });
                }
            };
        }
    ]);
});
