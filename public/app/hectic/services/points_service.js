define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.services").service("PointsService", [
        "$http",
        "$q",
        function ($http, $q) {
            this.findAll = function (_id) {
                var deferred = $q.defer();

                $http({ method: "GET", url: "/v1/customers/:id/points/".replace(":id", _id) })
                    .success(function (data) {
                        deferred.resolve(data);
                    })
                    .error(function (reason) {
                        deferred.reject;
                    });

                return deferred.promise;
            };

            this.getLatest = function (_id) {
                var deferred = $q.defer();

                $http({ method: "GET", url: "/v1/customers/:id/points/latest/".replace(":id", _id) })
                    .success(function (data) {
                        deferred.resolve(data);
                    })
                    .error(function (reason) {
                        deferred.reject;
                    });

                return deferred.promise;
            };

            this.create = function (_id, transaction) {
                var deferred = $q.defer();

                $http({ method: "POST", data: transaction, url: "/v1/customers/:id/points/".replace(":id", _id) })
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
