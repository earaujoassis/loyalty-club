define(["angular", "hectic"], function (angular) {
    "use strict";

    angular.module("app.controllers").controller("PointsController", [
        "$scope",
        "$routeParams",
        "$location",
        "CustomersService",
        "PointsService",
        function ($scope, $routeParams, $location, CustomersService, PointsService) {
            $scope.customer = {};
            $scope.latest_transaction = {};
            $scope.history_transactions = [];
            $scope.transaction = {};

            if ($routeParams.id) {
                CustomersService
                    .get($routeParams.id)
                    .then(function (value) {
                        $scope.customer = value;
                    });

                PointsService
                    .getLatest($routeParams.id)
                    .then(function (value) {
                        $scope.latest_transaction = value;
                    }, function (reason) {
                        /* FIX Create an interceptor for the 404 error */
                    });

                PointsService
                    .findAll($routeParams.id)
                    .then(function (value) {
                        $scope.history_transactions = value;
                    });
            }

            $scope.saveTransaction = function (transaction) {
                var balance
                  , currentPoints;

                if (!$routeParams.id) {
                    return;
                }
                transaction = angular.copy(transaction);
                balance = parseInt(transaction.balance);
                if (!!$scope.latest_transaction.id) {
                    currentPoints = parseInt($scope.latest_transaction.current_points);
                    if (currentPoints + balance < 0) {
                        $scope.overAttempting = true;
                        return;
                    }
                } else {
                    if (balance < 0) {
                        $scope.overAttempting = true;
                        return;
                    }
                }
                PointsService
                    .create($routeParams.id, transaction)
                    .then(function (value) {
                        /* FIX Create an interceptor for the 406 error */
                        if (!!value.id) {
                            $scope.latest_transaction = value;
                            $scope.history_transactions.unshift(value);
                            $scope.transaction = {};
                        }
                    });
            };
        }
    ]);
});
