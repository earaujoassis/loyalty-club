define(["angular"], function (angular) {
    "use strict";

    angular.module("app.controllers", []);
    angular.module("app.services", []);
    angular.module("app.directives", []);

    var module = angular.module("app", [
        "ngRoute",
        "ngResource",
        "ngSanitize",
        "ui.router",
        "app.controllers",
        "app.services",
        "app.directives"
    ]);

    module.config([
        "$routeProvider",
        "$locationProvider",
        "$httpProvider",
        function ($routeProvider, $locationProvider, $httpProvider) {
            $locationProvider.html5Mode(true);
            $routeProvider
                .when("/", {
                    controller: "CustomersController",
                    templateUrl: "/app/hectic/views/customers_index.html",
                    public: true
                })
                .when("/customers/:id/points", {
                    controller: "PointsController",
                    templateUrl: "/app/hectic/views/customer_points.html",
                    public: true
                });

            $httpProvider.defaults.headers.post["Content-Type"] = "application/x-www-form-urlencoded;charset=utf-8";

            var param = function (obj) {
                var query = ""
                  , name
                  , value
                  , fullSubName
                  , subName
                  , subValue
                  , innerObj
                  , i
                  , length;

                for (name in obj) {
                    value = obj[name];

                    if (value instanceof Array) {
                        for (i = 0, length = value.length; i < length; i += 1) {
                            subValue = value[i];
                            fullSubName = name + "[" + i + "]";
                            innerObj = {};
                            innerObj[fullSubName] = subValue;
                            query += param(innerObj) + "&";
                        }
                    }
                    else if (value instanceof Object) {
                        for (subName in value) {
                            subValue = value[subName];
                            fullSubName = name + "[" + subName + "]";
                            innerObj = {};
                            innerObj[fullSubName] = subValue;
                            query += param(innerObj) + "&";
                        }
                    }
                    else if (value !== undefined && value !== null)
                        query += encodeURIComponent(name) + "=" + encodeURIComponent(value) + "&";
                }

                return query.length ? query.substr(0, query.length - 1) : query;
            };


            $httpProvider.defaults.transformRequest = [function(data) {
                return angular.isObject(data) && String(data) !== "[object File]" ? param(data) : data;
            }];

        }
    ]);

    return module;
});
