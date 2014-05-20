define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.services").service("CustomersService", [
        "$http",
        "$q",
        function ($http, $q) {
            this.findAll = function () {
                var deferred = $q.defer();

                $http({ method: "GET", url: "/v1/customers/" })
                    .success(function (data) {
                        deferred.resolve(data);
                    })
                    .error(function (reason) {
                        deferred.reject;
                    });

                return deferred.promise;
            };

            this.get = function (_id) {
                var deferred = $q.defer();

                $http({ method: "GET", url: "/v1/customers/" + _id })
                    .success(function (data) {
                        deferred.resolve(data);
                    })
                    .error(function (reason) {
                        deferred.reject;
                    });

                return deferred.promise;
            };

            this.create = function (customer) {
                var deferred = $q.defer();

                $http({ method: "POST", data: customer, url: "/v1/customers/" })
                    .success(function (data) {
                        deferred.resolve(data);
                    })
                    .error(function (reason) {
                        deferred.reject;
                    });

                return deferred.promise;
            };
        }
    ]);
});
